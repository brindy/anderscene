
import SwiftUI

struct RelativePathRenderer: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy
    let path: [Anderscene.RelativePath]

    var body: some View {
        Path { path in
            for progress in self.path {

                switch progress {
                case .moveTo(let p):
                    path.move(to: p • g.size)

                case .addCurve(let p, let cp1, let cp2):
                    path.addCurve(to: p • g.size,
                                  control1: cp1 • g.size,
                                  control2: cp2 • g.size)

                case .addLine(let p):
                    path.addLine(to: p • g.size)

                }

            }
        }
    }

}

struct SkyBall: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        var rng = config.scene.skyBall
        let minSize = g.size.width / 10
        let maxSize = g.size.width / 5
        let size = rng.nextCGFloat(minSize ..< maxSize)
        let horizontal = rng.nextCGFloat(0.1 ..< 0.9)
        let vertical = rng.nextCGFloat(0.1 ..< 0.3)
        let x = (horizontal * g.size.width)
        let y = (vertical * g.size.height)

        ZStack {
            Circle()
                .foregroundColor(config.palette.c2)
                .frame(width: size,
                       height: size,
                       alignment: .center)

            Circle()
                .foregroundColor(config.palette.c1)
                .frame(width: size * 0.8,
                       height: size * 0.8,
                       alignment: .center)

        }.position(x: x, y: y)

    }

}

struct Peaks: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {
        var rng = config.scene.peaks
        let y = g.size.height * 0.5
        let maxDistance = g.size.width / 5
        let maxHeight = g.size.width / 10

        Path { path in
            var x: CGFloat = rng.nextCGFloat(-100 ..< 0)
            path.move(to: CGPoint(x: x, y: y))

            while x < g.size.width {
                let heightMod = rng.nextCGFloat(-maxHeight ..< maxHeight)
                path.addLine(to: CGPoint(x: x + (maxDistance / 2), y: y - heightMod))
                path.addLine(to: CGPoint(x: x + maxDistance, y: y))
                x += maxDistance
            }

            path.addLine(to: CGPoint(x: g.size.width, y: y))

            path.addLine(to: CGPoint(x: g.size.width, y: g.size.height))
            path.addLine(to: CGPoint(x: 0, y: g.size.height))

            path.closeSubpath()

        }
        .foregroundColor(config.palette.c6)
    }

}

struct Hills: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {
        let colors = [
            config.palette.c7,
            config.palette.c8
        ]

        ZStack {
            ForEach(0 ..< 2, id: \.self) { index in

                Hill(g: g, verticalPosition: 0.6 + CGFloat(index) / CGFloat(10))
                    .foregroundColor(colors[index])

            }
        }
    }

}

struct Hill: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy
    let verticalPosition: CGFloat

    var body: some View {
        var rng = config.scene.hills
        let maxHumpSize = g.size.width / 4
        var x: CGFloat = rng.nextCGFloat(-100 ..< 0)
        var y = verticalPosition * g.size.height
        let maxY = g.size.width / 20

        Path { path in

            func addHump() {

                let distance: CGFloat = maxHumpSize
                let height: CGFloat = g.size.width / 30
                path.addCurve(to: CGPoint(x: x + distance, y: y - height),
                              control1: CGPoint(x: x + distance / 2, y: y - height * 2),
                              control2: CGPoint(x: x + distance / 2, y: y - height * 2))

                x += distance
            }

            path.move(to: CGPoint(x: x, y: y))

            addHump()

            while x < g.size.width {
                let height = rng.nextCGFloat(-maxY ..< maxY)
                y += height
                addHump()
                y -= height
            }

            path.addLine(to: CGPoint(x: g.size.width, y: y))
            path.addLine(to: CGPoint(x: g.size.width, y: g.size.height))
            path.addLine(to: CGPoint(x: 0, y: g.size.height))

            path.closeSubpath()
        }
    }

}

struct Haze: View {

    @EnvironmentObject var config: Config

    var g: GeometryProxy

    var body: some View {

        var rng = config.scene.haze
        let y = g.size.height * 0.4
        let maxDistance = g.size.width / 5

        Path { path in
            var x: CGFloat = 0
            path.move(to: CGPoint(x: x, y: y))

            while x < g.size.width {
                x += maxDistance
                let heightMod = rng.nextCGFloat(-20 ..< 20)
                path.addLine(to: CGPoint(x: x, y: y + heightMod))
            }

             path.addLine(to: CGPoint(x: g.size.width, y: y))

            path.addLine(to: CGPoint(x: g.size.width, y: g.size.height))
            path.addLine(to: CGPoint(x: 0, y: g.size.height))

            path.closeSubpath()

        }.foregroundColor(config.palette.c2)

    }

}

struct Clouds: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        ZStack {

            ForEach(config.scene.clouds) { cloudSpec in

                RelativePathRenderer(g: g, path: cloudSpec.path)
                    .foregroundColor(config.palette.c2.opacity(0.5))

            }

        }

    }

}

struct Shore: View {

    @EnvironmentObject var config: Config

    var g: GeometryProxy

    var body: some View {

        var rng = config.scene.shore
        let y = g.size.height * 0.75
        let maxDistance = g.size.width / 5

        Path { path in
            var x: CGFloat = 0
            path.move(to: CGPoint(x: x, y: y))

            while x < g.size.width {
                x += maxDistance
                let heightMod = rng.nextCGFloat(-20 ..< 20)
                path.addLine(to: CGPoint(x: x, y: y + heightMod))
            }

             path.addLine(to: CGPoint(x: g.size.width, y: y))

            path.addLine(to: CGPoint(x: g.size.width, y: g.size.height))
            path.addLine(to: CGPoint(x: 0, y: g.size.height))

            path.closeSubpath()

        }.foregroundColor(config.palette.c9)

    }

}

public struct AndersceneView: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                SkyBall(g: g)

                Clouds(g: g)

//                Haze(g: g)

//                Peaks(g: g)

//                Hills(g: g)

//                Shore(g: g)

                // Water

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }
        .background(config.palette.c4)

    }
    
}

struct AndersceneView_Previews: PreviewProvider {

    static var previews: some View {

        let config = Config(
            palette: .default,
            scene: Anderscene.generate(withSeed: 1))

        AndersceneView()
            .previewDevice("iPhone SE (2nd generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

        AndersceneView()
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
