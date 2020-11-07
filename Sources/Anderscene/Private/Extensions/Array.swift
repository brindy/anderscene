
import SwiftUI

extension Array where Element == RelativePath {

    func applyTo(path: inout Path, withSize size: CGSize) {
        for progress in self {

            switch progress {
            case .moveTo(let p):
                path.move(to: p • size)

            case .addBezierCurve(let p, let cp1, let cp2):
                path.addCurve(to: p • size,
                              control1: cp1 • size,
                              control2: cp2 • size)

            case .addLine(let p):
                path.addLine(to: p • size)

            case .addQuadraticCurve(let p, let cp):
                path.addQuadCurve(to: p • size, control: cp • size)

            }

        }
    }

}
