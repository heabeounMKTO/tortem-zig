// shit that dont fit anywhere else i guess
pub const std = @import("std");
pub const PI: f64 = 3.141526535897932385;
pub const INFINITY = std.math.inf(f64);

pub fn deg_to_rad(degrees: f64) f64 {
    return degrees * PI / 180.0;
}



