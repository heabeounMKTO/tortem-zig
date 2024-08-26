const std = @import("std");
const vec = @import("vec.zig");
const ray = @import("ray.zig");
const hitable = @import("hitable.zig");
const Ray = ray.Ray;
const math = std.math;
const INFINITY = @import("utils.zig").INFINITY;
const print = std.io.getStdOut().writer();

pub fn hitSphere(center: vec.Vec3, radius: f64, r: Ray) f64 {
    const oc = center - r.origin;
    const a = vec.vector_length_sq(r.direction); 
    const h = vec.dot_vector(r.direction, oc);
    const c = vec.vector_length_sq(oc) - (radius * radius);
    const discriminant = (h*h ) - ( a*c);
    if (discriminant < 0.0) {
        return -1.0;
    } else {
        return (h - @sqrt(discriminant)) / a;
    }
}

pub fn rayColor(r: Ray, world: hitable.HitableList) vec.Vec3 {
    const world_hits = hitable.check_world_hit(world, r, 0, INFINITY); 
    if (world_hits.is_hit) {
        const n = world_hits.normal;
        return vec.Vec3 { n[0] + 1.0, n[1] + 1.0 , n[2] + 1.0 } * @as(vec.Vec3, @splat(0.5));
    } else {
        const unit_direction: vec.Vec3 = vec.unit_vector_from_ray(r);
        const a = 0.5 * (unit_direction[1] + 1.0);
        const ray_color =  @as(vec.Vec3, (@splat(1.0 - a))) * vec.Vec3{ 1.0, 1.0, 1.0 } + @as(vec.Vec3, @splat(a)) * vec.Vec3{ 0.5, 0.6, 1.0 };
        return ray_color;
    }
}

/// returns color from where da ray touches
// pub fn rayColor(r: Ray) vec.Vec3 {
//     const t = hitSphere(vec.Vec3{ 0.0, 0.0, -1.0 }, 0.5, r);
//     if (t > 0.0) {
//         const n = vec.unit_vector(ray.ray_at(r, t) - vec.Vec3{ 0.0, 0.0, -1.0 });

//         // if i add 1 instead of 1.0 = causes precision loss (obviously)
//         return vec.Vec3 { n[0] + 1.0, n[1] + 1.0, n[2] + 1.0 } * @as(vec.Vec3, @splat(0.5));
//     }
//     const unit_direction: vec.Vec3 = vec.unit_vector_from_ray(r);
//     const a = 0.5 * (unit_direction[1] + 1.0);
//     const ray_color =  @as(vec.Vec3, (@splat(1.0 - a))) * vec.Vec3{ 1.0, 1.0, 1.0 } + @as(vec.Vec3, @splat(a)) * vec.Vec3{ 0.5, 0.6, 1.0 };
//     return ray_color;
// }

/// normalizes to 0 -> 255 for values from 0.0-> 1.0
pub fn pointToColor(point: vec.Point3) vec.Color {
    const screen_r = @as(i32, @intFromFloat(255.99 * point[0]));
    const screen_g = @as(i32, @intFromFloat(255.99 * point[1]));
    const screen_b = @as(i32, @intFromFloat(255.99 * point[2]));
    return vec.Color{ screen_r, screen_g, screen_b };
}
