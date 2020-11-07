
import SwiftUI

struct HazeGenerator {

    let seed: UInt64

    func generate() -> PathSpec {
        return GentleHorizonGenerator(seed: seed).generate(
            verticalOffset: 0.45,
            heightRange: -0.02 ..< 0.02)
    }

}
