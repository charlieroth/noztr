// Reference: https://github.com/nostr-protocol/nips/blob/master/01.md#from-relay-to-client-sending-events-and-notices

const std = @import("std");
const json = std.json;
const testing = std.testing;
const heap = std.heap;
const mem = std.mem;

pub const Event = struct {
    id: [64]u8,
    pubkey: [64]u8,
    created_at: i64,
    kind: i64,
    content: []const u8,
    tags: [][2][]const u8,
    sig: [128]u8,
};

// ["EVENT", <subscription_id>, <event JSON>]
pub const EventRequest = std.meta.Tuple(&.{ []const u8, []const u8, Event });

// ["EOSE", <subscription_id>]
pub const EndOfStoredEventsRequest = std.meta.Tuple(&.{ []const u8, []const u8 });

// ["NOTICE", <message>]
pub const NoticeRequest = std.meta.Tuple(&.{ []const u8, []const u8 });

test "relay-to-client: EVENT request" {
    const msg =
        \\ [
        \\   "EVENT",
        \\   "3wYngg3QLaqOA5yuD4R2kxxRIjRFvLKwFY9K4hwB1bkr1v7s2TiCQt5KGnTQh6sU",
        \\   {
        \\     "id": "1MxCsnLbaJt8ruamopDWiHQokgpDJuq4FM4IDSq6f5w70SP5RttB3uWmE1E25VV9",
        \\     "pubkey": "PfVwtICO3ZtQXEHI9kTew0eV9FNFwsIFzLbd2FiOEtoOIr4E511ly7rL5evTISGi",
        \\     "created_at": 1673347337,
        \\     "kind": 1,
        \\     "content": "This is a note",
        \\     "tags": [
        \\       ["p", "Mxp6fRxyHoABcCykFxfal2hLFsfEtsfWXtGH8l4huM4BYx27WlpUiew2xtifNeFd"]
        \\     ],
        \\     "sig": "3Rp0SDuSlpjxKZHaELcgS6CGzYh5V4fN7PrYd5ixIg9KuxB6pe2iVi2uNefXhxegoEnQXwjYIAdedNUihK05cLqIUeupiU1Iuc8aICT28HYQFuEpGDet0kbHtVpac0IL"
        \\   }
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: EventRequest = try json.parseFromSlice(EventRequest, allocator, msg, .{});
    defer json.parseFree(EventRequest, allocator, request);

    const t: []const u8 = request[0];
    const subscriptionId: []const u8 = request[1];
    const event: Event = request[2];

    try testing.expect(mem.eql(u8, t, "EVENT"));
    try testing.expect(subscriptionId.len == 64);
    try testing.expect(event.id.len == 64);
}

test "relay-to-client: EOSE request" {
    const msg =
        \\ [
        \\   "EOSE",
        \\   "GaKgPLMfsjMZlYas59kzKNRSOHFhmntTB2wu6YAYsJD3t1TXlXhCPz0kgQ9e59m4"
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: EndOfStoredEventsRequest = try json.parseFromSlice(EndOfStoredEventsRequest, allocator, msg, .{});
    defer json.parseFree(EndOfStoredEventsRequest, allocator, request);

    const t: []const u8 = request[0];
    const subscriptionId: []const u8 = request[1];

    try testing.expect(mem.eql(u8, t, "EOSE"));
    try testing.expect(subscriptionId.len == 64);
}

test "relay-to-client: NOTICE request" {
    const msg =
        \\ [
        \\   "NOTICE",
        \\   "This is a notice"
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: NoticeRequest = try json.parseFromSlice(NoticeRequest, allocator, msg, .{});
    defer json.parseFree(NoticeRequest, allocator, request);

    const t: []const u8 = request[0];
    const notice: []const u8 = request[1];

    try testing.expect(mem.eql(u8, t, "NOTICE"));
    try testing.expect(notice.len > 0);
}
