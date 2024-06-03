import csv
import os
import sqlite3

current_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(current_dir, 'collection.tsv')

# Connect to SQLite database
conn = sqlite3.connect('mydatabase.db')
cursor = conn.cursor()

# Read the TSV file and insert data into the database
with open(file_path, 'r', encoding='utf-8') as file:
    reader = csv.reader(file, delimiter='\t')
    for row in reader:
        id = int(row[0])
        content = row[1]
        cursor.execute('INSERT INTO documents (id, content) VALUES (?, ?)', (id, content))

# Commit and close connection
conn.commit()
conn.close()

print("Data inserted successfully.")
