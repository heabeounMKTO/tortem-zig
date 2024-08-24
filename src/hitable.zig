const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const vec = @import("vec.zig");
const sphere = @import("sphere.zig");


// we only have spheres for now kied
pub const HitableList = struct {
    objects: [] sphere.Sphere,  
    const Self = @This();
    
    // initializes a world
    pub fn create(object: sphere.Sphere) HitableList {
        return HitableList {
            .objects = [_]sphere.Sphere{object},
        };
    }

    pub fn add(self: *HitableList, object: sphere.Sphere) !void {
        self.objects.append(object);
    }

};

pub fn check_hit(world: HitableList, r: Ray , ray_tmin: f64, ray_tmax: f64, record: HitRecord) bool {
    var hit_anything: bool = false;
    var closest_so_far = ray_tmax; 
    for (world.objects) |*object| {
        const temp_rec = HitRecord.init();
        if (object.hit(r , ray_tmin, closest_so_far, temp_rec)) {
            hit_anything = true;
            closest_so_far = temp_rec.t;
            record = temp_rec;
        }
    }
    return hit_anything;
}

pub const HitRecord = struct {
    point: Vec3,
    normal: Vec3,
    t: f64,
    front_face: bool,
    const Self = @This();
    pub fn init() HitRecord {
        return HitRecord {
            .point = vec.Vec3 {0.0, 0.0, 0.0},
            .normal = vec.Vec3 {0.0 , 0.0, 0.0},
            .t = 0.0,
            .front_face = false
        };
    }
    fn set_face_normal(self: *HitRecord, r: Ray, outward_normal: Vec3) !void {
        self.front_face = vec.dot_vector(r.direction, outward_normal) < 0.0; 
        if (self.front_face) {
            self.normal = outward_normal;
        } else {
            self.normal = -outward_normal;
        }
    }
};

