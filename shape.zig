const Vec2 = @import("vec2.zig").Vec2;

pub const Shape = union(enum) {
    Circle: struct { center: Vec2, radius: f32 },
    Polygon: struct { verts: []const Vec2 },

    pub fn avgPoint(shape: Shape) Vec2 {
        switch (shape) {
            .Circle => |c| return c.center,
            .Polygon => |p| {
                var avg: Vec2 = .{ .x = 0, .y = 0 };
                for (p.verts) |v| {
                    avg.x += v.x;
                    avg.y += v.y;
                }

                const n: f32 = @floatFromInt(p.verts.len);
                return avg.scale(1 / n);
            },
        }
    }

    pub fn support(shape: Shape, d: Vec2) Vec2 {
        switch (shape) {
            .Circle => |c| {
                const len = @sqrt(d.x * d.x + d.y * d.y);
                if (len == 0) return c.center;
                return .{
                    .x = c.center.x + (d.x / len) * c.radius,
                    .y = c.center.y + (d.y / len) * c.radius,
                };
            },
            .Polygon => |p| {
                var farthest = p.verts[0];
                var best = farthest.x * d.x + farthest.y * d.y;
                for (p.verts[1..]) |v| {
                    const cur = v.dot(d);
                    if (cur > best) {
                        best = cur;
                        farthest = v;
                    }
                }
                return farthest;
            },
        }
    }
};

pub fn minkowskit(a: Shape, b: Shape, d: Vec2) Vec2 {
    const pa = a.support(d);
    const pb = b.support(d.neg());

    return pa.sub(pb);
}
