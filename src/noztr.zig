const std = @import("std");
const mem = std.mem;
const json = std.json;
const heap = std.heap;
const io = std.io;
const debug = std.debug;
const testing = std.testing;

const event = @import("event.zig");
const Event = event.Event;
const RawEvent = event.RawEvent;
const EventKind = event.EventKind;

pub fn parseMsgToEvent(allocator: mem.Allocator, msg: []const u8) !Event {
    // var parser: json.Parser = json.Parser.init(allocator, false);
    // var tree: json.ValueTree = try parser.parse(msg);
    // defer parser.deinit();
    // defer tree.deinit();
    var stream: json.TokenStream = json.TokenStream.init(msg);
    var rawEvent: event.RawEvent = try json.parse(event.RawEvent, &stream, .{ .allocator = allocator });
    defer json.parseFree(event.RawEvent, rawEvent, .{ .allocator = allocator });

    debug.print("id: {s}\n", .{rawEvent.id});
    debug.print("pubkey: {s}\n", .{rawEvent.pubkey});
    debug.print("created_at: {d}\n", .{rawEvent.created_at});
    debug.print("kind: {any}\n", .{rawEvent.kind});
    debug.print("content: {s}\n", .{rawEvent.content});
    debug.print("\ntags:\n", .{});
    for (rawEvent.tags) |tag| {
        debug.print("kind: {s}, id: {s}\n", .{ tag[0], tag[1] });
    }
    debug.print("\n", .{});
    debug.print("sig: {s}\n", .{rawEvent.sig});

    var e = Event.init(allocator, rawEvent);
    return e;
}

test "parses event kind 0" {
    var gpa = heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    debug.print("\n", .{});

    const msg =
        \\ {
        \\   "id": "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
        \\   "pubkey": "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",
        \\   "created_at": 1673347337,
        \\   "kind": 1,
        \\   "content": "Walled gardens became prisons, and nostr is the first step towards tearing down the prison walls.",
        \\   "tags": [
        \\     ["e", "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206"],
        \\     ["p", "bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce"]
        \\   ],
        \\   "sig": "908a15e46fb4d8675bab026fc230a0e3542bfade63da02d542fb78b2a8513fcd0092619a2c8c1221e581946e0191f2af505dfdf8657a414dbca329186f009262"
        \\ }
    ;

    const parsedEvent = try parseMsgToEvent(allocator, msg);
    try testing.expect(parsedEvent.kind == EventKind.TextNote);

    const didLeak = gpa.deinit();
    try testing.expect(didLeak == .ok);
}
