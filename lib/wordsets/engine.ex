# Finds word combinations that, when stacked, read the same horizontally and vertically.
defmodule Wordsets.Engine do

  # The number of sub-lists a word list is divided up into 
  # is based on how many logical processors are available.
  @sublist_count :erlang.system_info(:logical_processors)

  def search(word, find_words, publish), 
  do: do_search([String.downcase(word)], find_words, publish, String.length(word))
  
  defp do_search(words, _, publish, size) 
  when length(words) == size,
  do:  publish.(Enum.reverse words)
  
  defp do_search(words, find_words, publish, size) 
  when length(words) < size do
    prefix = make_prefix words
    find_words.(prefix, size) 
    |> EnumEx.to_lists(@sublist_count, ensure_length: false)
    |> Parallel.each(fn(word_list) -> 
         word_list 
         |> Enum.filter(&is_viable([&1 | words], find_words, size))
         |> Enum.each(&do_search([&1 | words], find_words, publish, size)) 
       end)
  end
  
  def make_prefix(words), 
  do: make_prefix_at(length(words), words)
  
  defp make_prefix_at(char_pos, words) do
    words 
    |> Enum.reverse
    |> Enum.map(&String.at(&1, char_pos)) 
    |> Enum.join("")
  end
  
  #####
  # Adaptive tail-sniffing optimization
  
  @tailsniff_threshold 5
      
  defp is_viable(_, _, size)
  when size <= @tailsniff_threshold,
  do:  true
  
  defp is_viable(words, find_words, size)
  when size > @tailsniff_threshold do
    sniff_from = -(size - @tailsniff_threshold)
    sniff_from..-1
    |> Enum.reduce(true, fn(tail_offset, is_viable) -> 
         is_viable 
         and # short-circuit to avoid unnecessary sniffs
         is_viable_at(tail_offset, words, find_words, size)
       end)
  end
  
  defp is_viable_at(tail_offset, words, find_words, size) do
    prefix = make_prefix_at (size + tail_offset), words
    words = find_words.(prefix, size)
    length(words) > 0
  end

end
