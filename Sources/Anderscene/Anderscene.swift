
import SwiftUI

struct Anderscene {

    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        return Anderscene(
            skyBall: RNG(seed: rng.next()),
            clouds: RNG(seed: rng.next()),
            haze: RNG(seed: rng.next()),
            peaks: RNG(seed: rng.next()),
            hills: RNG(seed: rng.next()),
            shore: RNG(seed: rng.next())
        )
    }

    let skyBall: RNG
    let clouds: RNG
    let haze: RNG
    let peaks: RNG
    let hills: RNG
    let shore: RNG

}
