const hitable = @import("hitable.zig");
const vec = @import("vec.zig");
const Vec3 = @import("vec.zig").Vec3;
const Color = @import("vec.zig").Color;
const HitableList = @import("hitable.zig").HitableList;
const ray = @import("ray.zig");
const color = @import("color.zig");
const std = @import("std");
const print = std.io.getStdOut().writer();
const random = @import("utils.zig");

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
        const origin = Vec3{ 0.0, 0.0, 0.0 };
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
        return Camera{
            .aspect_ratio = aspect_ratio,
            .image_width = image_width,
            .image_height = image_height,
            .origin = origin,
            .pixel_delta_u = pixel_delta_u,
            .pixel_delta_v = pixel_delta_v,
            .pixel00_loc = pixel_00_loc,
        };
    }
    // get random samples from pixel location;
    pub fn get_ray(self: @This(), i: u32, j: u32) ray.Ray {
        const offset = sample_sq();
        const float_i = @as(f64, @floatFromInt(i));
        const float_j = @as(f64, @floatFromInt(j));

        const pixel_sample = self.pixel00_loc + (@as(Vec3, @splat(float_i + offset[0])) * self.pixel_delta_u) + (@as(Vec3, @splat(float_j + offset[1])) * self.pixel_delta_v);
        const ray_origin = self.origin;
        const ray_dir = pixel_sample - ray_origin;
        return ray.Ray{ .origin = ray_origin, .direction = ray_dir };
    }

    pub fn sample_sq() Vec3 {
        return Vec3{ random.random_f64() - 0.5, random.random_f64() - 0.5, 0.0 };
    }

    pub fn render(self: @This(), world: HitableList, samples_per_pixel: u32) !void {
        const pixel_samples_scale: f64 = 1.0 / @as(f64, @floatFromInt(samples_per_pixel));
        var j: u32 = 0;
        while (j < self.image_height) : (j += 1) {
            var i: u32 = 0;
            while (i < self.image_width) : (i += 1) {
                var sample: u32 = 0;
                var pixel_color = Vec3{ 0.0, 0.0, 0.0 };
                while (sample < samples_per_pixel) : (sample += 1) {
                    const r: ray.Ray = self.get_ray(i, j);
                    pixel_color += color.rayColor(r, world);
                }
                const final_color = color.pointToColor(pixel_color * @as(Vec3, @splat(pixel_samples_scale)));
                try print.print("{} {} {}\n", .{ final_color[0], final_color[1], final_color[2] });
            }
        }
    }
};
