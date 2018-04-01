defmodule AudioSurfExtractorTest do
  use ExUnit.Case

  doctest AudioSurf.Extractor

  test "frames/1 for dual channel audio" do
    filepath = "#{File.cwd!()}/test/dual_channel_stub.wav"

    {:ok, audio} = AudioSurf.Reader.read(filepath)
    frames = AudioSurf.Extractor.frames(audio)
    max_possible = :math.pow(2, audio.bits_per_sample) |> round
    min_possible = :math.pow(2, audio.bits_per_sample) |> round |> (&(&1 * -1 + 1)).()
    {min_frame_value, max_frame_value} = List.flatten(frames) |> Enum.min_max()

    assert List.first(frames) |> Enum.count() == 2, "it assert channel size"
    assert Enum.count(frames) == 669_355, "it assert frames size"
    assert min_frame_value >= min_possible, "min value is higher than possible min"
    assert max_frame_value <= max_possible, "max value is lower than possible max"
  end
end
