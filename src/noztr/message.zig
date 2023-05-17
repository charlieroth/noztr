// From Client to Relay: Sending Event and Creating Subscriptions
//
// Clients can send 3 types of messages, which must be JSON arrays, according to
// the following patterns:
// - ["EVENT", <event JSON>], used to publish events
// - ["REQ", <subscription_id>, <filters JSON>], used to request event and subscribe to new updates
// - ["CLOSE", <subscription_id>], used to stop previous subscriptions

const Event = @import("event.zig").Event;

pub const Message = struct {
    type: []u8,
    event: Event,
};

pub fn parseMessage(msg: []u8) Message {
    _ = msg;
    return Message{};
}
