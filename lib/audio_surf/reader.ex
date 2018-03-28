defmodule AudioSurf.Reader do
  alias AudioSurf.Audio

  @moduledoc """
    Documentation for AudioSurf.Reader
  """

  def open(filepath) do
    case File.read(filepath) do
      {:ok, body} -> {:ok, extract_audio(body)}
      {:error, reason} -> {:error, "There was an error on #{filepath}: #{reason}"}
    end
  end

  defp extract_audio(body) do
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

    %Audio{
      chunk_id: chunk_id,
      chunk_size: chunk_size,
      format: format,
      sub_chunk_1_id: sub_chunk_1_id,
      sub_chunk_1_size: sub_chunk_1_size,
      audio_format: audio_format,
      num_channels: num_channels,
      sample_rate: sample_rate,
      byte_rate: byte_rate,
      block_align: block_align,
      bits_per_sample: bits_per_sample,
      sub_chunk_2_id: sub_chunk_2_id,
      sub_chunk_2_size: sub_chunk_2_size,
      data: data
    }
  end
end
