const HitRecord = @import("hitable.zig").HitRecord;
const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const ray = @import("ray.zig");
const vec = @import("vec.zig");

pub const Sphere = struct {
    center: Vec3,
    radius: f64,
    const Self = @This();

    pub fn hit(self: *Sphere, r: Ray, ray_tmin: f64, ray_tmax: f64) HitRecord {
        const oc = self.center - r.origin;
        const a = vec.vector_length_sq(r.direction);
        const h = vec.dot_vector(r.direction, oc);
        const c = vec.vector_length_sq(oc) - (self.radius * self.radius);
        const discriminant = (h * h) - (a * c);

        if (discriminant < 0.0) {
            return HitRecord.no_hits();
        }
        var root = (h - @sqrt(discriminant)) / a;
        if (root <= ray_tmin or ray_tmax <= root) {
            root = (h + @sqrt(discriminant)) / a;
            if (root <= ray_tmin or ray_tmax <= root) {
                return HitRecord.no_hits();
            }
        }
        const t = root;
        const point = ray.ray_at(r, t);
        // const normal =  (point - self.center) / @as(vec.Vec3, @splat(self.radius));
        const outward_normal = (point - self.center) / @as(vec.Vec3, @splat(self.radius));
        var record = HitRecord{.point = point , .t = t, .normal = outward_normal, .front_face = false , .is_hit = true};
        try record.set_face_normal(r, outward_normal);
        return record;
    }
};
