defmodule AudioSurf.Frames.Utils do
  @moduledoc """
  Documentation for AudioSurf.Frames.Normalizer
  """

  def add(frames, offset \\ 32768) do
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

  def sampling(frames, sample_size) do
    sample_interval = interval(length(frames), sample_size)

    Enum.take_every(frames, sample_interval)
    |> Enum.slice(1..sample_size)
  end

  # TODO raise error if interval is higher than frames size
  defp interval(frames_lenght, sample_size) do
    (frames_lenght / sample_size) |> trunc
  end
end
