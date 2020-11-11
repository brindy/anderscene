
import SwiftUI

struct TreeGenerator {

    static let treeRange: Range<CGFloat> = 0.09 ..< 0.11

    let seed: UInt64

    func generate(p1: RelativePoint,
                  p2: RelativePoint,
                  cp1: RelativePoint,
                  cp2: RelativePoint,
                  heightRangeMultiplier: CGFloat,
                  yOffset: CGFloat) -> [TreeSpec] {

        let heightRange = Self.treeRange.lowerBound * heightRangeMultiplier ..< Self.treeRange.upperBound * heightRangeMultiplier

        var rng = RNG(seed: seed)
        var trees = [TreeSpec]()

        let distance = p1.distance(to: p2)
        let maxTrees = Int(distance / 0.05)
        NSLog("*** ".appendingFormat("%f %d", distance, maxTrees))

        var x: CGFloat = 0.0
        while x < 1.0 && trees.count < maxTrees {
            x += rng.nextCGFloat(x ..< 1.0)
            let p3 = RelativePoint.pointAtDistanceOnBezierCurve(distance: x, p0: p1, p0hr: cp1, p1: p2, p1hl: cp2)
            let height = rng.nextCGFloat(heightRange)
            let shade = rng.nextInt(0 ..< 4)
            let point = RelativePoint(x: p3.x, y: p3.y + yOffset)
            let tree = TreeSpec(point: point, height: height, shade: shade)
            trees.append(tree)
        }

        return trees
    }

}
