
import GameplayKit

// Modified from https://stackoverflow.com/a/54849689/73479
struct RNG: RandomNumberGenerator {
    
    let seed: UInt64
    private let generator: GKMersenneTwisterRandomSource

    init(seed: UInt64) {
        self.seed = seed
        generator = GKMersenneTwisterRandomSource(seed: seed)
    }

    mutating func next() -> UInt64 {
         // GKRandom produces values in [INT32_MIN, INT32_MAX] range; hence we need two numbers to produce 64-bit value.
         let next1 = UInt64(bitPattern: Int64(generator.nextInt()))
         let next2 = UInt64(bitPattern: Int64(generator.nextInt()))
         return next1 ^ (next2 << 32)
     }

    mutating func nextInt(_ range: Range<Int>) -> Int {
        return Int.random(in: range, using: &self)
    }

    mutating func nextCGFloat(_ range: Range<CGFloat>) -> CGFloat {
        return CGFloat.random(in: range, using: &self)
    }

}
