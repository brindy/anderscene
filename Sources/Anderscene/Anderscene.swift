
import Swift
import SwiftUI

struct Anderscene {

    static let treeRange: Range<CGFloat> = 0.09 ..< 0.11

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

    struct CloudSpec: Identifiable {

        let id = UUID().uuidString

        let pathSpec: PathSpec
        let opacity: Double

    }

    struct WaterSpec {

        let shoreHighlight: [RelativePath]
        let mainBody: [RelativePath]
        let mainHighlight: [RelativePath]

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

    // Based on https://b3d.interplanety.org/en/creating-points-on-a-bezier-curve/
    static func pointAt(distance t: CGFloat,
                        p0: RelativePoint,
                        p0hr: RelativePoint,
                        p1: RelativePoint,
                        p1hl: RelativePoint) -> RelativePoint {

        let t1 = p0 + (p0hr - p0) * t
        let t2 = p0hr + (p1hl - p0hr) * t
        let t3 = p1hl + (p1 - p1hl) * t
        let p2hl = t1 + (t2 - t1) * t
        let p2hr = t2 + (t3 - t2) * t
        let p2 = p2hl + (p2hr - p2hl) * t

        return p2
    }

    static func generateTrees(withSeed seed: UInt64,
                              p1: RelativePoint,
                              p2: RelativePoint,
                              cp1: RelativePoint,
                              cp2: RelativePoint,
                              heightRange: Range<CGFloat>,
                              maxTrees: Int) -> [TreeSpec] {

        guard maxTrees > 0 else { return [] }

        var rng = RNG(seed: seed)
        var trees = [TreeSpec]()

        for i in 0 ..< rng.nextInt(0 ..< maxTrees) {
            let distance = rng.nextCGFloat(-0.1 ..< 1.1)
            let p3 = pointAt(distance: distance, p0: p1, p0hr: cp1, p1: p2, p1hl: cp2)
            let height = i == 0 ? heightRange.lowerBound : heightRange.upperBound
            let shade = rng.nextInt(0 ..< 4)
            let point = RelativePoint(x: p3.x, y: p3.y + 0.02)
            let tree = TreeSpec(point: point, height: height, shade: shade)
            trees.append(tree)
        }

        return trees
    }

    static func generateHill(withSeed seed: UInt64, verticalOffset: CGFloat, treeHeightRange: Range<CGFloat>) -> HillSpec {

        let minDistance: CGFloat = 0.1
        let maxDistance: CGFloat = 0.5

        var rng = RNG(seed: seed)
        var path = [RelativePath]()
        var x = rng.nextCGFloat(-0.1 ..< 0.0)
        var y = verticalOffset
        var lastHumpHeight: CGFloat = 0.0
        var lastHumpDistance: CGFloat = 0.0
        var trees = [TreeSpec]()
        var lastP: RelativePoint = RelativePoint(x: x, y: y)

        func addHump() {

            let distance = lastHumpDistance
            let p = RelativePoint(x: x + distance, y: y - lastHumpHeight / 2)
            let cp1 = RelativePoint(x: x + distance / 2, y: y - lastHumpHeight)
            let cp2 = RelativePoint(x: x + distance / 2, y: y - lastHumpHeight)

            path.append(.addBezierCurve(point: p, cp1: cp1, cp2: cp2))

            trees += generateTrees(withSeed: seed, p1: lastP, p2: p, cp1: cp1, cp2: cp2, heightRange: treeHeightRange, maxTrees: Int(distance / minDistance))

            x += distance
            lastP = p
        }

        func addSpacer() {
            let height: CGFloat = lastHumpHeight / 2
            let distance = lastHumpDistance / 3
            let p = RelativePoint(x: x + distance, y: y - height)
            let cp1 = RelativePoint(x: x + distance / 2, y: y - height / 2)
            let cp2 = RelativePoint(x: x + distance, y: y - height)

            path.append(.addBezierCurve(point: p, cp1: cp1, cp2: cp2))

            trees += generateTrees(withSeed: seed, p1: lastP, p2: p, cp1: cp1, cp2: cp2, heightRange: treeHeightRange, maxTrees: Int(distance / minDistance))

            x += distance
            lastP = p
        }

        func randomize() {
            let yMod = rng.nextCGFloat(0 ..< 0.02)

            if x < 0.5 {
                y -= yMod
            } else {
                y += yMod
            }

            lastHumpDistance = rng.nextCGFloat(minDistance ..< maxDistance)
            lastHumpHeight = rng.nextCGFloat(lastHumpDistance / 10 ..< lastHumpDistance / 3)
        }

        path.append(.moveTo(point: lastP))
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

    static func range(_ r: Range<CGFloat>, multipliedBy mod: CGFloat) -> Range<CGFloat> {
        return r.lowerBound * mod ..< r.upperBound * mod
    }

    static func generateHills(withSeed seed: UInt64) -> [HillSpec] {
        var rng = RNG(seed: seed)

        return [
            generateHill(withSeed: rng.next(), verticalOffset: 0.6, treeHeightRange: range(Self.treeRange, multipliedBy: 0.4)),
            generateHill(withSeed: rng.next(), verticalOffset: 0.65, treeHeightRange: range(Self.treeRange, multipliedBy: 0.35))
        ]
    }

    static func generateCloud(withSeed seed: UInt64) -> CloudSpec {

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

            path.append(.addBezierCurve(point: .init(x: x + lastHumpDistance, y: y - lastHumpHeight / 2),
                                  cp1: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight),
                                  cp2: .init(x: x + lastHumpDistance / 2, y: y - lastHumpHeight)))

            x += lastHumpDistance
        }

        func addSpacer() {
            let height: CGFloat = lastHumpHeight / 2
            let distance = lastHumpDistance / 3
            path.append(.addBezierCurve(point: .init(x: x + distance, y: y - height),
                                  cp1: .init(x: x + distance / 2, y: y - height / 2),
                                  cp2: .init(x: x + distance, y: y - height)))

            x += distance
        }


        var path = [RelativePath]()
        path.append(.moveTo(point: .init(x: x, y: y)))

        // Start under-tuck
        path.append(.addBezierCurve(point: .init(x: x, y: y -% mod),
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
        path.append(.addBezierCurve(point: .init(x: x -% mod, y: y),
                              cp1: .init(x: x +% mod, y: y),
                              cp2: .init(x: x -% mod, y: y)))

        let opacity = rng.nextDouble(0.5 ..< 1.0)
        return CloudSpec(pathSpec: PathSpec(path: path), opacity: opacity)
    }

    static func generateClouds(withSeed seed: UInt64) -> [CloudSpec] {
        var rng = RNG(seed: seed)
        return (0 ..< rng.nextInt(1 ..< 3)).map { _ in
            generateCloud(withSeed: rng.next())
        }
    }

    static func generateHaze(withSeed seed: UInt64) -> PathSpec {
        return generateHorizontal(withSeed: seed,
                                  verticalOffset: 0.45,
                                  heightRange: -0.02 ..< 0.02)
    }

    static func generateShore(withSeed seed: UInt64) -> ShoreSpec {
        var rng = RNG(seed: seed)

        let verticalOffset: CGFloat = 0.7

        let horizontal = generateHorizontal(withSeed: rng.next(), verticalOffset: verticalOffset, heightRange: -0.01 ..< 0.01)

        let p1 = RelativePoint(x: 0, y: verticalOffset)
        let p2 = RelativePoint(x: 1.0, y: verticalOffset)

        let treeRange = range(Self.treeRange, multipliedBy: verticalOffset)
        let trees = generateTrees(withSeed: seed,
                                  p1: p1,
                                  p2: p2,
                                  cp1: p1,
                                  cp2: p2,
                                  heightRange: treeRange,
                                  maxTrees: 10)

        return ShoreSpec(pathSpec: horizontal, trees: trees)
    }

    static func generateWaterSpec(withSeed seed: UInt64) -> WaterSpec {

        let shoreHighlightOffset: CGFloat = 0.725
        let mainBodyOffset: CGFloat = shoreHighlightOffset + 0.004
        let mainHighlightOffset: CGFloat = 0.7425
        let mainHighlightHeight: CGFloat = 0.03

        let shoreHighlight: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: shoreHighlightOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: shoreHighlightOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 0, y: mainBodyOffset))
        ]

        let mainBody: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: 1.0)),
            .addLine(point: RelativePoint(x: 0, y: 1.0))
        ]

        var mainHighlight: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: mainHighlightOffset)),
            .addLine(point: RelativePoint(x: 0, y: mainHighlightOffset + mainHighlightHeight)),
        ]

        var rng = RNG(seed: seed)
        var x = rng.nextCGFloat(-0.5 ..< 0)
        while x < 1.1 {

            let distance = rng.nextCGFloat(0.3 ..< 0.5)
            let height = rng.nextCGFloat(0.01 ..< 0.015)
            x += distance

            let p = RelativePoint(x: x, y: mainHighlightOffset + mainHighlightHeight)

            mainHighlight.append(
                .addBezierCurve(point: p,
                                cp1: p.modY(by: -height).modX(by: -distance + distance / 2),
                                cp2: p.modY(by: height).modX(by: -distance / 2))
            )

        }

        mainHighlight.append(.addLine(point: RelativePoint(x: x, y: mainHighlightOffset)))

        // MARK: TODO add sparkles

        return WaterSpec(shoreHighlight: shoreHighlight,
                         mainBody: mainBody,
                         mainHighlight: mainHighlight)
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
        let water = generateWaterSpec(withSeed: rng.next())

        return Anderscene(
            skyBall: skyBall,
            clouds: clouds,
            haze: haze,
            peaks: peaks,
            hills: hills,
            shore: shore,
            water: water
        )
    }

    let skyBall: SkyBallSpec
    let clouds: [CloudSpec]
    let haze: PathSpec
    let peaks: PathSpec
    let hills: [HillSpec]
    let shore: ShoreSpec
    let water: WaterSpec

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
