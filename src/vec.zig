pub const Point3 = @Vector(3, f64);
pub const Color = @Vector(3, i32);
pub const Vec3 = @Vector(3, f64);
pub const ray = @import("ray.zig");
const std = @import("std");
const math = std.math;

pub fn vsize(comptime v: anytype) comptime_int {
    const T = @TypeOf(v);
    return @typeInfo(T).Vector.len;
}
pub fn vtype(comptime v: anytype) type {
    const T = @TypeOf(v);
    return @typeInfo(T).Vector.child;
}

pub fn vlenSquared(comptime v: anytype) vtype(v) {
    if (vsize(v) == 0) {
        return 0;
    }
    return @reduce(.Add, v * v);
}

pub fn vlen(comptime v: anytype) vtype(v) {
    if (vsize(v) == 0) {
        return 0;
    }
    return math.sqrt(vlenSquared(v));
}
pub fn unit_vector_from_ray(r: ray.Ray) Vec3 {
    return r.direction / @as(Vec3, @splat(math.sqrt(@reduce(.Add, r.direction * r.direction))));
}
pub fn unit_vector(v: anytype) @TypeOf(v) {
    return v / @as(@TypeOf(v), @splat(@as(vsize(v), vlen(v))));
}

pub fn dot_vector(v1: Vec3, v2: Vec3) f64 {
    const a = v1[0] * v2[0];
    const b = v1[1] * v2[1];
    const c = v1[2] * v2[2];
    return a + b + c;
}
