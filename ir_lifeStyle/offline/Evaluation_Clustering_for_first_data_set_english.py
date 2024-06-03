import json
import os

import numpy as np
from scipy.sparse import csr_matrix
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

current_dir = os.path.dirname(os.path.abspath(__file__))

# Load data
inverted_index = np.load(os.path.join(current_dir, 'inverted_index.npy'), allow_pickle=True).item()
query_vectors_normalized_dict = np.load(os.path.join(current_dir, 'query_vectors_normalized_dict.npy'), allow_pickle=True).item()
with open(os.path.join(current_dir, 'feature_names.txt'), 'r', encoding='utf-8') as f:
    feature_names = np.loadtxt(f, dtype=str)
cluster_vectors = np.load(os.path.join(current_dir, 'cluster_vectors.npy'), allow_pickle=True).item()
with open(os.path.join(current_dir, 'qas.search.json'), 'r', encoding='utf-8') as f:
    qrels_data = [json.loads(line) for line in f]
output_file_path = os.path.join(current_dir,'clustering_evaluation_results.txt')

# Prepare data
term_to_index = {term: index for index, term in enumerate(feature_names)}
queries = {str(q['qid']): q['query'] for q in qrels_data}
relevant_documents = {str(q['qid']): [(str(pid), 1) for pid in q['answer_pids']] for q in qrels_data}

# Evaluation metrics
total_precision = total_precision_10 = total_recall = 0
total_average_precision = total_reciprocal_rank = 0
total_queries = len(relevant_documents)
output_lines = []

# Evaluate each query
for query_id, query_vector in query_vectors_normalized_dict.items():
    if query_id in relevant_documents:
        output_lines.append(f"Query ID: {query_id}")
        query_vector = csr_matrix(query_vector)
        similarity_scores = []

        # Compute similarity with clusters
        for cluster_id, cluster_data in cluster_vectors.items():
            cluster_vector = cluster_data['vector']
            similarity_score = cosine_similarity(query_vector, cluster_vector)[0, 0]
            similarity_scores.append((cluster_id, similarity_score))

        # Get top K clusters
        similarity_scores.sort(key=lambda x: x[1], reverse=True)
        top_k_clusters = similarity_scores[:2]
        retrieved_docs_in_clusters = []

        # Retrieve documents from top clusters
        for cluster_id, _ in top_k_clusters:
            retrieved_docs_in_clusters.extend(cluster_vectors[cluster_id]['doc_ids'])

        # Compute document similarities
        similarity_scores = []
        relevant_docs = [doc_id for doc_id, _ in relevant_documents[query_id]]
        for doc_id in retrieved_docs_in_clusters:
            if doc_id in relevant_docs:
                doc_terms_weights = inverted_index.get(doc_id)
                if doc_terms_weights:
                    doc_vector = csr_matrix((1, query_vector.shape[1]), dtype=float)
                    for term, weight in doc_terms_weights:
                        term_index = term_to_index.get(term)
                        if term_index is not None:
                            doc_vector[0, term_index] = weight
                    similarity_score = cosine_similarity(query_vector, doc_vector)[0, 0]
                    similarity_scores.append((doc_id, similarity_score))

        # Sort documents by similarity
        similarity_scores.sort(key=lambda x: x[1], reverse=True)

        # Calculate evaluation metrics
        precision = precision_10 = recall = 0
        if similarity_scores:
            precision_10 = sum(1 for doc_id, _ in similarity_scores[:10] if doc_id in relevant_docs) / 10
            precision = sum(1 for doc_id, _ in similarity_scores if doc_id in relevant_docs) / len(similarity_scores)
            recall = sum(1 for doc_id, _ in similarity_scores if doc_id in relevant_docs) / len(relevant_docs)

        total_precision += precision
        total_precision_10 += precision_10
        total_recall += recall

        # Average precision
        average_precision = num_relevant_docs = 0
        for i, (doc_id, _) in enumerate(similarity_scores):
            if doc_id in relevant_docs:
                num_relevant_docs += 1
                average_precision += num_relevant_docs / (i + 1)
        if num_relevant_docs:
            average_precision /= num_relevant_docs
        total_average_precision += average_precision

        # Reciprocal rank
        reciprocal_rank = 0
        for i, (doc_id, _) in enumerate(similarity_scores):
            if doc_id in relevant_docs:
                reciprocal_rank = 1 / (i + 1)
                break
        total_reciprocal_rank += reciprocal_rank

        # Log metrics
        output_lines.append(f"Precision@10: {precision_10:.2f}")
        output_lines.append(f"Precision: {precision:.2f}")
        output_lines.append(f"Recall: {recall:.2f}")
        output_lines.append(f"Average Precision: {average_precision:.2f}")
        output_lines.append(f"Reciprocal Rank: {reciprocal_rank:.2f}")
        output_lines.append("---")

# Mean metrics
mean_precision_10 = total_precision_10 / total_queries
mean_precision = total_precision / total_queries
mean_recall = total_recall / total_queries
mean_average_precision = total_average_precision / total_queries
mean_reciprocal_rank = total_reciprocal_rank / total_queries

output_lines.append(f"Mean Precision@10: {mean_precision_10:.2%}")
output_lines.append(f"Mean Precision: {mean_precision:.2%}")
output_lines.append(f"Mean Recall: {mean_recall:.2%}")
output_lines.append(f"Mean Average Precision: {mean_average_precision:.2%}")
output_lines.append(f"Mean Reciprocal Rank: {mean_reciprocal_rank:.2%}")

# Save results
with open(output_file_path, 'w') as f:
    f.write("\n".join(output_lines))

print("Evaluation results saved to:", output_file_path)
