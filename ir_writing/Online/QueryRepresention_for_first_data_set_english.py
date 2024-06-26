import os

import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import normalize

current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.dirname(current_dir)

feature_names_path = os.path.join(parent_dir, 'Offline', 'feature_names.txt')


def generate_query_vector(query_id, processed_text):
    with open(feature_names_path, 'r', encoding='utf-8') as f:
        feature_names = f.read().splitlines()

    vectorizer = TfidfVectorizer(vocabulary=feature_names)
    vectorizer.fit([processed_text])
    query_vector = vectorizer.transform([processed_text])
    query_vector_normalized = normalize(query_vector)

    return query_id, query_vector_normalized, vectorizer.get_feature_names_out()

# Example usage
# query_id = 1
# processed_text = "Example processed query query query text"

# query_id, query_vector_normalized, feature_names = generate_query_vector(query_id, processed_text)

# print("Query Vector Representation:")
# print("query_id", query_id)
# for term_index, weight in zip(query_vector_normalized.indices, query_vector_normalized.data):
#     term = feature_names[term_index]
#     print(f"Term: {term}, Weight: {weight}")
# print("---")
