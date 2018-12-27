require "amq-protocol"
require "./channel"

class AMQP::Client
  struct Message
    getter exchange, routing_key, properties, body_io

    def initialize(@exchange : String, @routing_key : String,
                   @properties : AMQ::Protocol::Properties,
                   @body_io : IO)
    end
  end

  struct DeliveredMessage
    getter exchange, routing_key, delivery_tag, properties, body_io

    def initialize(@channel : Channel, @exchange : String,
                   @routing_key : String, @delivery_tag : UInt64,
                   @properties : AMQ::Protocol::Properties,
                   @body_io : IO)
    end

    def ack
      @channel.ack(@delivery_tag)
    end

    def nack(requeue = false)
      @channel.nack(@delivery_tag, requeue: requeue)
    end
  end
end
