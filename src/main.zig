const std = @import("std");
const print = std.io.getStdOut().writer();
const vec = @import("vec.zig");
const color = @import("color.zig");
const ray = @import("ray.zig");
const math = std.math;
const p3 = vec.Point3;
const v3 = vec.Vec3;

pub fn main() !void {
    const image_width: u32 = 500;
    const image_height: u32 = 250;
    const aspect_ratio: f64 = @as(f64, image_width)/@as(f64, image_height);
    const viewport_height = 2.0;
    const viewport_width = aspect_ratio * viewport_height;
    const focal_length = 1.0;
    const origin = p3{0.0,0.0, 0.0};
    const viewport_u = v3{viewport_width, 0.0,0.0};
    const viewport_v = v3{0.0, -viewport_height, 0.0}; // we reverse da Y axis 
    const pixel_delta_u = viewport_u / @as(v3, @splat(@as(f64, @floatFromInt(image_width)))); 
    const pixel_delta_v = viewport_v / @as(v3, @splat(@as(f64, @floatFromInt(image_height))));

    const viewport_top_left = origin - v3{0.0, 0.0, focal_length} - viewport_u / @as(v3, @splat(@as(f64, 2.0))) - viewport_v/@as(v3,@splat(@as(f64,2.0)));
    const pixel_00_loc = viewport_top_left + @as(v3,@splat(@as(f64,0.5))) * (pixel_delta_u + pixel_delta_v);

    try print.print("P3\n{} {}\n255\n", .{image_width, image_height});
    var j:i32 = 0;
    while (j < image_height) : (j += 1){
        var  i: i32 = 0;
        while( i < image_width ): (i += 1) {
            const pixel_center = pixel_00_loc + (@as(v3, @splat(@as(f64, @floatFromInt(i)))) * pixel_delta_u) + (@as(v3, @splat(@as(f64, @floatFromInt(j)))) * pixel_delta_v);
            const r: ray.Ray = ray.Ray {
                .origin=origin,
                .direction=pixel_center
            };
            const ray_color_ehek = color.rayColor(r);
            const pixel_color = color.pointToColor(ray_color_ehek);
            try print.print("{} {} {}\n", .{pixel_color[0], pixel_color[1], pixel_color[2]});
        }
    }
} 
