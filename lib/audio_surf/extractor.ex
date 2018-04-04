defmodule AudioSurf.Extractor do
  alias AudioSurf.Audio

  @moduledoc """
  AudioSurf.Extractor module is used to extract frames from audio structure.
  It relies on data field and some other fields to right extraction and
  verification.
  """
  def channel(frames, :left), do: extract_channel(frames, 0)

  def channel(frames, :right), do: extract_channel(frames, 1)

  defp extract_channel(frames, channel_number) do
    Enum.map(frames, fn x -> Enum.at(x, channel_number) end)
  end

  @doc ~S"""
  Returns a list of frames (integers represented) parsed from audio's data.

  ## Parameters

   * :audio - AudioSurf.Audio structure with necessary info to read and parse data.

  ## Options
   * :amount - The amount off frames which should be read. If a value higher than frame size passed it should return the complete list. The default value is
   frame list size.

   * :offset - The first valid frame, all before this will not be returned.
   The default value is 0.

  ## Examples

      iex> AudioSurf.Extractor.frames(audio)
      [
        [0, 0]
        [-2, -8]
        [9, 18]
        [233, 89]
        ...
      ]

      iex> AudioSurf.Extractor.frames(audio, offset: 2, amount: 2)
      [
        [9, 18]
        [233, 89]
      ]
  """

  def frames(
        %Audio{data: data, bits_per_sample: bits_per_sample, chunk_size: chunk_size},
        opts \\ []
      ) do
    frames =
      for <<left::little-integer-signed-size(bits_per_sample),
            rigth::little-integer-signed-size(bits_per_sample) <- data>>,
          do: [left, rigth]

    frames
    |> offset_frames(Keyword.get(opts, :offset, 0))
    |> amount_frames(Keyword.get(opts, :amount, chunk_size))

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
