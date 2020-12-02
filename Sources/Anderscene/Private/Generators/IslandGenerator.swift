
import SwiftUI

struct IslandGenerator {

    let seed: UInt64

    func generate() -> IslandSpec {

        var rng = RNG(seed: seed)

        let width1 = rng.nextCGFloat(0.1 ..< 0.3)
        let width2 = rng.nextCGFloat(0.1 ..< 0.3)

        let maxHorizontal = 1.0 - width1 - width2
        let horizontalOffset: CGFloat = rng.nextCGFloat(0.1 ..< maxHorizontal)
        let verticalOffset: CGFloat = 0.85

        let islandHeight = rng.nextCGFloat(0.03 ..< 0.06)

        let p1 = RelativePoint(x: horizontalOffset, y: verticalOffset)
        let p2 = p1.modX(by: width1).modY(by: -islandHeight)
        let p2cp1 = p2.modX(by: -0.05)
        let p2cp2 = p2.modX(by: -0.05).modY(by: 0.05)
        let p3 = p2.modX(by: width2).modY(by: islandHeight)
        let p3cp1 = p2.modX(by: 0.05).modY(by: -0.05)

        let mainPath: [RelativePath] = [
            .moveTo(point: p1),
            .addBezierCurve(point: p2, cp1: p2cp1, cp2: p2cp2),
            .addBezierCurve(point: p3, cp1: p3cp1, cp2: p3),
        ]

        let rockOffset = horizontalOffset + rng.nextCGFloat(0.01 ..< 0.02)
        let rockSpec = RocksGenerator(seed: seed).generateRock(withSeed: seed, horizontalOffset: rockOffset, verticalOffset: verticalOffset + 0.005)

        let waterPath: [RelativePath] = [
            .moveTo(point: p1),
            .addLine(point: p3),
        ]

        let reflectionPath: [RelativePath] = [
            .moveTo(point: p1.modX(by: -0.005)),
            .addBezierCurve(point: p3.modX(by: 0.005),
                            cp1: p1.modY(by: islandHeight),
                            cp2: p3.modY(by: islandHeight)),
        ]

        let treeStart = p1.modX(by: 0.01)
        let treeEnd = p3.modX(by: -0.01)
        let treeGen = TreeGenerator(seed: rng.next())
        let trees = treeGen.generate(p1: treeStart,
                                     p2: treeEnd,
                                     cp1: treeStart,
                                     cp2: treeEnd, heightRangeMultiplier: 0.9, yOffset: 0.0)

        let tufts =
            createTufts(p1, p2, p2cp1, p2cp2, &rng, verticalOffset)
            +
            createTufts(p2, p3, p3cp1, p3, &rng, verticalOffset)

        return IslandSpec(main: PathSpec(path: mainPath),
                          water: PathSpec(path: waterPath),
                          trees: trees,
                          rock: rockSpec,
                          reflection: PathSpec(path: reflectionPath),
                          tufts: tufts)
    }

    func createTufts(_ p1: RelativePoint,
                     _ p2: RelativePoint,
                     _ cp1: RelativePoint,
                     _ cp2: RelativePoint,
                     _ rng: inout RNG,
                     _ verticalOffset: CGFloat) -> [SparkleSpec] {


        let maxTufts = abs(Int((p1.x - p2.x) / 0.03))
        NSLog("maxTufts %d", maxTufts)

        var distance: CGFloat = rng.nextCGFloat(0 ..< 1)
        var tufts = [SparkleSpec]()
        while distance < 1.0 {
            NSLog("distance %f %d", distance, maxTufts)

            let px = RelativePoint.atDistanceOnBezierCurve(distance: distance, p0: p1, p0hr: cp1, p1: p2, p1hl: cp2)

            NSLog("%f %f", verticalOffset, px.y)

            let y: CGFloat = rng.nextCGFloat(px.y ..< verticalOffset)
            let p = RelativePoint(x: px.x, y: y)

            tufts.append(SparkleSpec(point: p, size: rng.nextCGFloat(0.002 ..< 0.003)))

            distance += rng.nextCGFloat(0.1 ..< 0.2)
        }

        return tufts
    }

}

struct IslandGenerator_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        let scene = Anderscene.generate(withSeed: 1111111111)
        let config = Config(palette: palette, scene: scene)

        GeometryReader { g in
            Island(size: g.size)
                .environmentObject(config)
                .background(palette.waterDark)
        }

    }
}
