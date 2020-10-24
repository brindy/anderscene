
import SwiftUI

struct Sun: View {

    @EnvironmentObject var config: Config

    let maxOffset: CGFloat

    var body: some View {
        let size = CGFloat(config.rng.nextInt(40 ..< 80))
        let top = CGFloat(config.rng.nextInt(20 ..< 100))
        let leading = CGFloat(config.rng.nextInt(20 ..< Int(maxOffset) - Int(size) - 20))

        ZStack {
            Circle()
                .foregroundColor(config.palette.c2)
                .frame(width: size, height: size, alignment: .center)

            Circle()
                .foregroundColor(config.palette.c1)
                .frame(width: size - 10, height: size - 10, alignment: .center)
        }.padding(EdgeInsets(top: top, leading: leading, bottom: 0, trailing: 0))
    }

}
