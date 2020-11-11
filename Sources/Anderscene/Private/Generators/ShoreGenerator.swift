
import SwiftUI

struct ShoreGenerator {

    let seed: UInt64

    func generate() -> ShoreSpec {
        var rng = RNG(seed: seed)

        let verticalOffset: CGFloat = 0.7

        let horizontal = GentleHorizonGenerator(seed: rng.next())
            .generate(verticalOffset: verticalOffset, heightRange: -0.01 ..< 0.01)

        let p1 = RelativePoint(x: 0, y: verticalOffset)
        let p2 = RelativePoint(x: 1.0, y: verticalOffset)

        let generator = TreeGenerator(seed: seed)
        let trees = generator.generate(p1: p1,
                                       p2: p2,
                                       cp1: p1,
                                       cp2: p2,
                                       heightRangeMultiplier: verticalOffset,
                                       yOffset: 0.01)

        return ShoreSpec(pathSpec: horizontal, trees: trees)
    }

}
