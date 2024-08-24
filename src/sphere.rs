const HitRecord = @import("hitable.zig").HitRecord;
const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const ray = @import("ray.zig");

pub const Sphere = struct {
    center: Vec3,
    radius: f64,
    const Self = @This();
    
    fn hit(self: *Sphere, ray: Ray, ray_tmin: f64, ray_tmax: f64, record: HitRecord) bool {
        const oc = self.center - r.origin;
        const a = vec.vector_length_sq(r.direction); 
        const h = vec.dot_vector(r.direction, oc);
        const c = vec.vector_length_sq(oc) - (radius * radius);
        const discriminant = (h*h ) - ( a*c);
        if (discriminant < 0.0) {
            return false;
        }     
        const sqrt_discriminant = @sqrt(discriminant);
        const root = (h - sqrt_discriminant) / a;
        if (root <= ray_tmin || ray_tmax <= root) {
            root = ( h + sqrt_discriminant ) / a;
            if (root <= ray_tmin || ray_tmax <= root) {
                return false;
            }
        }

        record.t = root;
        record.p = ray.ray_at(r,record.t);
        record.normal = (record.p - self.center) / radius;
        return true;
    }
} 
