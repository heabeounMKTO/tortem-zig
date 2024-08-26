pub const Point3 = @Vector(3, f64);
pub const Color = @Vector(3, i32);
pub const Vec3 = @Vector(3, f64);
pub const ray = @import("ray.zig");
const std = @import("std");
const math = std.math;
const utils = @import("utils.zig");

pub fn vsize(comptime v: anytype) comptime_int {
    const T = @TypeOf(v);
    return @typeInfo(T).Vector.len;
}
pub fn unit_vector_from_ray(r: ray.Ray) Vec3 {
    return r.direction / @as(Vec3, @splat(math.sqrt(@reduce(.Add, r.direction * r.direction))));
}

pub fn vector_length_sq(v: Vec3) f64 {
    return (v[0] * v[0]) + (v[1] * v[1]) + (v[2] * v[2]);
}

pub fn vector_length(v: Vec3) f64 {
    return @sqrt(vector_length_sq(v));
}

pub fn unit_vector(v: Vec3) Vec3 {
    return v / @as(Vec3, @splat(vector_length(v)));
}

pub fn dot_vector(v1: Vec3, v2: Vec3) f64 {
    const a = v1[0] * v2[0];
    const b = v1[1] * v2[1];
    const c = v1[2] * v2[2];
    return a + b + c;
}

pub fn random(min: i32, max: i32) Vec3 {
    return Vec3{ utils.random_range_f64(min, max), utils.random_range_f64(min, max), utils.random_range_f64(min, max) };
}

pub fn random_in_unit_sphere() Vec3 {
    while (true) {
        const p = random(-1, 1);
        if (vector_length_sq(p) < 1.0) {
            return p;
        }
    }
}

pub fn random_unit_vector() Vec3 {
    return unit_vector(random_in_unit_sphere());
}

pub fn random_on_hemisphere(normal: Vec3) Vec3 {
    const on_unit_sphere: Vec3 = random_unit_vector();
    if (dot_vector(on_unit_sphere, normal) > 0.0) {
        return on_unit_sphere;
    } else {
        return -on_unit_sphere;
    }
}
