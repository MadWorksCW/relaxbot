defmodule Relaxbot.TweetStoreTest do
  use ExUnit.Case
  doctest Relaxbot

  setup do
    file = "/tmp/relaxbot-test.dets"
    Application.put_env(:relaxbot, :tweet_store, file)
    on_exit fn ->
      File.rm(file)
    end
    [tweet_store: file]
  end

  test "writes to the disk where configured", context do
    {:ok, _pid} = Relaxbot.TweetStore.start_link
    assert File.exists?(context[:tweet_store])
    Relaxbot.TweetStore.tweet("test")
    assert Relaxbot.TweetStore.tweeted?("test")
  end

  test "handles an invalid file", context do
    File.cp "test/corrupt.dets", context[:tweet_store]
    {:ok, pid} = Relaxbot.TweetStore.start_link
    assert pid
  end
end
