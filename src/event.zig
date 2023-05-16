const std = @import("std");
const mem = std.mem;
const ArrayList = std.ArrayList;

pub const EventError = error{
    ToEventKind,
};

// Nostr Event Structure
//
// {
//   "id": "4376c65d2f232afbe9b882a35baa4f6fe8667c4e684749af565f981833ed6a65",
//   "pubkey": "6e468422dfb74a5738702a8823b9b28168abab8655faacb6853cd0ee15deee93",
//   "created_at": 1673347337,
//   "kind": 1,
//   "content": "Walled gardens became prisons, and nostr is the first step towards tearing down the prison walls.",
//   "tags": [
//     ["e", "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206"],
//     ["p", "bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce"]
//   ],
//   "sig": "908a15e46fb4d8675bab026fc230a0e3542bfade63da02d542fb78b2a8513fcd0092619a2c8c1221e581946e0191f2af505dfdf8657a414dbca329186f009262"
// }
pub const RawEvent = struct {
    id: [64]u8,
    pubkey: [64]u8,
    created_at: u64,
    kind: u8,
    content: []const u8,
    tags: [][2][]const u8,
    sig: [128]u8,
};

pub const Event = struct {
    id: [64]u8,
    pubKey: [64]u8,
    createdAt: u64,
    kind: u8,
    content: []const u8,
    tags: ArrayList([2][]const u8),
    sig: [128]u8,
    allocator: mem.Allocator,

    pub fn init(*self: Event, allocator: mem.Allocator) {

    }
};

pub const EventKind = enum {
    SetMetadata,
    TextNote,
};

pub fn fromEventKind(kind: EventKind) u64 {
    switch (kind) {
        .SetMetadata => 0,
        .TextNote => 1,
    }
}

// pub fn toEventKind(comptime value: u64) !EventKind {
//     switch (value) {
//         0 => .SetMetadata,
//         1 => .TextNote,
//         else => EventError.ToEventKind,
//     }
// }

pub const EventTag = enum {
    Event,
    Pubkey,
    Multicast,
    Delegation,
    Deduplication,
    Expiration,
};

pub fn toEventTag(tag: EventTag) []const u8 {
    switch (tag) {
        .Event => "e",
        .Pubkey => "p",
        .Multicast => "m",
        .Delegation => "delegation",
        .Deduplication => "d",
        .Expiration => "expiration",
    }
}
