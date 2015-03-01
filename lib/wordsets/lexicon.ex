# Provides words used by a wordset engine.
defmodule Wordsets.Lexicon do

  @agent     __MODULE__
  @file_path "/usr/share/dict/words"

  #####
  # create/0
  
  def create(), 
  do: {:ok, _} = Agent.start_link &load_words/0, name: @agent
  
  #####
  # find_words/2
  
  def find_words(prefix, length) do
    Agent.get(@agent, &Dict.get(&1, prefix, []))
    |> Enum.filter(&String.length(&1) == length) 
  end

  #####
  # load_words/0
  
  defp load_words() do
    IO.puts "Loading words…"
    {time, index} = :timer.tc fn -> do_load_words |> create_index end
    :io.format "Indexed lexicon in ~3.1f seconds.~n", [(time / 1_000_000)]
    index
  end

  defp do_load_words() do
    case File.read @file_path do
      {:error,  _} -> raise "Could not read file at #{@file_path}"
      {:ok, words} -> words 
                      |> String.split("\n")
                      |> Enum.filter(&String.length(&1) > 1) # remove one-letter words
                      |> Enum.map(&String.downcase/1)        # apply uniform casing
                      |> Enum.into(HashSet.new)              # remove duplicates
                      |> Enum.to_list                        # use a list for speed
    end
  end
  
  #####
  # create_index/1
  
  defp create_index(words) do 
    1..max_length(words)
    |> Parallel.map(fn(key_length) -> do_create_index(words, key_length) end)
    |> Enum.reduce(&Dict.merge/2)
  end
  
  defp max_length(words), do: words |> Enum.map(&String.length/1) |> Enum.max
  
  defp do_create_index(words, key_length) do
    words
    |> Enum.filter(&String.length(&1) >= key_length)
    |> do_create_index(key_length, HashDict.new)
  end
  
  defp do_create_index([word | tail], key_length, index) do
    key = String.slice(word, 0, key_length)
    updated_index = Dict.update(index, key, [word], &[word | &1])
    do_create_index(tail, key_length, updated_index);
  end

  defp do_create_index([], _, index), do: index
  
end
