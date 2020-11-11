
import SwiftUI

struct HillGenerator {

    let seed: UInt64

    func generateHill(withSeed seed: UInt64, verticalOffset: CGFloat, treeHeightRangeMultiplier: CGFloat) -> HillSpec {

        let minDistance: CGFloat = 0.1
        let maxDistance: CGFloat = 0.5
        let treeOffset: CGFloat = 0.005

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

            trees += TreeGenerator(seed: seed).generate(p1: lastP, p2: p, cp1: cp1, cp2: cp2, heightRangeMultiplier: treeHeightRangeMultiplier, yOffset: treeOffset)

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

            trees += TreeGenerator(seed: seed).generate(p1: lastP, p2: p, cp1: cp1, cp2: cp2, heightRangeMultiplier: treeHeightRangeMultiplier, yOffset: treeOffset)

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

    func generate() -> [HillSpec] {
        var rng = RNG(seed: seed)

        return [
            generateHill(withSeed: rng.next(), verticalOffset: 0.6, treeHeightRangeMultiplier: 0.4),
            generateHill(withSeed: rng.next(), verticalOffset: 0.65, treeHeightRangeMultiplier: 0.35)
        ]
    }

}
