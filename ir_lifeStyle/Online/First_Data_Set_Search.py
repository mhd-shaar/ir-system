import os
import sqlite3
import sys

# Adding paths for the required modules
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)

sys.path.append(os.path.join(current_dir, 'QueryPreprocessing_for_first_data_set_english.py'))
sys.path.append(os.path.join(current_dir, 'QueryRepresention_for_first_data_set_english.py'))
sys.path.append(os.path.join(current_dir, 'QueryMatching_And_Ranking_for_first_data_set_english.py'))

from QueryMatching_And_Ranking_for_first_data_set_english import calculate_similarity
from QueryPreprocessing_for_first_data_set_english import process_query
from QueryRepresention_for_first_data_set_english import generate_query_vector


def search(query_id, query_text):
    # Process the query
    processed_query = process_query(query_text)
    print(processed_query)
    print("---")

    # Generate the query vector representation
    query_id, query_vector_normalized, feature_names = generate_query_vector(query_id, processed_query)
    print("Query Vector Representation:")
    print("query_id", query_id)
    for term_index, weight in zip(query_vector_normalized.indices, query_vector_normalized.data):
        term = feature_names[term_index]
        print(f"Term: {term}, Weight: {weight}")
    print("---")

    # Calculate similarity to find relevant documents
    relevant_documents = calculate_similarity(query_vector_normalized)

    doc_ids = [doc_id for doc_id, similarity in relevant_documents]

    # Retrieve documents from the database
    documents = extract_documents_from_db(doc_ids)

    return documents

def extract_documents_from_db(doc_ids):
    db_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'mydatabase.db')
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Create a query to retrieve documents by their IDs
    doc_ids_placeholder = ', '.join('?' for _ in doc_ids)
    query = f"SELECT id, content FROM documents WHERE id IN ({doc_ids_placeholder})"

    cursor.execute(query, doc_ids)
    documents = cursor.fetchall()

    # Extract only the document contents from the fetched tuples
    document_contents = [doc[1] for doc in documents]

    conn.close()
    return document_contents

