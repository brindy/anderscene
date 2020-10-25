
import SwiftUI

public struct AndersceneView: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                // Sun
                SkyBall(g: g)

                // Clouds
                Clouds(g: g)

                // Haze

                // Mountains
                Mountains(g: g)

                // Near Ground

                // Water

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }.background(config.palette.c4)
    }
    
}

struct Mountains: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        let colors = [
            config.palette.c2,
            config.palette.c6,
            config.palette.c7,
            config.palette.c8,
            config.palette.c9
        ]

        var rng = config.scene.mountains

        ZStack {
            ForEach(0 ..< rng.nextInt(2 ..< 5), id: \.self) { index in
                Mountain(g: g,
                         index: index,
                         maxPeak: 100 - (CGFloat(index) * 10))
                    .foregroundColor(colors[index])
            }

            Mountain(g: g, index: 4, maxPeak: 30)
                .foregroundColor(colors[4])
        }

    }

}

struct Mountain: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy
    let index: Int
    let maxPeak: CGFloat

    var body: some View {
        var rng = config.scene.mountains
        var x = rng.nextCGFloat(-100 ..< 0)
        let y = (0.5 + (CGFloat(index) / 10 / 2)) * g.size.height

        ZStack {
            Path { p in
                p.move(to: CGPoint(x: x, y: g.size.height))
                p.addLine(to: CGPoint(x: x, y: y))

//                while x < g.size.width {
//                    x += rng.nextCGFloat(20 ..< 100)
//                    p.addLine(to: CGPoint(x: x, y: y - rng.nextCGFloat(10 ..< maxPeak)))
//                    x += rng.nextCGFloat(20 ..< 100)
//                    p.addLine(to: CGPoint(x: x, y: y - 10))
//                }

                p.addLine(to: CGPoint(x: g.size.width, y: y))
                p.addLine(to: CGPoint(x: g.size.width, y: g.size.height))
                p.closeSubpath()
            }

            // if index >= 2 then show trees

        }
    }

}

struct Anderscene_Previews: PreviewProvider {

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
