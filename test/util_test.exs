defmodule UtilTest do
  use ExUnit.Case
  
  import Wordsets.Util, only:
  [
    is_valid_wordset: 1,
    wordset_from:     1
  ]
  
  test "detects invalid 3x3 wordset" do
    assert !is_valid_wordset wordset_from(["WTF",
                                           "OMG",
                                           "LOL"])
  end
  
  test "detects valid 3x3 wordset" do
    assert is_valid_wordset wordset_from(["TEA",
                                          "EAT",
                                          "ATE"])
  end
  
  test "detects invalid 4x4 wordset" do
    assert !is_valid_wordset wordset_from(["JOSH",
                                           "_BOE",
                                           "SOME",
                                           "HEEL"])
  end
  
  test "detects valid 4x4 wordset" do
    assert is_valid_wordset wordset_from(["JOSH",
                                          "OBOE",
                                          "SOME",
                                          "HEEL"])
  end
  
  test "wordset string is properly formed" do
    result = wordset_from( ["TEA", "EAT", "ATE"] )
    assert result == "TEA\nEAT\nATE"
  end
  
end
