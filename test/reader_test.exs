defmodule AudioSurfReaderTest do
  use ExUnit.Case

  doctest AudioSurf.Reader

  test "read/1 file doesn't exists" do
    filepath = "doesnt_exist.txt"
    error_message = "There was an error on #{filepath}: enoent"

    assert AudioSurf.Reader.read(filepath) == {:error, error_message}
  end

  test "read/1 read file" do
    filepath = "#{File.cwd!()}/test/dual_channel_stub.wav"

    {:ok, audio} = AudioSurf.Reader.read(filepath)

    assert audio.audio_format == 1
    assert audio.bits_per_sample == 16
    assert audio.block_align == 4
    assert audio.byte_rate == 176_400
    assert audio.chunk_id == "RIFF"
    assert audio.chunk_size == 2_677_458
    assert audio.data =~ data_chunk()
    assert audio.format == "WAVE"
    assert audio.num_channels == 2
    assert audio.sample_rate == 44_100
    assert audio.sub_chunk_1_id == "fmt "
    assert audio.sub_chunk_1_size == 16
    assert audio.sub_chunk_2_id == "LIST"
    assert audio.sub_chunk_2_size == 166
  end

  # test the file on the specification, whoch allow to derivate
  # some field with other fields values
  # https://web.archive.org/web/20141213140451/https://ccrma.stanford.edu/courses/422/projects/WaveFormat/
  test "read/1 assert the format specifications" do
    filepath = "#{File.cwd!()}/test/dual_channel_stub.wav"

    {:ok, audio} = AudioSurf.Reader.read(filepath)
    assert audio.block_align == audio.num_channels * ((audio.bits_per_sample / 8) |> round())
    assert audio.byte_rate == audio.sample_rate * audio.block_align
  end

  defp data_chunk do
    <<73, 78, 70, 79, 73, 65, 82, 84, 17, 0, 0, 0, 72, 101, 110, 100, 114, 105, 107, 32, 66, 114,
      111, 101, 107, 109, 97, 110, 0, 0, 73, 71, 78, 82, 26, 0, 0, 0, 72, 117, 98>>
  end
end
