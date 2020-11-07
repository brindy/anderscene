
import SwiftUI

struct SkyBall: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.skyBall
        let size = self.size.width * spec.size

        ZStack {
            Circle()
                .foregroundColor(config.palette.skyBallHalo)
                .frame(width: size,
                       height: size,
                       alignment: .center)

            Circle()
                .foregroundColor(config.palette.skyBallForeground)
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
        FilledPath(size: size, path: config.scene.peaks.path)
            .foregroundColor(config.palette.peaks)
    }

}

struct Tree: View {

    @EnvironmentObject var config: Config

    let size: CGSize
    let spec: Anderscene.TreeSpec

    var body: some View {

        let position = spec.point • size
        let width = size.width * (spec.height / 2.5)
        let height = size.height * spec.height
        let left = CGPoint(x: position.x - width, y: position.y)
        let right = CGPoint(x: position.x + width, y: position.y)
        let top = CGPoint(x: position.x, y: position.y - height)

        ZStack {
            Path { p in

                p.move(to: left)
                p.addLine(to: right)
                p.addLine(to: CGPoint(x: top.x + 1, y: top.y + 5))
                p.addQuadCurve(to: CGPoint(x: top.x - 1, y: top.y + 5), control: top)
                p.addLine(to: CGPoint(x: top.x - 1, y: top.y + 5))

            }

        }
    }

}

struct Hills: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        let hillColors = [
            config.palette.hillFar,
            config.palette.hillNear,
        ]

        let treeColors = [
            config.palette.tree1,
            config.palette.tree2,
            config.palette.tree3,
            config.palette.tree4,
            config.palette.tree5,
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

                FilledPath(size: size, path: path)
                    .foregroundColor(hillColors[index])

            }
        }
    }

}

struct Haze: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        FilledPath(size: size, path: config.scene.haze.path)
            .foregroundColor(config.palette.haze)
    }

}

struct Clouds: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {
        ZStack {

            ForEach(config.scene.clouds) { cloudSpec in

                FilledPath(size: size, path: cloudSpec.pathSpec.path)
                    .foregroundColor(config.palette.clouds.opacity(cloudSpec.opacity))

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
            config.palette.tree4,
            config.palette.tree4,
            config.palette.tree4,
            config.palette.tree5
        ]

        ZStack {

            ForEach(0 ..< spec.trees.count, id: \.self) { treeIndex in
                let tree = spec.trees[treeIndex]
                Tree(size: size, spec: tree)
                    .foregroundColor(treeColors[tree.shade])
            }

            FilledPath(size: size, path: spec.pathSpec.path)
                .foregroundColor(config.palette.shore)

        }

    }
}

struct Water: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.water

        ZStack {

            FilledPath(size: size, path: spec.shoreHighlight)
                .foregroundColor(config.palette.waterShoreHighlight)
            FilledPath(size: size, path: spec.mainBody)
                .foregroundColor(config.palette.waterDark)
            FilledPath(size: size, path: spec.mainHighlight)
                .foregroundColor(config.palette.waterHighlight)

        }
    }
}

struct Rocks: View {

    @EnvironmentObject var config: Config

    let size: CGSize

    var body: some View {

        let spec = config.scene.rocks

        ZStack {

            ForEach(spec) { rockSpec in

                let main = rockSpec.mainPathSpec
                let highlight = rockSpec.highlightPathSpec
                let reflection = rockSpec.reflectionPathSpec


                FilledPath(size: size,
                           path: highlight.path)
                           // , lineWidth: 3)
                    .foregroundColor(config.palette.rockHighlight)

                FilledPath(size: size,
                           path: main.path)
                    .foregroundColor(config.palette.rock)
                     //.foregroundColor(.red)

                FilledPath(size: size,
                           path: reflection.path)
                           //, lineWidth: 3)
                    .foregroundColor(config.palette.waterDark)
                    //.foregroundColor(.purple)

            }

        }

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

                Rocks(size: g.size)

                // Island

                // Foreground Hill

                // Foreground Rocks

                // Foreground Embankment (w/flowers)

                // Foreground Sillhouette (w/flowers+plants)

            }
        }
        .background(config.palette.sky)

    }
    
}

struct AndersceneView_Previews: PreviewProvider {


    static var previews: some View {
        let device = "iPhone SE (2nd generation)"
        // let device = "iPad Pro (12.9-inch) (4th generation)"

        let config = Config(
            palette: .default,
            scene: Anderscene.generate(withSeed: 1))

        AndersceneView()
            .previewDevice(.init(rawValue: device))
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
