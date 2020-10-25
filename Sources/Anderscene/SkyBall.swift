
import SwiftUI

struct SkyBall: View {

    @EnvironmentObject var config: Config

    let g: GeometryProxy

    var body: some View {

        var rng = config.scene.sun
        let size = rng.nextCGFloat(50 ..< 100)
        let horizontal = rng.nextCGFloat(0.1 ..< 0.9)
        let vertical = rng.nextCGFloat(0.2 ..< 0.4)
        let x = (horizontal * g.size.width)
        let y = (vertical * g.size.height)

        ZStack {
            Circle()
                .foregroundColor(config.palette.c2)
                .frame(width: size,
                       height: size,
                       alignment: .center)

            Circle()
                .foregroundColor(config.palette.c1)
                .frame(width: size * 0.8,
                       height: size * 0.8,
                       alignment: .center)

        }.position(x: x, y: y)

    }

}
