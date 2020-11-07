
import SwiftUI

struct RockSpec: Identifiable {

    let id = UUID().uuidString

    let main: PathSpec
    let highlight: PathSpec
    let water: PathSpec
    let reflection: PathSpec

}

struct WaterSpec {

    let shoreHighlight: [RelativePath]
    let mainBody: [RelativePath]
    let mainHighlight: [RelativePath]

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
