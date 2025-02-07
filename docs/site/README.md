## Execute following command from repository root folder:

### Build static files locally:

```docker run --mount type=bind,src=./,dst=/src floryn90/hugo:ext-alpine build```


### Run website locally:

```docker run --rm -it -v $(pwd):/src -p 1313:1313 floryn90/hugo:ext-alpine server```
