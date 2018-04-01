defmodule AudioSurfExtractorTest do
  use ExUnit.Case

  doctest AudioSurf.Extractor

  setup_all :open_dual_channel_audio

  test "frames/1 for dual channel audio", context do
    audio = context[:audio]
    frames = AudioSurf.Extractor.frames(audio)
    max_possible = :math.pow(2, audio.bits_per_sample) |> round
    min_possible = :math.pow(2, audio.bits_per_sample) |> round |> (&(&1 * -1 + 1)).()
    {min_frame_value, max_frame_value} = List.flatten(frames) |> Enum.min_max()

    assert List.first(frames) |> Enum.count() == 2, "it assert channel size"
    assert Enum.count(frames) == 669_355, "it assert frames size"
    assert min_frame_value >= min_possible, "min value is higher than possible min"
    assert max_frame_value <= max_possible, "max value is lower than possible max"
  end

  test "frame/1 allow offset on frames", context do
    first_frame = AudioSurf.Extractor.frame(context[:audio], 0)
    last_frame = AudioSurf.Extractor.frame(context[:audio], 669_354)

    assert first_frame == [20041, 20294], "first frame values"
    assert last_frame == [0, 0], "last frame values"
  end

  @tag :skip
  test "frame/1 allow list size on frame" do
  end

  test "channel/2 with right", context do
    frames = AudioSurf.Extractor.frames(context[:audio])
    right_frames = AudioSurf.Extractor.channel(frames, :right)

    assert Enum.count(right_frames) == 669_355, "it has the same frame size"
    assert List.first(right_frames) == 20294, "it has the same first frame"
    assert List.last(right_frames) == 0, "it has the same last frame"
  end

  test "channel/2 with left", context do
    frames = AudioSurf.Extractor.frames(context[:audio])
    right_frames = AudioSurf.Extractor.channel(frames, :left)

    assert Enum.count(right_frames) == 669_355, "it has the same frame size"
    assert List.first(right_frames) == 20041, "it has the same first frame"
    assert List.last(right_frames) == 0, "it has the same last frame"
  end

  defp open_dual_channel_audio(_) do
    filepath = "#{File.cwd!()}/test/dual_channel_stub.wav"
    {:ok, audio} = AudioSurf.Reader.read(filepath)

    [audio: audio]
  end
end
