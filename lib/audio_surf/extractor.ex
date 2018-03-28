defmodule AudioSurf.Extractor do
  alias AudioSurf.Audio

  @moduledoc """
  Documentation for AudioSurf.Extractor
  """
  def channel(frames, :left), do: extract_channel(frames, 0)

  def channel(frames, :right), do: extract_channel(frames, 1)

  defp extract_channel(frames, channel_number) do
    Enum.map(frames, fn x -> Enum.at(x, channel_number) end)
  end

  def frame(%Audio{} = audio, offset \\ 0) do
    frames(audio) |> Enum.at(offset)
  end

  def frames(%Audio{data: data, bits_per_sample: bits_per_sample}) do
    for <<left::little-integer-signed-size(bits_per_sample),
          rigth::little-integer-signed-size(bits_per_sample) <- data>>,
        do: [left, rigth]
  end
end
