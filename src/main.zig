const std = @import("std");
const print = std.io.getStdOut().writer();
const vec = @import("vec.zig");
const color = @import("color.zig");

pub fn main() !void {
    const image_width = 256;
    const image_height = 256;
    try print.print("P3\n{} {}\n255\n", .{image_width, image_height});
    var j:i32 = 0;
    while (j < image_height) : (j += 1){
        var  i: i32 = 0;
        while( i < image_width ): (i += 1) {
            const r: f64 = @as(f64, @floatFromInt(i)) / @as(f64, @floatFromInt(image_width - 1));
            const g: f64 = @as(f64, @floatFromInt(j)) / @as(f64, @floatFromInt(image_height - 1));
            const b: f64  = 0.0;
            const point = vec.Point3 {r, g, b};
            const pixel_color = color.pointToColor(point); 
            try print.print("{} {} {}\n", .{pixel_color[0], pixel_color[1], pixel_color[2]});
        }
    }
}
