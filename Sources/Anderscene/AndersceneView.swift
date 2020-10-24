
import SwiftUI

public struct AndersceneView: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                // Sun
                Sun(g: g)

                // Clouds
                ForEach(0 ..< config.scene.clouds.count, id: \.self) { index in
                    Cloud(index: index, g: g)
                }

                // Haze

                // 1 ..< 3 mountain layers

                // Near Ground

                // Water

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }.background(config.palette.c3)
    }
    
}

struct Cloud: View {

    @EnvironmentObject var config: Config

    let index: Int
    let g: GeometryProxy

    var body: some View {

        var rng = config.scene.clouds[index]
        let horizontal = rng.nextCGFloat(0.1 ..< 0.9)
        let vertical = rng.nextCGFloat(0.3 ..< 0.6)
        var x = (horizontal * g.size.width)
        var y = (vertical * g.size.height)

        Path { path in

            path.move(to: CGPoint(x: x, y: y))

            // Start
            path.addCurve(to: CGPoint(x: x, y: y - 10),
                          control1: CGPoint(x: x, y: y),
                          control2: CGPoint(x: x - 5, y: y))

            // Hump 1
            x += 70
            path.addCurve(to: CGPoint(x: x, y: y - 20),
                          control1: CGPoint(x: x - 50, y: y - 30),
                          control2: CGPoint(x: x - 40, y: y - 60))

            // Hump 2
            x += 30
            path.addCurve(to: CGPoint(x: x, y: y - 20),
                          control1: CGPoint(x: x - 20, y: y - 10),
                          control2: CGPoint(x: x, y: y - 20))

            x += 60
            path.addCurve(to: CGPoint(x: x, y: y - 10),
                          control1: CGPoint(x: x - 10, y: y - 40),
                          control2: CGPoint(x: x - 10, y: y - 20))

            // End
            path.addCurve(to: CGPoint(x: x - 10, y: y),
                          control1: CGPoint(x: x + 10, y: y - 0),
                          control2: CGPoint(x: x + 10, y: y - 0))

            path.closeSubpath()

        }
        // .stroke()
        .foregroundColor(config.palette.c2.opacity(0.5))
        // .foregroundColor(.red)

    }

}

struct Sun: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        var rng = config.scene.sun
        let size = rng.nextCGFloat(50 ..< 100)
        let horizontal = rng.nextCGFloat(0.1 ..< 0.9)
        let vertical = rng.nextCGFloat(0.3 ..< 0.6)
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

struct Anderscene_Previews: PreviewProvider {

    static var previews: some View {

        let config = Config(
            palette: .default,
            scene: Anderscene.generate(withSeed: 10))

        AndersceneView()
            .previewDevice("iPhone SE (2nd generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
