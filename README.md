## This is a collision algorithm impl by zig

- Now I've only implemented a simple GJK, but I'd love to impl and researcher more algorithm, provided I don't lose interest.

- and now using vec2 struct to represent the (x,y) but i think maybe can use `@Vector(2,f32)` instead. because `@Vector` support SIMD.

## TODO:
- [ ] more shape e.g. Capsule, Oval, Rounded rectangle
- [ ] replace Brute-force approach using Hill Climbing or Simulated Annealing
- [ ] rotation and shift
- [ ] GUI to show the animation
- [ ] transform to 3D and impl more algorithm

- [ ] more collision algo
  - [ ] EPA
  - [ ] Speculative CCD
  - [ ] Continuous GJK
  - [ ] Conservative Advancement


## Ref:

[GJK](https://www.youtube.com/watch?v=ajv46BSqcK4)
