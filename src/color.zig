const std = @import("std");
const vec = @import("vec.zig");



pub fn pointToColor(point: vec.Point3) vec.Color {
    const screen_r  = @as(i32, @intFromFloat(255.99 * point[0]));
    const screen_g  = @as(i32, @intFromFloat(255.99 * point[1]));
    const screen_b  = @as(i32, @intFromFloat(255.99 * point[2]));
    return vec.Color {screen_r, screen_g, screen_b};
}
