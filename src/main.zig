const std = @import("std");
const print = std.io.getStdOut().writer();
const vec = @import("vec.zig");
const hitable = @import("hitable.zig");
const color = @import("color.zig");
const ray = @import("ray.zig");
const HitableList = @import("hitable.zig").HitableList;
const Sphere = @import("sphere.zig").Sphere;
const math = std.math;
const p3 = vec.Point3;
const v3 = vec.Vec3;
const Camera = @import("camera.zig").Camera;

pub fn main() !void {
    var gpalloc = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpalloc.deinit();
    const allocator = gpalloc.allocator();

    const image_width: u32 = 500;
    const image_height: u32 = 250;
    const camera = Camera.init(image_width, image_height); 
    var world = HitableList.create(allocator);
    defer world.deinit();

    try world.add(Sphere{ .center = vec.Vec3{ 0.0, -100.5, -1.0 }, .radius = 100.0 });
    try world.add(Sphere{ .center = vec.Vec3{ 0.0, 0.0, -1.0 }, .radius = 0.45 });

    // const pixel_00_loc = viewport_top_left + @as(v3, @splat(@as(f64, 0.5))) * (pixel_delta_u + pixel_delta_v);
    try print.print("P3\n{} {}\n255\n", .{ camera.image_width, camera.image_height });
    try camera.render(world);
    // var j: u32 = 0;
    // while (j < camera.image_height) : (j += 1) {
    //     var i: u32 = 0;
    //     while (i < camera.image_width) : (i += 1) {
    //     const pixel_center = camera.pixel00_loc + (@as(v3, @splat(@as(f64, @floatFromInt(i)))) * camera.pixel_delta_u) + (@as(v3, @splat(@as(f64, @floatFromInt(j)))) * camera.pixel_delta_v);

    //         const r: ray.Ray = ray.Ray{ .origin = camera.origin, .direction = pixel_center };
    //         const pixel_color = color.pointToColor(color.rayColor(r, world));
    //         try print.print("{} {} {}\n", .{ pixel_color[0], pixel_color[1], pixel_color[2] });
    //     }
    // }
}
