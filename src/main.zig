const std = @import("std");
const json = std.json;
const heap = std.heap;
const io = std.io;
const debug = std.debug;

const mem = std.mem;
const Allocator = mem.Allocator;

pub const RawEvent = struct {
    id: [64]u8,
    pubkey: [64]u8,
    created_at: u64,
    kind: u8,
    content: []const u8,
    tags: [][2][]const u8,
    sig: [128]u8,
};

pub fn parseMsgToRawEvent(allocator: mem.Allocator, msg: []const u8) !RawEvent {
    var stream = json.TokenStream.init(msg);
    var rawEvent = try json.parse(RawEvent, &stream, .{ .allocator = allocator });
    return rawEvent;
}

pub const Event = struct {
    id: [64]u8,
    pubKey: [64]u8,
    createdAt: u64,
    kind: u8,
    content: []u8,
    tags: [][2][]u8,
    sig: [128]u8,

    pub fn init(rawEvent: RawEvent) Event {
        var event = Event{
            .createdAt = rawEvent.created_at,
            .kind = rawEvent.kind,
            .id = undefined,
            .pubKey = undefined,
            .content = undefined,
            .tags = undefined,
            .sig = undefined,
        };

        std.mem.copy(u8, &event.id, &rawEvent.id);
        std.mem.copy(u8, &event.pubKey, &rawEvent.pubkey);
        std.mem.copy(u8, event.content, rawEvent.content);
        std.mem.copy(u8, &event.sig, &rawEvent.sig);

        return event;
    }

    pub fn print(self: *Event) void {
        std.debug.print("\n", .{});
        std.debug.print("id: {s}\n", .{self.id});
        std.debug.print("pubkey: {s}\n", .{self.pubKey});
        std.debug.print("created_at: {d}\n", .{self.createdAt});
        std.debug.print("kind: {any}\n", .{self.kind});
        std.debug.print("content: {s}\n", .{self.content});
        for (self.tags) |tag| {
            std.debug.print("tag: [{s}, {s}]\n", .{ tag[0], tag[1] });
        }
        std.debug.print("sig: {s}\n", .{self.sig});
        std.debug.print("\n", .{});
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

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

    var rawEvent = try parseMsgToRawEvent(allocator, msg);
    defer json.parseFree(RawEvent, rawEvent, .{ .allocator = allocator });

    var event = Event.init(rawEvent);
    event.print();
}
