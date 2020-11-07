
import SwiftUI

struct TreeGenerator {

    static let treeRange: Range<CGFloat> = 0.09 ..< 0.11

    let seed: UInt64

    func generate(p1: RelativePoint,
                  p2: RelativePoint,
                  cp1: RelativePoint,
                  cp2: RelativePoint,
                  heightRangeMultiplier: CGFloat,
                  maxTrees: Int) -> [TreeSpec] {

        guard maxTrees > 0 else { return [] }

        let heightRange = Self.treeRange.lowerBound * heightRangeMultiplier ..< Self.treeRange.upperBound * heightRangeMultiplier

        var rng = RNG(seed: seed)
        var trees = [TreeSpec]()

        for i in 0 ..< rng.nextInt(0 ..< maxTrees) {
            let distance = rng.nextCGFloat(-0.1 ..< 1.1)
            let p3 = RelativePoint.pointAtDistanceOnBezierCurve(distance: distance, p0: p1, p0hr: cp1, p1: p2, p1hl: cp2)
            let height = i == 0 ? heightRange.lowerBound : heightRange.upperBound
            let shade = rng.nextInt(0 ..< 4)
            let point = RelativePoint(x: p3.x, y: p3.y + 0.02)
            let tree = TreeSpec(point: point, height: height, shade: shade)
            trees.append(tree)
        }

        return trees
    }

}
