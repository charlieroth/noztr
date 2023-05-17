const std = @import("std");
const mem = std.mem;

pub const EventError = error{
    ToEventKind,
};

pub const Event = struct {
    id: [64]u8,
    pubkey: [64]u8,
    created_at: u64,
    kind: u8,
    content: []const u8,
    tags: [][2][]const u8,
    sig: [128]u8,

    pub fn print(self: *Event) void {
        std.debug.print("\n", .{});
        std.debug.print("id: {s}\n", .{self.id});
        std.debug.print("pubkey: {s}\n", .{self.pubkey});
        std.debug.print("created_at: {d}\n", .{self.created_at});
        std.debug.print("kind: {any}\n", .{self.kind});
        std.debug.print("content: {s}\n", .{self.content});
        for (self.tags) |tag| {
            std.debug.print("tag: [{s}, {s}]\n", .{ tag[0], tag[1] });
        }
        std.debug.print("sig: {s}\n", .{self.sig});
        std.debug.print("\n", .{});
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
    Evnt,
    Pubkey,
    Multicast,
    Delegation,
    Deduplication,
    Expiration,
};

pub fn toEventTag(tag: EventTag) []const u8 {
    switch (tag) {
        .Evnt => "e",
        .Pubkey => "p",
        .Multicast => "m",
        .Delegation => "delegation",
        .Deduplication => "d",
        .Expiration => "expiration",
    }
}
