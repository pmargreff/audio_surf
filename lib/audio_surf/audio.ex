defmodule AudioSurf.Audio do
  @moduledoc """
  Documentation for AudioSurf.Audio
  """

  defstruct chunk_id: nil,
            chunk_size: nil,
            format: nil,
            sub_chunk_1_id: nil,
            sub_chunk_1_size: nil,
            audio_format: nil,
            num_channels: nil,
            sample_rate: nil,
            byte_rate: nil,
            block_align: nil,
            bits_per_sample: nil,
            sub_chunk_2_id: nil,
            sub_chunk_2_size: nil,
            data: nil
end
