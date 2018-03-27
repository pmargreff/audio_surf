defmodule AudioSurf.Extractor do
  alias AudioSurf.Audio

  @moduledoc """
  Documentation for AudioSurf.Extractor
  """

  def frames(%Audio{data: data, bits_per_sample: bits_per_sample}) do
    for <<left::little-integer-signed-size(bits_per_sample),
          rigth::little-integer-signed-size(bits_per_sample) <- data>>,
        do: [left, rigth]
  end

  def frames(%Audio{} = audio, :left) do
    frames(audio)
    |> Enum.map(fn x -> Enum.at(x, 0) end)
  end

  def frames(%Audio{} = audio, :right) do
    frames(audio)
    |> Enum.map(fn x -> Enum.at(x, 1) end)
  end

  def frame(%Audio{} = audio, offset \\ 0) do
    frames(audio) |> Enum.at(offset)
  end
end
