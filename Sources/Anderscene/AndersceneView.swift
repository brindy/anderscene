
import SwiftUI

public struct AndersceneView: View {

    @EnvironmentObject var config: Config

    public var body: some View {
        GeometryReader { g in
            ZStack {

                // Sun
                Sun(g: g)

                // Clouds
                Clouds(g: g)

                // Haze

                // Mountains
                Mountains(g: g)

                // Near Ground

                // Water

                // Foreground Layer 1

                // Foreground Layer 2

            }
        }.background(config.palette.c4)
    }
    
}

struct Mountains: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        let colors = [
            config.palette.c6,
            config.palette.c7,
            config.palette.c8,
        ]

        var rng = config.scene.mountains

        ZStack {
            ForEach(0 ..< rng.nextInt(1 ..< 3), id: \.self) { index in
                Mountain(g: g, index: index)
                    .foregroundColor(colors[index])
            }
        }

    }

}

struct Mountain: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy
    let index: Int

    var body: some View {

        Text("Mountain")

    }

}

struct Anderscene_Previews: PreviewProvider {

    static var previews: some View {

        let config = Config(
            palette: .default,
            scene: Anderscene.generate(withSeed: 1))

        AndersceneView()
            .previewDevice("iPhone SE (2nd generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

        AndersceneView()
            .previewDevice("iPad Pro (12.9-inch) (4th generation)")
            .edgesIgnoringSafeArea(.all)
            .environmentObject(config)

    }

}
