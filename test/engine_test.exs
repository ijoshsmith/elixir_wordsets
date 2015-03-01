defmodule EngineTest do
  use ExUnit.Case
  
  alias Wordsets.Cache
  alias Wordsets.Lexicon
  alias Wordsets.Util
  
  import Wordsets.Engine, only:
  [
    make_prefix:   1,
    search:        3
  ]
  
  
  #####
  # Setup
  
  # Called once before any test is run.
  setup_all do
    Lexicon.create
    Cache.create
    :ok
  end
  
  # Called immediately after each test completes.
  setup do
    Cache.clear
    :ok
  end
  
    
  #####
  # search/3
  
  test "finds all available wordsets" do
    find_words = fn(prefix, _length) ->
      case prefix do 
        "e"  -> ["ear", "eat", "eel", "end"]
        "ar" -> ["are", "art"]
        "at" -> ["ate"]
        _    -> []
      end
    end
    search("tea", find_words, &Cache.add/1)
    assert Cache.get == [Enum.join(["tea", "ear", "are"], "\n"), 
                         Enum.join(["tea", "ear", "art"], "\n"), 
                         Enum.join(["tea", "eat", "ate"], "\n")]
  end
  
  test "finds no wordsets if none are available" do
    find_words = fn(prefix, _length) ->
      case prefix do 
        "e"  -> ["ear", "eat", "eel", "end"]
        _    -> []
      end
    end
    search("tea", find_words, &Cache.add/1)
    assert Cache.get == []
  end
  
  test "using real lexicon for MAGICAL" do
    search("magical", &Lexicon.find_words/2, &Cache.add/1)
    assert length(Cache.get) == 9
  end
  
  test "using real lexicon for MASTERMIND" do
    search("mastermind", &Lexicon.find_words/2, &Cache.add/1)
    assert length(Cache.get) == 0
  end  
  
  test "using real lexicon for TEA word" do
    search("tea", &Lexicon.find_words/2, &Cache.add/1)
    assert Cache.get |> Enum.all?(&Util.is_valid_wordset/1)
  end
  
  
  #####
  # make_prefix/1
  
  test "determines correct prefix for second word in wordset" do
    result = make_prefix ["tea"]
    assert result == "e"
  end
  
  test "determines correct prefix for third word in wordset" do
    words = Enum.reverse ["tea", "eat"]
    result = make_prefix words
    assert result == "at"
  end
  
  test "returns empty prefix for complete wordset" do
    words = Enum.reverse ["tea", "eat", "ate"]
    result = make_prefix words
    assert result == ""
  end
  
end
