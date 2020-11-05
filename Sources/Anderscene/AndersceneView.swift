
import SwiftUI

struct SkyBall: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.skyBall
        let size = self.size.width * spec.size

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

        }.position(spec.point • self.size)

    }

}

struct Peaks: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        RelativePathRenderer(size: size, path: config.scene.peaks.path)
            .foregroundColor(config.palette.c7)
    }

}

struct Tree: View {

    @EnvironmentObject var config: Config

    let size: CGSize
    let spec: Anderscene.TreeSpec

    var body: some View {

        let position = spec.point • size
        let width = size.width * (spec.height / 2)
        let height = size.height * spec.height
        let left = CGPoint(x: position.x - width, y: position.y)
        let right = CGPoint(x: position.x + width, y: position.y)
        let top = CGPoint(x: position.x, y: position.y - height)

        ZStack {
            Path { p in

                p.move(to: left)
                p.addLine(to: right)
                p.addLine(to: top)

            }

        }
    }

}

struct Hills: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        let hillColors = [
            config.palette.c8,
            config.palette.c9
        ]

        let treeColors = [
            config.palette.c8,
            config.palette.c9,
            config.palette.c10,
            config.palette.c11,
            config.palette.c12
        ]

        ZStack {

            ForEach(0 ..< config.scene.hills.count, id: \.self) { index in
                let hill = config.scene.hills[index]
                let path = hill.pathSpec.path

                ForEach(0 ..< hill.trees.count, id: \.self) { treeIndex in
                    let tree = hill.trees[treeIndex]
                    Tree(size: size, spec: tree)
                        .foregroundColor(treeColors[tree.shade + index])
                        .foregroundColor(.red)
                }

                RelativePathRenderer(size: size, path: path)
                    .foregroundColor(hillColors[index])

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

                RelativePathRenderer(size: size, path: cloudSpec.pathSpec.path)
                    .foregroundColor(config.palette.c2.opacity(cloudSpec.opacity))

            }

        }
    }

}

struct Shore: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.shore
        let treeColors = [
            config.palette.c11,
            config.palette.c11,
            config.palette.c11,
            config.palette.c12
        ]

        ZStack {

            ForEach(0 ..< spec.trees.count, id: \.self) { treeIndex in
                let tree = spec.trees[treeIndex]
                Tree(size: size, spec: tree)
                    .foregroundColor(treeColors[tree.shade])
            }

            RelativePathRenderer(size: size, path: spec.pathSpec.path)
                .foregroundColor(config.palette.c10)

        }

    }
}

struct Water: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        ZStack {

            Rectangle()
                .foregroundColor(config.palette.c2)
                .frame(width: size.width, height: size.height, alignment: .center)
                .position(x: size.width / 2, y: size.height * 0.75)

            Rectangle()
                .foregroundColor(config.palette.c5)
                .frame(width: size.width, height: size.height, alignment: .center)
                .position(x: size.width / 2, y: size.height * 0.76)

        }.position(x: size.width / 2, y: size.height)
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

                Water(size: g.size)

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }
        .background(config.palette.c4)

    }
    
}

struct AndersceneView_Previews: PreviewProvider {


    static var previews: some View {
        let device = "iPhone SE (2nd generation)"
        // let device = "iPad Pro (12.9-inch) (4th generation)"

        let config = Config(
            palette: .default,
            scene: Anderscene.generate(withSeed: 23456))

        AndersceneView()
            .previewDevice(.init(rawValue: device))
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
