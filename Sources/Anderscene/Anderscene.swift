
import SwiftUI

struct Anderscene {

    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        let sun = RNG(seed: rng.next())
        let clouds = RNG(seed: rng.next())
        let mountains = RNG(seed: rng.next())

        return Anderscene(
            sun: sun,
            clouds: clouds,
            mountains: mountains)
    }

    let sun: RNG
    let clouds: RNG
    let mountains: RNG

}
