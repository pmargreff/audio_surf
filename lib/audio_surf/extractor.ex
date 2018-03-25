defmodule AudioSurf.Extractor do
  @moduledoc """
  Documentation for AudioSurf.Extractor.
  """

  def data(file) when is_bitstring(file) do
    case File.read(file) do
      {:ok, body} -> extract_data(body)
      {:error, reason} -> "There was an error on #{file}: #{reason}"
    end
  end

  def frames(data, frame_size) do
    for <<left::little-integer-signed-size(frame_size),
          rigth::little-integer-signed-size(frame_size) <- data>>,
        do: [left, rigth]
  end

  def frames(data, frame_size, :left) do
    frames(data, frame_size)
    |> Enum.map(fn(x) -> Enum.at(x, 0) end)
  end

  def frames(data, frame_size, :right) do
    frames(data, frame_size)
    |> Enum.map(fn(x) -> Enum.at(x, 1) end)
  end

  def frame(data, size, offset \\ 0) do
    # block align = bits per sample x channels
    absolute_offset = offset * 2 * 2
    [extract_frame(data, size, absolute_offset), extract_frame(data, size, absolute_offset + 2)]
  end

  defp extract_data(body) do
    <<
      chunk_id::binary-size(4),
      chunk_size::little-unsigned-integer-size(32),
      format::binary-size(4),
      sub_chunk_1_id::binary-size(4),
      sub_chunk_1_size::little-unsigned-integer-size(32),
      audio_format::little-unsigned-integer-size(16),
      num_channels::little-unsigned-integer-size(16),
      sample_rate::little-unsigned-integer-size(32),
      byte_rate::little-unsigned-integer-size(32),
      block_align::little-unsigned-integer-size(16),
      bits_per_sample::little-unsigned-integer-size(16),
      sub_chunk_2_id::binary-size(4),
      sub_chunk_2_size::little-unsigned-integer-size(32),
      data::binary
    >> = body

    data
  end

  defp extract_frame(data, size, offset) do
    <<_offset::binary-size(offset), extracted_frame::little-integer-signed-size(size), _::binary>> =
      data

    extracted_frame
  end
end
