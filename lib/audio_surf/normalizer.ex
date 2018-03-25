defmodule AudioSurf.Normalizer do
  @moduledoc """
  Documentation for AudioSurf.Normalizer
  """
  def to_positive(list, offset) do
    List.flatten(list)
    |> Enum.map(fn x -> x + offset end)
    |> Enum.chunk_every(2)
  end

  def equalize(list, equalizator \\ 1) do
    flatted_list = List.flatten(list)
    max = Enum.max(flatted_list)

    flatted_list
    |> Enum.map(fn x -> x / max * equalizator end)
    |> Enum.map(fn x -> Kernel.round(x) end)
    |> Enum.chunk_every(2)
  end
end
