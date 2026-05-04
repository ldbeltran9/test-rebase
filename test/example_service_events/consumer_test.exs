defmodule ExampleServiceEvents.ConsumerTest do
  use ExampleService.DataCase

  describe "handle_message/1" do
    test "returns :ok for valid messages" do
      message = %Kafee.Consumer.Message{
        key: "example-service-message-key",
        value: "example-service-message-value"
      }

      assert :ok = ExampleServiceEvents.Consumer.handle_message(message)
    end
  end
end
