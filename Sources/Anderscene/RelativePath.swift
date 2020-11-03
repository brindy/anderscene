
import SwiftUI

struct RelativePoint {

    let x: CGFloat
    let y: CGFloat

    static func • (left: RelativePoint, right: CGSize) -> CGPoint {
        return CGPoint(x: right.width * left.x, y: right.height * left.y)
    }

}

enum RelativePath {

    case moveTo(point: RelativePoint)

    case addCurve(point: RelativePoint,
                  cp1: RelativePoint,
                  cp2: RelativePoint)

    case addLine(point: RelativePoint)

}

struct PathSpec: Identifiable {

    let id = UUID.init().uuidString

    let path: [RelativePath]

}

struct RelativePathRenderer: View {

    let size: CGSize
    let path: [RelativePath]

    var body: some View {
        Path { path in
            for progress in self.path {

                switch progress {
                case .moveTo(let p):
                    path.move(to: p • size)

                case .addCurve(let p, let cp1, let cp2):
                    path.addCurve(to: p • size,
                                  control1: cp1 • size,
                                  control2: cp2 • size)

                case .addLine(let p):
                    path.addLine(to: p • size)

                }

            }
        }
    }

}
