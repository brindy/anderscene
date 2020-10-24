
import SwiftUI

public struct Anderscene: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                // Sun
                Sun(maxOffset: g.size.width)

                // Clouds

                // Haze

                // 1 ..< 3 mountain layers

                // Near Ground

                // Water

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }.background(config.palette.c3)
    }
    
}

class Config: ObservableObject {

    @Published var rng: RNG
    @Published var palette: Palette

    init(rng: RNG, palette: Palette) {
        self.rng = rng
        self.palette = palette
    }

}

struct Anderscene_Previews: PreviewProvider {

    static var previews: some View {

        let config = Config(rng: RNG(seed: 11),
                            palette: .default)

        Anderscene()
            .previewDevice("iPhone SE (2nd generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
