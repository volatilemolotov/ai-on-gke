import os
from redisvl.schema import IndexSchema


MODEL_NAME = os.getenv("MODEL_NAME", "BAAI/bge-small-en-v1.5")
REDIS_URL = os.getenv("REDIS_URL", "redis://redis-stack-service")

custom_schema = IndexSchema.from_dict(
    {
        "index": {"name": "gdrive", "prefix": "doc"},
        # customize fields that are indexed
        "fields": [
            # required fields for llamaindex
            {"type": "tag", "name": "id"},
            {"type": "tag", "name": "doc_id"},
            {"type": "text", "name": "text"},
            # custom vector field for bge-small-en-v1.5 embeddings
            {
                "type": "vector",
                "name": "vector",
                "attrs": {
                    "dims": 384,
                    "algorithm": "hnsw",
                    "distance_metric": "cosine",
                },
            },
        ],
    }
)
