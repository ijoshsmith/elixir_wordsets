# Helper functions used throughout the codebase.
defmodule Wordsets.Util do

  @separator "\n"

  def is_valid_wordset(wordset) do
    natural = wordset 
    |> String.split(@separator) 
    |> Enum.map(&to_char_list/1)
    
    # Zipping a list of lists is essentially a matrix rotation.
    rotated = natural 
    |> List.zip 
    |> Enum.map(&Tuple.to_list/1)
    
    natural == rotated
  end
  
  def print_wordsets(wordset_list), 
  do: wordset_list |> Enum.each(&IO.puts(&1 <> "\n"))
  
  def wordset_from(words), 
  do: Enum.join(words, @separator)

end
