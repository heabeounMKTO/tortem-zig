const std = @import("std");
const vec = @import("vec.zig");
const Ray = @import("ray.zig").Ray;
const math = std.math;
const print = std.io.getStdOut().writer();

pub fn rayColor(r: Ray) vec.Vec3 {
    const unit_direction = r.direction / @as(vec.Vec3, @splat(math.sqrt(@reduce(.Add, r.direction * r.direction))));
    const t = 0.5 * (unit_direction[1] + 1.0);
    const ray_color = @as(vec.Vec3, @as(vec.Vec3, (@splat(1.0 - t)))) * vec.Vec3{1.0, 1.0, 1.0} + @as(vec.Vec3, @splat(t)) * vec.Vec3{0.5,0.7,1.0}; 
    return ray_color;
}

/// normalizes to 0 -> 255 for values from 0.0-> 1.0
pub fn pointToColor(point: vec.Point3) vec.Color {
    const screen_r  = @as(i32, @intFromFloat(255.99 * point[0]));
    const screen_g  = @as(i32, @intFromFloat(255.99 * point[1]));
    const screen_b  = @as(i32, @intFromFloat(255.99 * point[2]));
    return vec.Color {screen_r, screen_g, screen_b};
}
