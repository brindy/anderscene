
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

    // Based on https://b3d.interplanety.org/en/creating-points-on-a-bezier-curve/
    static func atDistanceOnBezierCurve(distance t: CGFloat,
                                            p0: RelativePoint,
                                            p0hr: RelativePoint,
                                            p1: RelativePoint,
                                            p1hl: RelativePoint) -> RelativePoint {

        let t1 = p0 + (p0hr - p0) * t
        let t2 = p0hr + (p1hl - p0hr) * t
        let t3 = p1hl + (p1 - p1hl) * t
        let p2hl = t1 + (t2 - t1) * t
        let p2hr = t2 + (t3 - t2) * t
        let p2 = p2hl + (p2hr - p2hl) * t

        return p2
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

        }
        .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                   lineCap: .round))

    }
}
