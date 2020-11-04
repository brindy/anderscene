
import SwiftUI

struct SkyBall: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.skyBall
        let size = self.size.width * spec.size
        let position = spec.point • self.size

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

        }.position(x: position.x, y: position.y)

    }

}

struct Peaks: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        RelativePathRenderer(size: size, path: config.scene.peaks.path)
            .foregroundColor(config.palette.c6)
    }

}

struct Hills: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        let colors = [
            config.palette.c7,
            config.palette.c8
        ]

        ZStack {
            ForEach(0 ..< config.scene.hills.count, id: \.self) { index in

                let path = config.scene.hills[index].path

                RelativePathRenderer(size: size, path: path)
                    .foregroundColor(colors[index])

            }
        }
    }

}

struct Haze: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        RelativePathRenderer(size: size, path: config.scene.haze.path)
            .foregroundColor(config.palette.c2)
    }

}

struct Clouds: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        ZStack {

            ForEach(config.scene.clouds) { cloudSpec in

                RelativePathRenderer(size: size, path: cloudSpec.path)
                    .foregroundColor(config.palette.c2.opacity(0.5))

            }

        }
    }

}

struct Shore: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        RelativePathRenderer(size: size, path: config.scene.shore.path)
            .foregroundColor(config.palette.c9)
    }
}

public struct AndersceneView: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                SkyBall(size: g.size)

                Clouds(size: g.size)

                Haze(size: g.size)

                Peaks(size: g.size)

                Hills(size: g.size)

                Shore(size: g.size)

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
            scene: Anderscene.generate(withSeed: 22222222))

        AndersceneView()
            .previewDevice("iPhone SE (2nd generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

//        AndersceneView()
//            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//            .edgesIgnoringSafeArea(.all)
//            .environmentObject(config)

    }

}
