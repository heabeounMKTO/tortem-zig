pub const INFINITY = @import("utils.zig").INFINITY;


pub const Interval = struct {
    min: f64,
    max: f64,
    const Self = @This();
    
    pub fn size(self: @This()) f64 {
        return self.max - self.min;
    }
    pub fn surrounds(self: @This(), x: f64) bool {
       return self.min < x and x < self.max; 
    }
    pub fn clamp(self: @This(), x: f64) f64 {
        if (x < self.min) {
            return self.min;
        } 
        if (x > self.max) {
            return self.max;
        }
        return x;
    }
    pub fn init() Interval {
        return  Interval {
            .min = 0.0,
            .max = 0.0
        };
    } 
    pub fn universe() Interval {
        return Interval {
            .min = -INFINITY,
            .max = INFINITY
        };
    }
};
