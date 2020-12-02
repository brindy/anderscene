
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
        let treeCount = maxTrees > 0 ? rng.nextInt(0 ..< maxTrees) : 0

        var x: CGFloat = 0.0
        while trees.count < treeCount {
            let upper = 1.1 - x
            if upper < 0.1 {
                break
            }
            x += rng.nextCGFloat(0.1 ..< upper)
            NSLog("*** ".appendingFormat("x: %f"))
            let p3 = RelativePoint.atDistanceOnBezierCurve(distance: x, p0: p1, p0hr: cp1, p1: p2, p1hl: cp2)
            let height = rng.nextCGFloat(heightRange)
            let shade = rng.nextInt(0 ..< 4)
            let point = RelativePoint(x: p3.x, y: p3.y + yOffset)
            let tree = TreeSpec(point: point, height: height, shade: shade)
            trees.append(tree)
        }

        return trees
    }

}

struct TreeGenerator_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        let scene = Anderscene.generate(withSeed: 1)
        let config = Config(palette: palette, scene: scene)

        GeometryReader { g in
            Island(size: g.size)
                .environmentObject(config)
                .background(palette.waterDark)
        }

    }
}
