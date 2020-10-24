
import SwiftUI

struct Anderscene {

    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        let sun = RNG(seed: rng.next())

        var clouds = [RNG]()
        for _ in 0 ..< rng.nextInt(1 ..< 3) {
            clouds.append(RNG(seed: rng.next()))
        }

        return Anderscene(
            sun: sun,
            clouds: clouds)
    }

    let sun: RNG
    let clouds: [RNG]

}
