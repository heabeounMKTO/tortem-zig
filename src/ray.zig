const vec = @import("vec.zig");
const Point3 = vec.Point3;
const Vec3 = vec.Vec3;

pub const Ray = struct {
    origin: Point3,
    direction: Vec3,
    const Self = @This();
};

pub fn ray_at(ray: Ray, t: f64) Point3 {
    return ray.origin + @as(vec.Vec3, @splat(t)) * ray.direction;
}
