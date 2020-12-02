
import SwiftUI

struct WaterGenerator {

    let seed: UInt64

    func generate() -> WaterSpec {

        let shoreHighlightOffset: CGFloat = 0.724
        let mainBodyOffset: CGFloat = shoreHighlightOffset + 0.004
        let mainHighlightOffset: CGFloat = 0.7425
        let mainHighlightHeight: CGFloat = 0.05

        let shoreHighlight: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: shoreHighlightOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: shoreHighlightOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 0, y: mainBodyOffset))
        ]

        let mainBody: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: mainBodyOffset)),
            .addLine(point: RelativePoint(x: 1.0, y: 1.0)),
            .addLine(point: RelativePoint(x: 0, y: 1.0))
        ]

        var mainHighlight: [RelativePath] = [
            .moveTo(point: RelativePoint(x: 0, y: mainHighlightOffset)),
            .addLine(point: RelativePoint(x: 0, y: mainHighlightOffset + mainHighlightHeight)),
        ]

        var rng = RNG(seed: seed)
        var x = rng.nextCGFloat(-0.5 ..< 0)
        while x < 1.1 {

            let distance = rng.nextCGFloat(0.3 ..< 0.5)
            let height = rng.nextCGFloat(0.01 ..< 0.015)
            x += distance

            let p = RelativePoint(x: x, y: mainHighlightOffset + mainHighlightHeight)

            mainHighlight.append(
                .addBezierCurve(point: p,
                                cp1: p.modY(by: -height).modX(by: -distance + distance / 2),
                                cp2: p.modY(by: height).modX(by: -distance / 2))
            )

        }

        mainHighlight.append(.addLine(point: RelativePoint(x: x, y: mainHighlightOffset)))

        let sparkleSize = CGFloat(0.01) ..< CGFloat(0.02)

        var sparkleY: CGFloat = mainBodyOffset
        var bodySparkles = [SparkleSpec]()

        let maxSparkles = rng.nextInt(10 ..< 30)
        for _ in 0 ..< maxSparkles {
            let x = rng.nextCGFloat(0 ..< 1)
            sparkleY = rng.nextCGFloat(sparkleY ..< sparkleY + 0.01)

            let point = RelativePoint(x: x, y: sparkleY)
            let sparkle = SparkleSpec(point: point,
                                      size: rng.nextCGFloat(sparkleSize))

            sparkleY += 0.01
            bodySparkles.append(sparkle)
        }

        var highlightSparkles = [SparkleSpec]()
        let maxHighlightSparkles = rng.nextInt(3 ..< 10)
        for _ in 0 ..< maxHighlightSparkles {
            let x = rng.nextCGFloat(0 ..< 1)

            let y = (mainHighlightOffset + mainHighlightHeight / 2)
                + rng.nextCGFloat(-0.02 ..< 0.02)

            let point = RelativePoint(x: x, y: y)
            let sparkle = SparkleSpec(point: point,
                                      size: rng.nextCGFloat(sparkleSize))

            highlightSparkles.append(sparkle)
        }

        return WaterSpec(shoreHighlight: shoreHighlight,
                         mainBody: mainBody,
                         mainHighlight: mainHighlight,
                         bodySparkles: bodySparkles,
                         highlightSparkles: highlightSparkles)
    }


}

struct WaterGenerator_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        let scene = Anderscene.generate(withSeed: 1)
        let config = Config(palette: palette, scene: scene)

        GeometryReader { g in
            Water(size: g.size)
                .environmentObject(config)
        }

    }
}
