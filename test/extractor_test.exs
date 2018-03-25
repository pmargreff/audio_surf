defmodule AudioSurfExtractorTest do
  use ExUnit.Case
  doctest AudioSurf.Extractor

  test "cannot open file" do
    assert AudioSurf.Extractor.data("doesnt_exist.txt") == "doesnt exist string"
  end

  test "incorrect header file" do
    assert AudioSurf.Extractor.data("doesnt_exist.txt") == "doesnt exist string"
  end

  test "sucessfully open file" do
    assert AudioSurf.Extractor.data("doesnt_exist.txt") == "doesnt exist string"
  end
end
