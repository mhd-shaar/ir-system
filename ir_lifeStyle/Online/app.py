import os
import sys

from fastapi import FastAPI

current_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.append(current_dir)  # Append current directory to sys.path

# Import the search function from your script
from First_Data_Set_Search import search

app = FastAPI()

@app.get('/')
async def root():
    return {'example': 'This is an example', 'data': 0}

@app.post('/SearchApi/{query_id}/{query_text}')
async def SearchApi(query_id: int, query_text: str):
    SearchResult = search(query_id, query_text)
    return SearchResult

# Run the FastAPI app using Uvicorn
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
