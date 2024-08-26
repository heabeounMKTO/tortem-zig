pub const hitable = @import("hitable.zig");
pub const vec = @import("vec.zig");
pub const Vec3 = @import("vec.zig").Vec3;
pub const HitableList = @import("hitable.zig").HitableList;
pub const ray = @import("ray.zig");
pub const color = @import("color.zig");
const std = @import("std");
const print = std.io.getStdOut().writer();


pub const Camera = struct {
    aspect_ratio: f64,
    image_width: u32,
    image_height: u32,
    origin: Vec3,
    pixel_delta_u: Vec3,
    pixel_delta_v: Vec3,
    pixel00_loc: Vec3,

    const Self = @This();
    
    pub fn init(image_width: u32, image_height: u32) Camera {
        // const image_height = image_width / aspect_ratio;
        const origin = Vec3 { 0.0 ,0.0 ,0.0 };
        const aspect_ratio: f64 = @as(f64, @floatFromInt(image_width)) / @as(f64, @floatFromInt(image_height));
        const viewport_height = 2.0;
        const viewport_width = aspect_ratio * viewport_height;
    const focal_length = 1.0;

    const viewport_u = Vec3{ viewport_width, 0.0, 0.0 };
    const viewport_v = Vec3{ 0.0, -viewport_height, 0.0 }; // we reverse da Y axis

    const pixel_delta_u = viewport_u / @as(Vec3, @splat(@as(f64, @floatFromInt(image_width))));
    const pixel_delta_v = viewport_v / @as(Vec3, @splat(@as(f64, @floatFromInt(image_height))));

    const viewport_top_left = origin - Vec3{ 0.0, 0.0, focal_length } - viewport_u / @as(Vec3, @splat(@as(f64, 2.0))) - viewport_v / @as(Vec3, @splat(@as(f64, 2.0)));

    const pixel_00_loc = viewport_top_left + @as(Vec3, @splat(@as(f64, 0.5))) * (pixel_delta_u + pixel_delta_v);
        return Camera {
            .aspect_ratio =  aspect_ratio,
            .image_width = image_width,
            .image_height = image_height,
            .origin = origin,
            .pixel_delta_u = pixel_delta_u,
            .pixel_delta_v = pixel_delta_v,
            .pixel00_loc = pixel_00_loc,
        };
    }

    pub fn render(self: @This(), world: HitableList) !void {
        
    var j: u32 = 0;
    while (j < self.image_height) : (j += 1) {
        var i: u32 = 0;
        while (i < self.image_width) : (i += 1) {
                
        const pixel_center = self.pixel00_loc + (@as(Vec3, @splat(@as(f64, @floatFromInt(i)))) * self.pixel_delta_u) + (@as(Vec3, @splat(@as(f64, @floatFromInt(j)))) * self.pixel_delta_v);
            const r: ray.Ray = ray.Ray{ .origin = self.origin, .direction = pixel_center };
            const pixel_color = color.pointToColor(color.rayColor(r, world));
            try print.print("{} {} {}\n", .{ pixel_color[0], pixel_color[1], pixel_color[2] });
        }
    }
    }
};
