const std = @import("std");
const print = std.io.getStdOut().writer();
const vec = @import("vec.zig");
const hitable = @import("hitable.zig");
const color = @import("color.zig");
const ray = @import("ray.zig");
const HitableList = @import("hitable.zig").HitableList;
const Sphere = @import("sphere.zig").Sphere;
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
    try print.print("P3\n{} {}\n255\n", .{ camera.image_width, camera.image_height });
    try camera.render(world, 100);
}
