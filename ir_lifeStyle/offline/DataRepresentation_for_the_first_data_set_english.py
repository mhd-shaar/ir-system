import csv
import os

import numpy as np
from scipy.sparse import load_npz, save_npz
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.preprocessing import normalize

current_dir = os.path.dirname(os.path.abspath(__file__))

preprocessing_file_path = os.path.join(current_dir, 'preprocessing_file.csv')
documents = []
ids = []

with open(preprocessing_file_path, 'r', encoding='utf-8') as file:
    reader = csv.reader(file)
    for row in reader:
        ids.append(row[0])
        documents.append(row[1])

vectorizer = TfidfVectorizer()

tfidf_matrix = vectorizer.fit_transform(documents)
normalized_tfidf_matrix = normalize(tfidf_matrix)
ids_array = np.array(ids)

save_npz(os.path.join(current_dir, 'normalized_tfidf_matrix.npz'), normalized_tfidf_matrix)
np.save(os.path.join(current_dir,'ids.npy'), ids_array)

with open(os.path.join(current_dir, 'feature_names.txt'), 'w', encoding='utf-8') as f:
    for feature_name in vectorizer.get_feature_names_out():
        f.write(f"{feature_name}\n")
 
normalized_tfidf_matrix = load_npz(os.path.join(current_dir,'normalized_tfidf_matrix.npz'))
ids_array = np.load(os.path.join(current_dir,'ids.npy'))
ids = ids_array.tolist()


# Load feature names with utf-8 encoding
with open(os.path.join(current_dir, 'feature_names.txt'), 'r', encoding='utf-8') as f:
    feature_names = f.read().splitlines()

# id_to_index = {doc_id: index for index, doc_id in enumerate(ids)}

# for doc, term, value in zip(normalized_tfidf_matrix.nonzero()[0], normalized_tfidf_matrix.nonzero()[1], normalized_tfidf_matrix.data):
#     doc_id = ids[doc]
#     # index = id_to_index[doc_id]
#     print(f"(doc{doc_id}, {feature_names[term]}) {value}")