import SwiftUI

struct Clouds: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        var rng = config.scene.clouds

        ZStack {
            ForEach(0 ..< rng.nextInt(1 ..< 3), id: \.self) { _ in
               Cloud(g: g)
            }
        }

    }

}

struct Cloud: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    private func addHump(_ path: inout Path, rng: inout RNG, x: CGFloat, y: CGFloat) -> CGFloat {
        let distance: CGFloat = rng.nextCGFloat(40 ..< 100)
        path.addCurve(to: CGPoint(x: x + distance, y: y - 20),
                      control1: CGPoint(x: x + distance / 2, y: y - 40),
                      control2: CGPoint(x: x + distance / 2, y: y - 40))
        return distance
    }

    private func addSpacer(_ path: inout Path, rng: inout RNG, x: CGFloat, y: CGFloat) -> CGFloat {
        let distance: CGFloat = rng.nextCGFloat(30 ..< 60)
        path.addCurve(to: CGPoint(x: x + distance, y: y - 20),
                      control1: CGPoint(x: x + distance / 2, y: y - 10),
                      control2: CGPoint(x: x + distance, y: y - 20))
        return distance
    }

    var body: some View {

        var rng = config.scene.clouds
        let horizontal = rng.nextCGFloat(0.1 ..< 0.9)
        let vertical = rng.nextCGFloat(0.3 ..< 0.6)
        var x = (horizontal * g.size.width)
        let y = (vertical * g.size.height)

        Path { path in

            path.move(to: CGPoint(x: x, y: y))

            // Start
            path.addCurve(to: CGPoint(x: x, y: y - 10),
                          control1: CGPoint(x: x, y: y),
                          control2: CGPoint(x: x - 10, y: y))

            x += addHump(&path, rng: &rng, x: x, y: y)

            // Good chance of second hump
            if rng.nextInt(0 ..< 1) == 0 {
                x += addSpacer(&path, rng: &rng, x: x, y: y)
                x += addHump(&path, rng: &rng, x: x, y: y)
            }

            // Smaller chance of third hump
            if rng.nextInt(0 ..< 5) == 0 {
                x += addSpacer(&path, rng: &rng, x: x, y: y)
                x += addHump(&path, rng: &rng, x: x, y: y)
            }

            // End
            path.addCurve(to: CGPoint(x: x - 10, y: y),
                          control1: CGPoint(x: x + 10, y: y),
                          control2: CGPoint(x: x - 10, y: y))

            path.closeSubpath()

        }
        .scale(rng.nextCGFloat(0.5 ..< 1.0))
        .foregroundColor(config.palette.c2.opacity(0.5))

    }

}
