
import SwiftUI

infix operator • : MultiplicationPrecedence
struct RelativePoint {

    let x: CGFloat
    let y: CGFloat

    var debugDescription: String {
        return "[\(x), \(y)]"
    }

    static func • (left: RelativePoint, right: CGSize) -> CGPoint {
        return CGPoint(x: right.width * left.x, y: right.height * left.y)
    }

    static func + (left: RelativePoint, right: RelativePoint) -> RelativePoint {
        return RelativePoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func + (left: RelativePoint, right: CGFloat) -> RelativePoint {
        return RelativePoint(x: left.x + right, y: left.y + right)
    }

    static func * (left: RelativePoint, right: CGFloat) -> RelativePoint {
        return RelativePoint(x: left.x * right, y: left.y * right)
    }

    static func - (left: RelativePoint, right: RelativePoint) -> RelativePoint {
        return RelativePoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func - (left: RelativePoint, right: CGFloat) -> RelativePoint {
        return RelativePoint(x: left.x - right, y: left.y - right)
    }

    static func / (left: RelativePoint, right: CGFloat) -> RelativePoint {
        return RelativePoint(x: left.x / right, y: left.y / right)
    }

    func modY(by: CGFloat) -> RelativePoint {
        return RelativePoint(x: x, y: y + by)
    }

    func modX(by: CGFloat) -> RelativePoint {
        return RelativePoint(x: x + by, y: y)
    }

    func distance(to p2: RelativePoint) -> CGFloat {
        let xDiff = p2.x - x
        let yDiff = p2.y - y
        let result = sqrt(xDiff * xDiff + yDiff * yDiff)
        NSLog("*** distance ".appendingFormat("%f %f %f", xDiff, yDiff, result))
        return result
    }

    func mag() -> CGFloat {
        return sqrt((x * x) + (y * y))
    }

    func unit() -> RelativePoint {
        return self / mag()
    }

    func rotate90() -> RelativePoint {
        return RelativePoint(x: y, y: -x)
    }

}

enum RelativePath {

    case moveTo(point: RelativePoint)

    case addBezierCurve(point: RelativePoint,
                        cp1: RelativePoint,
                        cp2: RelativePoint)

    case addLine(point: RelativePoint)

    case addQuadraticCurve(point: RelativePoint,
                           cp: RelativePoint)

}

struct PathSpec: Identifiable {

    let id = UUID.init().uuidString

    let path: [RelativePath]

}

struct FilledPath: View {

    let size: CGSize
    let path: [RelativePath]

    var body: some View {
        Path { path in

            self.path.applyTo(path: &path, withSize: size)

        }
    }
}

struct StrokedPath: View {

    let size: CGSize
    let path: [RelativePath]
    var lineWidth: CGFloat

    var body: some View {
        Path { path in

            self.path.applyTo(path: &path, withSize: size)

        }.stroke(lineWidth: lineWidth)
    }
}

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
