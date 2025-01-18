import os
import logging

from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.redis import RedisVectorStore
from llama_index.embeddings.huggingface import  HuggingFaceEmbedding
from llama_index.llms.ollama import Ollama

from fastapi import FastAPI, Depends
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse

from rag_demo import custom_schema 

logger = logging.getLogger()

EMBEDDING_MODEL_NAME = os.getenv("EMBEDDING_MODEL_NAME", "BAAI/bge-small-en-v1.5")
MODEL_NAME = os.getenv("MODEL_NAME")

REDIS_HOST = os.getenv("REDIS_HOST")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))
OLLAMA_SERVER_URL = os.getenv("OLLAMA_SERVER_URL")

if OLLAMA_SERVER_URL is None:
    logger.critical("The environment variable 'OLLAMA_SERVER_URL' is not specified")
    exit(1)


app = FastAPI()


def get_query_engine():
    embed_model = HuggingFaceEmbedding(model_name=EMBEDDING_MODEL_NAME)
    vector_store = RedisVectorStore(
        schema=custom_schema,
        redis_url=f"redis://{REDIS_HOST}:{REDIS_PORT}",
    )

    index = VectorStoreIndex.from_vector_store(
        vector_store, embed_model=embed_model
    )

    llm = Ollama(
        model=MODEL_NAME,
        base_url=OLLAMA_SERVER_URL,
        #request_timeout=300,
    )
    query_engine = index.as_query_engine(llm=llm)
    return query_engine


@app.get("/invoke")
async def root(message: str, query_engine = Depends(get_query_engine)):
    response = query_engine.query(message)
    json_compatible_item_data = jsonable_encoder({"message": f"{response}"})
    return JSONResponse(content=json_compatible_item_data)
