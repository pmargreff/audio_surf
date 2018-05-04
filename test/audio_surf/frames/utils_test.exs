defmodule AudioSurf.Frames.UtilsTest do
  use ExUnit.Case

  doctest AudioSurf.Frames.Utils

  setup_all :open_dual_channel_audio

  test "assert max value", context do
    rand = :rand.uniform(10000)

    frames = AudioSurf.Extractor.frames(context[:audio])

    {min, max} =
      List.flatten(frames)
      |> Enum.min_max(frames)

    {added_min, added_max} =
      AudioSurf.Frames.Utils.add(frames, rand)
      |> List.flatten()
      |> Enum.min_max()

    assert added_min == min + rand
    assert added_max == max + rand
  end

  defp open_dual_channel_audio(_) do
    filepath = "#{File.cwd!()}/test/dual_channel_stub.wav"
    {:ok, audio} = AudioSurf.Reader.read(filepath)

    [audio: audio]
  end
end
