FROM haskell:latest

WORKDIR /root

RUN cabal update

COPY . /root/

RUN cabal build -j4 haskell-wordle-exe

CMD ["bash"]