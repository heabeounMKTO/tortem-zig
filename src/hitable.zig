const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;

pub const HitRecord = struct {
    point: Vec3,
    normal: Vec3,
    t: f64,
    const Self = @This();
};


// pub fn hit(ray: Ray, ray_tmin: f64, ray_tmax: f64, rec: hit_record) bool {
//     return true;
// }
