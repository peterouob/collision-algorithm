pub const Vec2 = struct {
    x: f32,
    y: f32,

    pub fn dot(a: Vec2, b: Vec2) f32 {
        return a.x * b.x + a.y * b.y;
    }

    pub fn sub(a: Vec2, b: Vec2) Vec2 {
        return .{ .x = a.x - b.x, .y = a.y - b.y };
    }

    pub fn neg(a: Vec2) Vec2 {
        return .{ .x = -a.x, .y = -a.y };
    }

    pub fn scale(a: Vec2, s: f32) Vec2 {
        return .{ .x = a.x * s, .y = a.y * s };
    }
};

pub fn threeCross(a: Vec2, b: Vec2, c: Vec2) Vec2 {
    const ac = a.dot(c);
    const bc = b.dot(c);

    const x = ac * b.x - bc * a.x;
    const y = ac * b.y - bc * a.y;

    return .{ .x = x, .y = y };
}

const testing = @import("std").testing;

fn expectVec(expected: Vec2, actual: Vec2) !void {
    try testing.expectApproxEqAbs(expected.x, actual.x, 1e-5);
    try testing.expectApproxEqAbs(expected.y, actual.y, 1e-5);
}

test "three cross" {
    const a = Vec2{ .x = 1, .y = 1 };
    const b = Vec2{ .x = -1, .y = 1 };
    const ab = b.sub(a);
    const ao = a.neg();

    const d = threeCross(ab, ao, ab);
    try expectVec(.{ .x = 0, .y = -4 }, d);
}

test "three cross with three element" {
    const a = Vec2{ .x = 1, .y = 0 };
    const b = Vec2{ .x = 0, .y = 1 };
    const c = Vec2{ .x = 1, .y = 1 };

    const d = threeCross(a, b, c);
    try expectVec(.{ .x = -1, .y = 1 }, d);
}
