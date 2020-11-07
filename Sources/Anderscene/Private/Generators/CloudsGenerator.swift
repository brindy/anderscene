
import SwiftUI

struct CloudsGenerator {

    let seed: UInt64

    func generateCloud(withSeed seed: UInt64) -> CloudSpec {

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

    func generate() -> [CloudSpec] {
        var rng = RNG(seed: seed)
        return (0 ..< rng.nextInt(1 ..< 3)).map { _ in
            generateCloud(withSeed: rng.next())
        }
    }

}
