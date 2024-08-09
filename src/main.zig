const std = @import("std");
const print = std.io.getStdOut().writer();


pub fn main() !void {
    const image_width = 256;
    const image_height = 256;
    try print.print("P3\n{} {}\n255\n", .{image_width, image_height});
    var j:i32 = image_height - 1;
    while (0 <= j) : (j -= 1){
        var  i: i32 = 0;
        while( i < image_width ): (i += 1) {
            const r: f64 = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(image_width - 1));
            const g: f64 = @as(f64, @floatFromInt(j)) / @as(f64, @floatFromInt(image_height - 1));
            const b: f64  = 0.0;

            const screen_r  = @as(i32, @intFromFloat(255.99 * r));
            const screen_g  = @as(i32, @intFromFloat(255.99 * g));
            const screen_b  = @as(i32, @intFromFloat(255.99 * b));
            try print.print("{} {} {}\n", .{screen_r, screen_g, screen_b});
        }
    }
}
