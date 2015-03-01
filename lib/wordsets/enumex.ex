# Contains additional functions similar to what the Enum module provdies.
defmodule EnumEx do

  #####
  # to_lists/3

  # Breaks a list into the specified number of sub-lists.
  # Attempts to fill each sub-list with the same number of elements.
  # Use the `ensure_length: false` option to avoid including empty lists 
  # when there aren't enough elements to create `number_of_lists` lists.
  def  to_lists(list, number_of_lists, options \\ [ensure_length: true]) 
  when is_list(list) 
       and 
       is_integer(number_of_lists)
       and
       number_of_lists > 0 
  do  
    count = div length(list), number_of_lists
    extra = rem length(list), number_of_lists
    lists = do_to_lists(list, count + min(extra, 1), [])
    delta = number_of_lists - length(lists)
    case options do
      [ensure_length: true]  -> lists ++ make_empty_lists(delta)
      [ensure_length: false] -> lists
    end
	  
  end
  
  defp do_to_lists([], _, acc), do: Enum.reverse acc
  
  defp do_to_lists(list, size, acc) do
    section = Enum.take list, size
    remains = Enum.take list, -max(0, length(list) - size)
    do_to_lists remains, size, [section | acc]
  end
  
  defp make_empty_lists(count)
  when count > -1,
  do:  Stream.repeatedly(fn -> [] end) |> Enum.take(count)

end
