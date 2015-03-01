defmodule EnumExTest do
  use ExUnit.Case
  
  #####
  # to_lists/3
  
  test "splits list into evenly sized lists properly" do
    list = ["A", "B", "C", "D"]
    result = EnumEx.to_lists(list, 2)
    assert result == [ ["A", "B"], ["C", "D"] ]
  end
  
  test "splits list into unevenly sized lists properly" do
    list = ["A", "B", "C", "D", "E"]
    result = EnumEx.to_lists(list, 3)
    assert result == [ ["A", "B"], ["C", "D"], ["E"] ]
  end
  
  test "does not return empty lists ensure_length: is false" do
    list = ["A", "B", "C"]
    result = EnumEx.to_lists(list, 5, ensure_length: false)
    assert result == [ ["A"], ["B"], ["C"] ]
  end
  
  test "returns empty lists if there aren't enough items" do
    list = ["A", "B", "C"]
    result = EnumEx.to_lists(list, 5)
    assert result == [ ["A"], ["B"], ["C"], [], [] ]
  end
  
  test "returns all empty lists if the input list is empty" do
    list = []
    result = EnumEx.to_lists(list, 2)
    assert result == [ [], [] ]
  end
  
  test "returns the input list inside another list if one list is requested" do
    list = ["A", "B", "C"]
    result = EnumEx.to_lists(list, 1)
    assert result == [ ["A", "B", "C"] ]
  end
  
end
