
struct SkyBallGenerator {

    let seed: UInt64

    func generatte() -> SkyBallSpec {
        var rng = RNG(seed: seed)
        let point = RelativePoint(x: rng.nextCGFloat(0.1 ..< 0.9),
                                  y: rng.nextCGFloat(0.1 ..< 0.3))
        let size = rng.nextCGFloat(0.1 ..< 0.2)
        return SkyBallSpec(point: point, size: size)
    }


}
