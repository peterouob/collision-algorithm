const std = @import("std");

const vec2 = @import("vec2.zig");
const Vec2 = vec2.Vec2;

const gjk = @import("gjk.zig");
const Simplex = gjk.Simplex;
const Shape = @import("shape.zig").Shape;

const eps = 1e-5;

const testing = std.testing;

fn expectPerpTowardOrigin(d: Vec2, a: Vec2, b: Vec2) !void {
    const ab = b.sub(a);
    const ao = a.neg();
    try testing.expectApproxEqAbs(@as(f32, 0), d.dot(ab), eps);
    try testing.expect(d.dot(ao) > 0);
}

test "o under the horizon" {
    const b = Vec2{ .x = 5, .y = 1 };
    const a = Vec2{ .x = -5, .y = 1 };
    var s: Simplex = .{};
    s.push(b);
    s.push(a);
    var d = Vec2{ .x = 0, .y = 0 };

    try testing.expect(!gjk.handleSimplex(&s, &d));
    try testing.expectEqual(@as(u8, 2), s.len);
    try expectPerpTowardOrigin(d, a, b);
    try testing.expect(d.y < 0);
}

test "o in the triangle" {
    var s: Simplex = .{};
    s.push(.{ .x = -1, .y = -1 }); // C
    s.push(.{ .x = 2, .y = -1 }); // B
    s.push(.{ .x = 0, .y = 2 }); // A
    var d = Vec2{ .x = 0, .y = 0 };

    try testing.expect(gjk.handleSimplex(&s, &d));
}

test "gjk polygons" {
    const sq = [_]Vec2{ .{ .x = 0, .y = 0 }, .{ .x = 2, .y = 0 }, .{ .x = 2, .y = 2 }, .{ .x = 0, .y = 2 } };
    const near = [_]Vec2{ .{ .x = 1, .y = 1 }, .{ .x = 3, .y = 1 }, .{ .x = 3, .y = 3 }, .{ .x = 1, .y = 3 } };
    const far = [_]Vec2{ .{ .x = 5, .y = 5 }, .{ .x = 7, .y = 5 }, .{ .x = 7, .y = 7 }, .{ .x = 5, .y = 7 } };
    const a = Shape{ .Polygon = .{ .verts = &sq } };
    try testing.expect(gjk.gjk(a, .{ .Polygon = .{ .verts = &near } }));
    try testing.expect(!gjk.gjk(a, .{ .Polygon = .{ .verts = &far } }));
    try testing.expect(gjk.gjk(a, .{ .Circle = .{ .center = .{ .x = 2.5, .y = 1 }, .radius = 1 } }));
}
