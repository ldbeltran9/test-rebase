defmodule ExampleServiceEvents.ProducerTest do
  use ExampleService.DataCase

  use Kafee.Test

  describe "publish/2" do
    test "can send example event" do
      assert :ok = ExampleServiceEvents.Producer.publish(:example_event, %{})

      assert_kafee_message(%{
        key: "example-event-key",
        value: "example-event-value"
      })
    end
  end
end
