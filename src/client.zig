// Reference: https://github.com/nostr-protocol/nips/blob/master/01.md#from-client-to-relay-sending-events-and-creating-subscriptions

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

// Filters object is a "dynamic" object where the developer must
// query database by building query based on present fields
pub const Filters = struct {
    ids: ?[][]const u8 = null,
    authors: ?[][]const u8 = null,
    kinds: ?[]i64 = null,
    since: ?i64 = null,
    until: ?i64 = null,
    limit: ?i64 = null,
};

pub const EventRequest = std.meta.Tuple(&.{ []const u8, Event });

pub const SubscriptionRequest = std.meta.Tuple(&.{ []const u8, []const u8, Filters });

pub const CloseRequest = std.meta.Tuple(&.{ []const u8, []const u8 });

test "client-to-relay: EVENT request" {
    const msg =
        \\ [
        \\   "EVENT",
        \\   {
        \\     "id": "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
        \\     "pubkey": "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",
        \\     "created_at": 1673347337,
        \\     "kind": 1,
        \\     "content": "Walled gardens became prisons, and nostr is the first step towards tearing down the prison walls.",
        \\     "tags": [
        \\       ["e", "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206"],
        \\       ["p", "bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce"]
        \\     ],
        \\     "sig": "908a15e46fb4d8675bab026fc230a0e3542bfade63da02d542fb78b2a8513fcd0092619a2c8c1221e581946e0191f2af505dfdf8657a414dbca329186f009262"
        \\   }
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: EventRequest = try json.parseFromSlice(EventRequest, allocator, msg, .{});
    defer json.parseFree(EventRequest, allocator, request);

    const t: []const u8 = request[0];
    const event: Event = request[1];

    try testing.expect(mem.eql(u8, t, "EVENT"));
    try testing.expect(event.id.len == 64);
    try testing.expect(event.pubkey.len == 64);
    try testing.expect(event.created_at > 0);
    try testing.expect(event.kind == 1);
    try testing.expect(event.content.len > 0);
    try testing.expect(event.tags.len == 2);
    try testing.expect(event.sig.len == 128);
}

test "client-to-relay: REQ request" {
    const msg =
        \\ [
        \\   "REQ",
        \\   "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
        \\   {
        \\     "ids": ["4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65"],
        \\     "authors": ["bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce"],
        \\     "kinds": [1, 2],
        \\     "since": 1673347337,
        \\     "until": 1673347400,
        \\     "limit": 100
        \\   }
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: SubscriptionRequest = try json.parseFromSlice(SubscriptionRequest, allocator, msg, .{});
    defer json.parseFree(SubscriptionRequest, allocator, request);

    const t: []const u8 = request[0];
    const subscriptionId: []const u8 = request[1];
    const filters: Filters = request[2];

    try testing.expect(mem.eql(u8, t, "REQ"));
    try testing.expect(subscriptionId.len == 64);
    try testing.expect(filters.ids != null);
    try testing.expect(filters.authors != null);
    try testing.expect(filters.kinds != null);
    try testing.expect(filters.since != null);
    try testing.expect(filters.until != null);
    try testing.expect(filters.limit != null);
}

test "client-to-relay: REQ request, not all fields present" {
    const msg =
        \\ [
        \\   "REQ",
        \\   "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
        \\   {
        \\     "since": 1673347337,
        \\     "until": 1673347400,
        \\     "limit": 100
        \\   }
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: SubscriptionRequest = try json.parseFromSlice(SubscriptionRequest, allocator, msg, .{});
    defer json.parseFree(SubscriptionRequest, allocator, request);

    const t = request[0];
    const subscriptionId = request[1];
    const filters = request[2];

    try testing.expect(mem.eql(u8, t, "REQ"));
    try testing.expect(subscriptionId.len == 64);
    try testing.expect(filters.ids == null);
    try testing.expect(filters.authors == null);
    try testing.expect(filters.kinds == null);
    try testing.expect(filters.since != null);
    try testing.expect(filters.until != null);
    try testing.expect(filters.limit != null);
}

test "client-to-relay: CLOSE request" {
    var msg =
        \\ [
        \\   "CLOSE",
        \\   "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65"
        \\ ]
    ;

    const allocator = std.testing.allocator;
    const request: CloseRequest = try json.parseFromSlice(CloseRequest, allocator, msg, .{});
    defer json.parseFree(CloseRequest, allocator, request);

    const t: []const u8 = request[0];
    const subscriptionId: []const u8 = request[1];

    try testing.expect(mem.eql(u8, t, "CLOSE"));
    try testing.expect(subscriptionId.len == 64);
}
