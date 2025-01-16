from llama_index.core import VectorStoreIndex
from llama_index.vector_stores.redis import RedisVectorStore
from llama_index.embeddings.huggingface import HuggingFaceEmbedding

from fastapi import FastAPI, Depends
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse


from config import (
    MODEL_NAME,
    REDIS_URL,
    custom_schema,
)


app = FastAPI()


def get_query_engine():
    embed_model = HuggingFaceEmbedding(model_name=MODEL_NAME)
    vector_store = RedisVectorStore(
        schema=custom_schema,
        redis_url=REDIS_URL,
    )

    index = VectorStoreIndex.from_vector_store(
        vector_store, embed_model=embed_model
    )
    query_engine = index.as_query_engine()
    return query_engine


@app.get("/invoke")
async def root(message: str, query_engine = Depends(get_query_engine)):
    response = query_engine.query("tell me about John McCarthy and what he did")
    json_compatible_item_data = jsonable_encoder({"message": f"{response}"})
    return JSONResponse(content=json_compatible_item_data)
