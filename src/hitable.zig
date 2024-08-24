const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const vec = @import("vec.zig");

pub const HitRecord = struct {
    point: Vec3,
    normal: Vec3,
    t: f64,
    front_face: bool,
    const Self = @This();

    fn set_face_normal(self: *HitRecord, r: Ray, outward_normal: Vec3) !void {
        self.front_face = vec.dot_vector(r.direction, outward_normal) < 0.0; 
        if (self.front_face) {
            self.normal = outward_normal;
        } else {
            self.normal = -outward_normal;
        }
    }
};


// pub fn hit(ray: Ray, ray_tmin: f64, ray_tmax: f64, rec: hit_record) bool {
//     return true;
// }
