
import Swift
import SwiftUI

infix operator • : MultiplicationPrecedence
struct Anderscene {

    struct SkyBallSpec {
        let point: RelativePoint
        let size: CGFloat
    }

    struct TreeSpec {
        let point: RelativePoint
        let height: CGFloat
        let shade: Int
    }

    struct HillSpec {
        let pathSpec: PathSpec
        let trees: [TreeSpec]
    }

    struct ShoreSpec {

        let pathSpec: PathSpec
        let trees: [TreeSpec]

    }

    static func generateSkyBall(withSeed seed: UInt64) -> SkyBallSpec {
        var rng = RNG(seed: seed)
        let point = RelativePoint(x: rng.nextCGFloat(0.1 ..< 0.9),
                                  y: rng.nextCGFloat(0.1 ..< 0.3))
        let size = rng.nextCGFloat(0.1 ..< 0.2)
        return SkyBallSpec(point: point, size: size)
    }

    static func generateHorizontal(withSeed seed: UInt64, verticalOffset: CGFloat, heightRange: Range<CGFloat> = CGFloat(-0.02) ..< CGFloat(0.02)) -> PathSpec {

        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x: CGFloat = 0
        let y = verticalOffset + rng.nextCGFloat(heightRange)

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

        // MARK: TODO - round the peaks

        // MARK: TODO - snow??

        let heightRange = CGFloat(0.05) ..< CGFloat(0.1)

        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x: CGFloat = rng.nextCGFloat(-1 ..< 0)
        var y: CGFloat = 0.45

        path.append(.moveTo(point: .init(x: x, y: y)))
        while x < 1 {
            let distance = rng.nextCGFloat(0.1 ..< 0.5)
            let height = rng.nextCGFloat(heightRange)
            path.append(.addLine(point: .init(x: x + distance / 2, y: y + height)))

            y += rng.nextCGFloat(0 ..< height / 2)

            path.append(.addLine(point: .init(x: x + distance, y: y)))
            x += distance
        }

        path.append(.addLine(point: .init(x: 1.0, y: y + rng.nextCGFloat(heightRange))))
        path.append(.addLine(point: .init(x: 1.0, y: 1.0)))
        path.append(.addLine(point: .init(x: 0.0, y: 1.0)))

        return PathSpec(path: path)
    }

    static func generateTrees(withSeed seed: UInt64, betweenX xRange: Range<CGFloat>, atY y: CGFloat, maxHeight: CGFloat) -> [TreeSpec] {

        var rng = RNG(seed: seed)
        var trees = [TreeSpec]()

        let diffX = xRange.upperBound - xRange.lowerBound
        var x = xRange.lowerBound
        while x < xRange.upperBound {
            x += rng.nextCGFloat(0.0 ..< diffX)
            trees.append(TreeSpec(point: RelativePoint(x: x, y: y),
                                  height: rng.nextCGFloat(0.02 ..< maxHeight),
                                  shade: rng.nextInt(0 ..< 4)))
        }

        return trees
    }

    static func generateHill(withSeed seed: UInt64, verticalOffset: CGFloat) -> HillSpec {
        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x = rng.nextCGFloat(-0.5 ..< 0.0)
        var y = verticalOffset
        var lastHumpHeight: CGFloat = 0.0
        var lastHumpDistance: CGFloat = 0.0
        var trees = [TreeSpec]()

        func addHump() {

            path.append(.addCurve(point: .init(x: x + lastHumpDistance, y: y - lastHumpHeight / 2),
                                  cp1: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight),
                                  cp2: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight)))

            trees += generateTrees(withSeed: rng.next(),
                                   betweenX: x ..< x + lastHumpDistance,
                                   atY: y - lastHumpHeight / 3,
                                   maxHeight: verticalOffset / 15)

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

        func randomize() {
            let yMod = rng.nextCGFloat(0 ..< 0.02)

            if x < 0.5 {
                y -= yMod
            } else {
                y += yMod
            }

            lastHumpDistance = rng.nextCGFloat(0.1 ..< 0.5)
            lastHumpHeight = rng.nextCGFloat(lastHumpDistance / 10 ..< lastHumpDistance / 3)
        }

        path.append(.moveTo(point: .init(x: x, y: y)))
        while x < 1.0 {
            randomize()
            addHump()
            addSpacer()
        }
        randomize()
        addHump()

        path.append(.addLine(point: .init(x: 1.0, y: y)))
        path.append(.addLine(point: .init(x: 1.0, y: 1.0)))
        path.append(.addLine(point: .init(x: 0.0, y: 1.0)))

        return HillSpec(pathSpec: PathSpec(path: path), trees: trees)
    }

    static func generateHills(withSeed seed: UInt64) -> [HillSpec] {
        var rng = RNG(seed: seed)

        return [
            generateHill(withSeed: rng.next(), verticalOffset: 0.7),
            generateHill(withSeed: rng.next(), verticalOffset: 0.75)
        ]
    }

    static func generateCloud(withSeed seed: UInt64) -> PathSpec {

        var rng = RNG(seed: seed)
        var x = rng.nextCGFloat(0.1 ..< 0.9)
        let y = rng.nextCGFloat(0.1 ..< 0.4)
        var lastHumpHeight: CGFloat = 0.0
        var lastHumpDistance: CGFloat = 0.0
        let mod: CGFloat = 0.1

        func randomize() {
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

        randomize()
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
            randomize()
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
            generateCloud(withSeed: rng.next())
        }
    }

    static func generateHaze(withSeed seed: UInt64) -> PathSpec {
        return generateHorizontal(withSeed: seed, verticalOffset: 0.4, heightRange: -0.02 ..< 0.02)
    }

    static func generateShore(withSeed seed: UInt64) -> ShoreSpec {
        var rng = RNG(seed: seed)
        let horizontal = generateHorizontal(withSeed: rng.next(), verticalOffset: 0.75, heightRange: -0.01 ..< 0.01)

        let trees = generateTrees(withSeed: rng.next(), betweenX: -0.1 ..< 1.1, atY: 0.76, maxHeight: 0.08)

        return ShoreSpec(pathSpec: horizontal, trees: trees)
    }

    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        let skyBall = generateSkyBall(withSeed: rng.next())
        let clouds = generateClouds(withSeed: rng.next())
        let haze = generateHaze(withSeed: rng.next())
        let peaks = generatePeaks(withSeed: rng.next())
        let hills = generateHills(withSeed: rng.next())
        let shore = generateShore(withSeed: rng.next())

        return Anderscene(
            skyBall: skyBall,
            clouds: clouds,
            haze: haze,
            peaks: peaks,
            hills: hills,
            shore: shore
        )
    }

    let skyBall: SkyBallSpec
    let clouds: [PathSpec]
    let haze: PathSpec
    let peaks: PathSpec
    let hills: [HillSpec]
    let shore: ShoreSpec

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
