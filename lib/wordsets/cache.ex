# Stores the output of wordset engines.
defmodule Wordsets.Cache do
 
 alias Wordsets.Util
 
 @agent __MODULE__
 
  def create() do 
    {:ok, _} = Agent.start_link &HashSet.new/0, name: @agent
  end
  
  def add(words) do 
    Agent.cast @agent, fn hashset -> 
      wordset = Util.wordset_from(words)
      HashSet.put(hashset, wordset) 
    end
  end
  
  def clear(), 
  do: Agent.cast(@agent, fn _ -> HashSet.new end)
  
  def get(), 
  do: Agent.get(@agent, fn hashset -> hashset |> HashSet.to_list |> Enum.sort end)
 
end
