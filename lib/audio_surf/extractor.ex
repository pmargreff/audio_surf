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

  def frames(
        %Audio{data: data, bits_per_sample: bits_per_sample, chunk_size: chunk_size},
        options \\ []
      ) do
    frames =
      for <<left::little-integer-signed-size(bits_per_sample),
            rigth::little-integer-signed-size(bits_per_sample) <- data>>,
          do: [left, rigth]

    frames
    |> offset_frames(Keyword.get(options, :offset, 0))
    |> amount_frames(Keyword.get(options, :amount, chunk_size))

    # extract_channel(Keyword.get(options, :channel, :dual))
  end

  defp amount_frames(frames, amount) do
    Enum.take(frames, amount)
  end

  defp offset_frames(frames, offset) do
    Enum.split(frames, offset)
    |> elem(1)
  end
end
