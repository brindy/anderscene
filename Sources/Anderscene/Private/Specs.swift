
import SwiftUI

struct IslandSpec {

    let main: PathSpec
    let water: PathSpec
    let trees: [TreeSpec]
    let rock: RockSpec
    let reflection: PathSpec
    let tufts: [SparkleSpec]

}

struct RockSpec: Identifiable {

    let id = UUID().uuidString

    let main: PathSpec
    let water: PathSpec
    let reflection: PathSpec

}

struct SparkleSpec {

    let point: RelativePoint
    let size: CGFloat

}

struct WaterSpec {

    let shoreHighlight: [RelativePath]
    let mainBody: [RelativePath]
    let mainHighlight: [RelativePath]
    let bodySparkles: [SparkleSpec]
    let highlightSparkles: [SparkleSpec]

}

struct ShoreSpec {

    let pathSpec: PathSpec
    let trees: [TreeSpec]

}

struct SkyBallSpec {
    let point: RelativePoint
    let size: CGFloat
}

struct TreeSpec {
    let point: RelativePoint
    let height: CGFloat
    let shade: Int
}

struct HillSpec {
    let pathSpec: PathSpec
    let trees: [TreeSpec]
}

struct CloudSpec: Identifiable {

    let id = UUID().uuidString

    let pathSpec: PathSpec
    let opacity: Double

}
