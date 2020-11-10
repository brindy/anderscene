
import SwiftUI

struct RocksGenerator {

    let seed: UInt64

    func generateRock(withSeed seed: UInt64, horizontalOffset: CGFloat, verticalOffset: CGFloat) -> RockSpec {

        let cpMod: CGFloat = 0.01

        var rng = RNG(seed: seed)
        var lastP = RelativePoint(x: horizontalOffset + 0.01, y: verticalOffset)
        var maxY: CGFloat = 0.0

        var mainPath = [RelativePath]()

        mainPath.append(.moveTo(point: lastP))

        func stepUp() {
            let height: CGFloat = 0.01
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y - height)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP, cp2: nextP.modX(by: -cpMod)))
            lastP = nextP
            maxY += height
        }

        func flatLine() {
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP, cp2: nextP))
            lastP = nextP
        }

        func stepDown() {
            let width = rng.nextCGFloat(0.01 ..< 0.03)
            let nextP = RelativePoint(x: lastP.x + width, y: lastP.y + 0.01)
            mainPath.append(.addBezierCurve(point: nextP, cp1: lastP.modX(by: cpMod), cp2: nextP.modX(by: -cpMod)))
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

        // Create water highlight
        let waterRight = RelativePoint(x: lastP.x + 0.01, y: lastP.y + 0.001)
        let waterLeft = RelativePoint(x: horizontalOffset - 0.0, y: lastP.y + 0.001)

        let waterHighlightPath: [RelativePath] = [
            .moveTo(point: waterLeft),
            .addLine(point: waterRight),
        ]

        maxY = max(0.02, maxY * 0.75)
        let reflectionP1 = RelativePoint(x: horizontalOffset - 0.04, y: lastP.y + 0.003)
        let reflectionP2 = RelativePoint(x: lastP.x + 0.04, y: lastP.y + 0.003)
        let reflectionPath: [RelativePath] = [
            .moveTo(point: reflectionP1),
            .addBezierCurve(point: reflectionP2,
                            cp1: reflectionP1.modY(by: maxY * 1.5),
                            cp2: reflectionP2.modY(by: maxY * 1.5)),
        ]

        return RockSpec(main: PathSpec(path: mainPath),
                        water: PathSpec(path: waterHighlightPath),
                        reflection: PathSpec(path: reflectionPath))
    }

    func generate() -> [RockSpec] {
        var rng = RNG(seed: seed)
        var x: CGFloat = -0.3
        var rocks = [RockSpec]()
        while x < 1.2 {
            x += rng.nextCGFloat(0.3 ..< 0.9)
            rocks.append(generateRock(withSeed: rng.next(), horizontalOffset: x, verticalOffset: 0.729))
        }
        return rocks
    }

}

struct RocksGenerator_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        let scene = Anderscene.generate(withSeed: 11)
        let config = Config(palette: palette, scene: scene)

        GeometryReader { g in
            Rocks(size: g.size)
                .environmentObject(config)
                .background(Color.red)
        }

    }
}
