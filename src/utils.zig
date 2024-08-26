// shit that dont fit anywhere else i guess
pub const std = @import("std");
pub const PI: f64 = 3.141526535897932385;
pub const INFINITY = std.math.inf(f64);
pub const c = @cImport({
    @cInclude("stdlib.h");
    @cInclude("time.h");
});

// /* couldnt get this shit to work come on now */
// var prng = std.rand.DefaultPrng.init(blk: {
//     var seed: u64 = undefined;
//     std.os.getrandom(std.mem.asBytes(&seed));
//     break :blk seed;
// });
// var rand = prng.random();

pub fn deg_to_rad(degrees: f64) f64 {
    return degrees * PI / 180.0;
}

pub export fn random_f64() f64 {
    return @as(f64, @floatFromInt(c.rand())) / @as(f64, @floatFromInt(c.RAND_MAX));
}

pub fn random_range_f64(min: u32, max: u32) f64 {
    return @as(f64, (min + (max - min))) * random_f64();
}
