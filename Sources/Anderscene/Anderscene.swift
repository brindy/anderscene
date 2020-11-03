
import Swift
import SwiftUI

infix operator • : MultiplicationPrecedence
struct Anderscene {

    struct SkyBallSpec {

        let point: RelativePoint

        /// Relative to width
        let size: CGFloat

    }

    static func generateSkyBall(withSeed seed: UInt64) -> SkyBallSpec {
        var rng = RNG(seed: seed)
        let point = RelativePoint(x: rng.nextCGFloat(0.1 ..< 0.9),
                                  y: rng.nextCGFloat(0.1 ..< 0.3))
        let size = rng.nextCGFloat(0.1 ..< 0.2)
        return SkyBallSpec(point: point, size: size)
    }

    static func generateHaze(withSeed seed: UInt64) -> PathSpec {
        let heightRange = CGFloat(-0.02) ..< CGFloat(0.02)

        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x: CGFloat = 0
        let y = 0.4 + rng.nextCGFloat(heightRange)

        path.append(.moveTo(point: .init(x: x, y: y)))
        repeat {
            x += rng.nextCGFloat(0.15 ..< 0.25)
            let height = rng.nextCGFloat(heightRange)
            path.append(.addLine(point: .init(x: x, y: y + height)))
        } while x < 1

        path.append(.addLine(point: .init(x: 1.0, y: y + rng.nextCGFloat(heightRange))))
        path.append(.addLine(point: .init(x: 1.0, y: 1.0)))
        path.append(.addLine(point: .init(x: 0.0, y: 1.0)))

        return PathSpec(path: path)
    }

    static func generatePeaks(withSeed seed: UInt64) -> PathSpec {

        let heightRange = CGFloat(0.05) ..< CGFloat(0.1)

        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x: CGFloat = rng.nextCGFloat(-1 ..< 0)
        let y: CGFloat = 0.45

        path.append(.moveTo(point: .init(x: x, y: y)))
        repeat {
            let distance = rng.nextCGFloat(0.1 ..< 0.5)
            let height = rng.nextCGFloat(heightRange)
            path.append(.addLine(point: .init(x: x + distance / 2, y: y + height)))
            path.append(.addLine(point: .init(x: x + distance, y: y)))
            x += distance
        } while x < 1

        path.append(.addLine(point: .init(x: 1.0, y: y + rng.nextCGFloat(heightRange))))
        path.append(.addLine(point: .init(x: 1.0, y: 1.0)))
        path.append(.addLine(point: .init(x: 0.0, y: 1.0)))

        return PathSpec(path: path)
    }

    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        let skyBall = generateSkyBall(withSeed: rng.next())
        let clouds = generateClouds(withSeed: rng.next())
        let haze = generateHaze(withSeed: rng.next())
        let peaks = generatePeaks(withSeed: rng.next())
        let hills = RNG(seed: rng.next())
        let shore = RNG(seed: rng.next())

        return Anderscene(
            skyBall: skyBall,
            clouds: clouds,
            haze: haze,
            peaks: peaks,
            hills: hills,
            shore: shore
        )
    }

    static func generateCloud(_ rng: inout RNG) -> PathSpec {

        var x = rng.nextCGFloat(0.1 ..< 0.9)
        let y = rng.nextCGFloat(0.1 ..< 0.4)
        var lastHumpHeight: CGFloat = 0.0
        var lastHumpDistance: CGFloat = 0.0
        let mod: CGFloat = 0.1

        func randomizeHumpAndDistance() {
            lastHumpDistance = rng.nextCGFloat(0.1 ..< 0.15)
            lastHumpHeight = rng.nextCGFloat(0.03 ..< 0.05)
        }

        func addHump() {

            path.append(.addCurve(point: .init(x: x + lastHumpDistance, y: y - lastHumpHeight / 2),
                                  cp1: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight),
                                  cp2: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight)))

            x += lastHumpDistance
        }

        func addSpacer() {
            let height: CGFloat = lastHumpHeight / 2
            let distance = lastHumpDistance / 3
            path.append(.addCurve(point: .init(x: x + distance, y: y - height),
                                  cp1: .init(x: x + distance / 2, y: y - height / 2),
                                  cp2: .init(x: x + distance, y: y - height)))

            x += distance
        }


        var path = [RelativePath]()
        path.append(.moveTo(point: .init(x: x, y: y)))

        // Start under-tuck
        path.append(.addCurve(point: .init(x: x, y: y -% mod),
                              cp1: .init(x: x, y: y),
                              cp2: .init(x: x -% mod, y: y)))

        randomizeHumpAndDistance()
        addHump()

        let extraHumps: Int
        switch rng.nextInt(0 ..< 10) {

        case 0 ..< 5: // 50%
            extraHumps = 2

        case 5 ..< 8: // 30%
            extraHumps = 3

        default: // 20%
            extraHumps = 4

        }

        for _ in 0 ..< extraHumps {
            addSpacer()
            addHump()
            randomizeHumpAndDistance()
        }

        // End under-tuck
        path.append(.addCurve(point: .init(x: x -% mod, y: y),
                              cp1: .init(x: x +% mod, y: y),
                              cp2: .init(x: x -% mod, y: y)))

        return PathSpec(path: path)
    }

    static func generateClouds(withSeed seed: UInt64) -> [PathSpec] {
        var rng = RNG(seed: seed)
        return (0 ..< rng.nextInt(1 ..< 3)).map { _ in
            generateCloud(&rng)
        }
    }

    let skyBall: SkyBallSpec
    let clouds: [PathSpec]
    let haze: PathSpec
    let peaks: PathSpec
    let hills: RNG
    let shore: RNG

}

infix operator +% : AdditionPrecedence
infix operator -% : AdditionPrecedence
extension CGFloat {

    static func +% (left: CGFloat, right: CGFloat) -> CGFloat {
        return left * (1 + right)
    }

    static func -% (left: CGFloat, right: CGFloat) -> CGFloat {
        return left * (1 - right)
    }

}
