## Overview
This Elixir program implements a parallelized algorithm to discover word combinations that, when written on separate lines, read the same both horizontally and vertically. For example:
```
J O S H
O B O E
S O F A
H E A D
```
## How to run the program
Assuming you have [Elixir](http://elixir-lang.org/install.html) installed, open Terminal in this project's root directory and load its *mix.exs* file into the interactive Elixir console (IEx):
```
$ iex -S mix
```
Next set up the processing environment…
```
iex(1)> Wordsets.init  # initialize the Lexicon and Cache processes 
Loading words…
Indexed lexicon in 6.7 seconds.
:ok
```
Now search for wordsets that start with a certain word, such as *elixir*.
```
iex(2)> Wordsets.find "elixir"                                     
elixir
lately
itonia
xenian
iliahi
ryania

elixir
linene
inanga
xenial
ingate
reales

found 2 in 0.774412 seconds
:ok
```
Replace `"elixir"` with any word you like. Be aware, finding all available wordsets for some words is very fast, but for other words it can take a few seconds. I heavily optimized the search algorithm (see the [Engine](../master/lib/wordsets/engine.ex) module) and data model (see the [Lexicon](../master/lib/wordsets/lexicon.ex) module), but natural language is inherently irregular.
## Compatibility
This program has only been tested on OS X. Its source of words is the file `/usr/share/dict/words` which is included in the operating system installation by default. Windows users will need to [download the file](http://svnweb.freebsd.org/csrg/share/dict/words?view=log) and adjust the `@file_path` value in *lexicon.ex*.  

The code was written and tested with Elixir v1.0.3
