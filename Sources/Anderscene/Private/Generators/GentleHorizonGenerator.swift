
import SwiftUI

struct GentleHorizonGenerator {

    let seed: UInt64

    func generate(verticalOffset: CGFloat, heightRange: Range<CGFloat> = CGFloat(-0.02) ..< CGFloat(0.02)) -> PathSpec {

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

}
