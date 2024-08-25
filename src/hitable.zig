const Vec3 = @import("vec.zig").Vec3;
const Ray = @import("ray.zig").Ray;
const vec = @import("vec.zig");
const sphere = @import("sphere.zig");
const std = @import("std");

// we only have spheres for now kied
pub const HitableList = struct {
    objects: std.ArrayList(sphere.Sphere),
    allocator: std.mem.Allocator,
    const Self = @This();

    pub fn deinit(self: *Self) void {
        self.objects.deinit();
    }

    // initializes a world
    pub fn create(allocator: std.mem.Allocator) HitableList {
        return HitableList{ .objects = std.ArrayList(sphere.Sphere).init(allocator), .allocator = allocator };
    }

    pub fn add(self: *HitableList, object: sphere.Sphere) !void {
        try self.objects.append(object);
    }
};

pub fn check_world_hit(world: HitableList, r: Ray, ray_tmin: f64, ray_tmax: f64) HitRecord {
    var hit_rec = HitRecord.init();
    for (world.objects) |*object| {
        var closest_so_far: f64 = 0.0;
        const hit_kor_mex = object.hit(r, ray_tmin, ray_tmax);
        closest_so_far = hit_kor_mex.t;
        if (hit_kor_mex.is_hit) {
            hit_rec = hit_kor_mex;
        }
    }
    return hit_rec;
}

pub const HitRecord = struct {
    point: Vec3,
    normal: Vec3,
    t: f64,
    front_face: bool,
    is_hit: bool,
    const Self = @This();
    pub fn no_hits() HitRecord {
        return HitRecord{ .point = vec.Vec3{ 0.0, 0.0, 0.0 }, .normal = vec.Vec3{ 0.0, 0.0, 0.0 }, .t = 0.0, .front_face = false, .is_hit = false };
    }
    pub fn init() HitRecord {
        return HitRecord{ .point = vec.Vec3{ 0.0, 0.0, 0.0 }, .normal = vec.Vec3{ 0.0, 0.0, 0.0 }, .t = 0.0, .front_face = false, .is_hit = false };
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
