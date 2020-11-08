
import SwiftUI

struct RocksGenerator {

    let seed: UInt64

    func generateRock(withSeed seed: UInt64, horizontalOffset: CGFloat) -> RockSpec {

        let verticalOffset: CGFloat = 0.73

        var rng = RNG(seed: seed)
        let cpMod: CGFloat = 0.01
        let hlMod: CGFloat = 0.004

        var lastP = RelativePoint(x: horizontalOffset + 0.01, y: verticalOffset)

        var mainPath = [RelativePath]()
        var highlightPath = [RelativePath]()

        mainPath.append(.moveTo(point: lastP))
        highlightPath.append(.moveTo(point: lastP))

        func stepUp() {
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y - 0.01)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP, cp2: nextP.modX(by: -cpMod)))
            highlightPath.append(.addBezierCurve(point: nextP.modY(by: -hlMod).modX(by: -hlMod), cp1: lastP.modY(by: -hlMod).modX(by: -hlMod), cp2: nextP.modX(by: -cpMod).modY(by: -hlMod)))
            lastP = nextP
        }

        func flatLine() {
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP, cp2: nextP))
            highlightPath.append(.addBezierCurve(point: nextP.modY(by: -hlMod).modX(by: hlMod), cp1: lastP.modY(by: -hlMod), cp2: nextP.modY(by: -hlMod)))
            lastP = nextP
        }

        func stepDown() {
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y + 0.01)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP.modX(by: cpMod), cp2: nextP.modX(by: -cpMod)))
            highlightPath.append(.addBezierCurve(point: nextP.modY(by: -hlMod), cp1: lastP.modX(by: cpMod).modY(by: -hlMod), cp2: nextP.modX(by: -cpMod).modY(by: -hlMod)))
            lastP = nextP
        }

        stepUp()

        for _ in 0 ..< rng.nextInt(0 ..< 3) {
            if 0 == rng.nextInt(0 ..< 2) {
                stepUp()
            } else {
                flatLine()
            }
        }

        flatLine()
        stepDown()

        while lastP.y < verticalOffset {
            if 0 == rng.nextInt(0 ..< 2) {
                stepDown()
            } else {
                flatLine()
            }
        }

        highlightPath.removeLast()
        highlightPath.append(.addBezierCurve(
                                point: lastP,
                                cp1: lastP.modX(by: 0.001).modY(by: -hlMod),
                                cp2: lastP.modX(by: -0.001).modY(by: 0.001)))

        // Create water highlight
        let waterTopLeft = RelativePoint(x: horizontalOffset - 0.0075, y: verticalOffset - 0.005)
        let waterTopRight = RelativePoint(x: lastP.x + 0.015, y: verticalOffset - 0.005)
        let waterBottomRight = RelativePoint(x: lastP.x + 0.01, y: lastP.y + 0.005)
        let waterBottomLeft = RelativePoint(x: horizontalOffset, y: lastP.y + 0.005)

        let waterHighlightPath: [RelativePath] = [
            .moveTo(point: waterTopLeft),
            .addLine(point: waterTopRight),
            .addLine(point: waterBottomRight),
            .addLine(point: waterBottomLeft),
        ]

        // Create reflection
        let reflectionTopLeft = RelativePoint(x: horizontalOffset - 0.05, y: verticalOffset + 0.01)
        let reflectionTopRight = RelativePoint(x: lastP.x + 0.075, y: verticalOffset + 0.01)
        let reflectionBottomRight = RelativePoint(x: lastP.x + 0.025, y: lastP.y + 0.02)
        let reflectionBottomLeft = RelativePoint(x: horizontalOffset - 0.02, y: lastP.y + 0.02)

        let reflectionPath: [RelativePath] = [
            .moveTo(point: reflectionTopLeft),
            .addLine(point: reflectionTopRight),
            .addLine(point: reflectionBottomRight),
            .addLine(point: reflectionBottomLeft),
            .addLine(point: reflectionTopLeft)
        ]

        return RockSpec(main: PathSpec(path: mainPath),
                        highlight: PathSpec(path: highlightPath),
                        water: PathSpec(path: waterHighlightPath),
                        reflection: PathSpec(path: reflectionPath))
    }

    func generate() -> [RockSpec] {
        var rng = RNG(seed: seed)
        var x: CGFloat = -0.3
        var rocks = [RockSpec]()
        while x < 1.2 {
            x += rng.nextCGFloat(0.3 ..< 0.9)
            rocks.append(generateRock(withSeed: rng.next(), horizontalOffset: x))
        }
        return rocks
    }

}

struct RocksGenerator_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        let scene = Anderscene.generate(withSeed: 1)
        let config = Config(palette: palette, scene: scene)

        GeometryReader { g in
            Rocks(size: g.size)
                .environmentObject(config)
                .background(Color.green)
        }

    }
}
