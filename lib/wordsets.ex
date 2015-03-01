defmodule Wordsets do

	alias Wordsets.Cache
	alias Wordsets.Engine
	alias Wordsets.Lexicon
	alias Wordsets.Util

  def init do
  	Lexicon.create
		Cache.create
		:ok
  end

  def find(word) do
    Cache.clear
    find_words = &Lexicon.find_words/2
    publish = &Cache.add/1
    {time, _} = :timer.tc(Engine, :search, [word, find_words, publish])
    wordsets = Cache.get
    Util.print_wordsets wordsets
    IO.puts "found #{length(wordsets)} in #{time / 1_000_000} seconds"
    :ok
  end

end
