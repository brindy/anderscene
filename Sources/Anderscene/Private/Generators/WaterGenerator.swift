
import SwiftUI

struct WaterGenerator {

    let seed: UInt64

    func generate() -> WaterSpec {

        let shoreHighlightOffset: CGFloat = 0.724
        let mainBodyOffset: CGFloat = shoreHighlightOffset + 0.004
        let mainHighlightOffset: CGFloat = 0.7425
        let mainHighlightHeight: CGFloat = 0.03

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

        // MARK: TODO add sparkles

        return WaterSpec(shoreHighlight: shoreHighlight,
                         mainBody: mainBody,
                         mainHighlight: mainHighlight)
    }


}
