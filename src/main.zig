const std = @import("std");
const noztr = @import("noztr.zig");

const json = std.json;
const heap = std.heap;
const io = std.io;
const debug = std.debug;

pub fn main() !void {
    var tags = [_][2][]const u8{
        [2][]const u8{ "e", "3da979448d9ba263864c4d6f14984c423a3838364ec255f03c7904b1ae77f206" },
        [2][]const u8{ "p", "bf2376e17ba4ec269d10fcc996a4746b451152be9031fa48e74553dde5526bce" },
    };
    debug.print("tags: {any}\n", .{@TypeOf(tags)});
    // var gpa = heap.GeneralPurposeAllocator(.{}){};
    // var allocator = gpa.allocator();
    // const stdin = io.getStdIn().reader();
    // const stdout = io.getStdOut().writer();
    //
    // while (true) {
    //     const msg: ?[]u8 = try stdin.readUntilDelimiterOrEofAlloc(allocator, '\n', 500);
    //     if (msg) |event| {
    //         noztr.processEvent(allocator, event);
    //     }
    //     allocator.free(msg.?);
    // }
    //
    // // Free "global" memory
    // const didLeak = gpa.deinit();
    // debug.assert(!didLeak);
}
