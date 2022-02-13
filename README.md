# haskell-wordle

A small command-line Wordle clone, created as a way to learn Haskell. I implemented my understanding of the semantics of Wordle, but I don't claim that it is accurate in all cases.

Credit goes to the [original Wordle](https://www.powerlanguage.co.uk/wordle/). I got the list of possible answers from [here](https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b) and the list of allowed guesses from [here](https://gist.github.com/cfreshman/cdcdf777450c5b5301e439061d29694c).

## Installing

You will need [`stack`](https://docs.haskellstack.org/en/stable/README/). The easiest way to install it is probably via [`ghcup`](https://www.haskell.org/ghcup/).

Once you have `stack`, you should be able to build and run it with `stack run`.

There's also a Dockerfile that you can use to build a container in which to play the game. Use commands like:

```
docker build -t haskell-wordle .
docker run -it --rm haskell-wordle
```
Then in the container use `cabal run haskell-wordle-exe` to play the game. (`stack` doesn't work with Apple Silicon)