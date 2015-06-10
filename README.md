# GifBot on the web!

## Things GifBot can do

Submit a new gif
```POST /gif/add```

Request a random gif and show you how many times it's been seen
```GET /gif```

See a list of all gifs
```GET /gif/all

Annotate any gif with a particular tag
```PATCH /gif/tag```

Limit lists/random gifs to a specified tag (or tags)
```GET /gif/:tag```