import os

import numpy as np
from scipy.sparse import load_npz

current_dir = os.path.dirname(os.path.abspath(__file__))


ids_array = np.load(os.path.join(current_dir, 'ids.npy'))
ids = ids_array.tolist()

with open(os.path.join(current_dir, 'feature_names.txt'), 'r', encoding='utf-8') as f:
    feature_names = f.read().splitlines()
    
inverted_index = {}

normalized_tfidf_matrix = load_npz(os.path.join(current_dir, 'normalized_tfidf_matrix.npz'))
for doc, term, value in zip(normalized_tfidf_matrix.nonzero()[0], normalized_tfidf_matrix.nonzero()[1], normalized_tfidf_matrix.data):
    doc_id = ids[doc]
    term_word = feature_names[term]

    if doc_id not in inverted_index:
        inverted_index[doc_id] = []

    inverted_index[doc_id].append((term_word, value))


print("Inverted index construction complete.")

np.save(os.path.join(current_dir,'inverted_index.npy'), inverted_index)


inverted_index = np.load(os.path.join(current_dir, 'inverted_index.npy'), allow_pickle=True).item()


# for doc_id, postings in inverted_index.items():
#     print(f"Document ID: {doc_id}")
#     for term, weight in postings: ##[0]
#         print(f"Term: {term}, Weight: {weight}")
