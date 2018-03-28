defmodule AudioSurf.Frames.Utils do
  @moduledoc """
  Documentation for AudioSurf.Frames.Normalizer
  """

  def add(frames, offset) do
    List.flatten(frames)
    |> Enum.map(fn x -> x + offset end)
    |> Enum.chunk_every(2)
  end

  def equalize(frames, equalizator \\ 1) do
    flatted_list = List.flatten(frames)
    max = Enum.max(flatted_list)

    flatted_list
    |> Enum.map(fn x -> Kernel.round(x / max * equalizator) end)
    |> Enum.chunk_every(2)
  end
end
