const std = @import("std");
const math = std.math;

const vec2 = @import("vec2.zig");
const Vec2 = vec2.Vec2;
const threeCross = vec2.threeCross;

const shape = @import("shape.zig");
const Shape = shape.Shape;

pub const Simplex = struct {
    points: [3]Vec2 = undefined,
    len: u8 = 0,

    pub fn push(self: *Simplex, point: Vec2) void {
        std.debug.assert(self.len < 3);
        self.points[self.len] = point;
        self.len += 1;
    }

    pub fn last(self: *const Simplex) Vec2 {
        if (self.len == 0) return .{ .x = 0, .y = 0 };
        return self.points[self.len - 1];
    }

    pub fn remove(self: *Simplex, i: usize) void {
        var j = i;
        while (j + 1 < self.len) : (j += 1) {
            self.points[j] = self.points[j + 1];
        }
        self.len -= 1;
    }
};

pub fn handleSimplex(s: *Simplex, d: *Vec2) bool {
    return switch (s.len) {
        2 => {
            const a = s.points[1];
            const b = s.points[0];
            const ab = b.sub(a);
            const ao = a.neg();
            d.* = threeCross(ab, ao, ab);
            return false;
        },
        3 => {
            const a = s.points[2];
            const b = s.points[1];
            const c = s.points[0];

            const ab = b.sub(a);
            const ac = c.sub(a);

            const abv = threeCross(ac, ab, ab);
            const acv = threeCross(ab, ac, ac);

            const ao = a.neg();

            if (abv.dot(ao) > 0) {
                s.remove(0);
                d.* = abv;
                return false;
            } else if (acv.dot(ao) > 0) {
                s.remove(1);
                d.* = acv;
                return false;
            } else {
                return true;
            }
        },
        else => unreachable,
    };
}

pub fn gjk(shapeA: Shape, shapeB: Shape) bool {
    var d = shapeA.avgPoint().sub(shapeB.avgPoint());
    if (d.dot(d) == 0) d = .{ .x = 1.0, .y = 0.0 };

    var s: Simplex = .{};
    const p0 = shape.minkowskit(shapeA, shapeB, d);
    s.push(p0);
    d = p0.neg();

    for (0..32) |_| {
        const p = shape.minkowskit(shapeA, shapeB, d);
        if (p.dot(d) < 0) return false;
        s.push(p);
        if (handleSimplex(&s, &d)) return true;
    }
    return false;
}
