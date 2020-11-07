
import Swift
import SwiftUI

struct Anderscene {
    
    /// When adding new elements they must be added after the existing ones so that the
    ///  rng remains consistent for a given seed.
    static func generate(withSeed seed: UInt64) -> Anderscene {
        var rng = RNG(seed: seed)

        let skyBall = SkyBallGenerator(seed: rng.next()).generatte()
        let clouds = CloudsGenerator(seed: rng.next()).generate()
        let haze = HazeGenerator(seed: rng.next()).generate()
        let peaks = PeaksGenerator(seed: rng.next()).generate()
        let hills = HillGenerator(seed: rng.next()).generate()
        let shore = ShoreGenerator(seed: rng.next()).generate()
        let water = WaterGenerator(seed: rng.next()).generate()
        let rocks = RocksGenerator(seed: rng.next()).generate()

        return Anderscene(
            skyBall: skyBall,
            clouds: clouds,
            haze: haze,
            peaks: peaks,
            hills: hills,
            shore: shore,
            water: water,
            rocks: rocks
        )
    }

    let skyBall: SkyBallSpec
    let clouds: [CloudSpec]
    let haze: PathSpec
    let peaks: PathSpec
    let hills: [HillSpec]
    let shore: ShoreSpec
    let water: WaterSpec
    let rocks: [RockSpec]

}
