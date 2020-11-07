
import SwiftUI

struct PeaksGenerator {

    let seed: UInt64

    func generate() -> PathSpec {

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

}
