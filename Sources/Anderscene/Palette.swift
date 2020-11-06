
import SwiftUI

public struct Palette {

    static let `default` = Palette(
        skyBallForeground: Color(hex: "ffffff"),
        skyBallHalo: Color(hex: "ecf0ff"),

        sky: Color(hex: "d9e2ff"),
        haze: Color(hex: "ecf0ff"),
        clouds: Color(hex: "ecf0ff"),

        peaks: Color(hex: "cbf5ab"),
        hillFar: Color(hex: "bded9a"),
        hillNear: Color(hex: "aae67a"),
        shore: Color(hex: "9bd96f"),

        tree1: Color(hex: "bded9a"),
        tree2: Color(hex: "aae67a"),
        tree3: Color(hex: "9bd96f"),
        tree4: Color(hex: "6fbf5c"),
        tree5: Color(hex: "7f8c76"),

        waterShoreHighlight: Color(hex: "dde5ff"),
        waterDark: Color(hex: "bcccff"),
        waterHighlight: Color(hex: "d9e2ff")

    )

    // Sky Ball
    let skyBallForeground: Color
    let skyBallHalo: Color

    // Sky
    let sky: Color
    let haze: Color
    let clouds: Color

    // Hills
    let peaks: Color
    let hillFar: Color
    let hillNear: Color
    let shore: Color

    // Trees
    let tree1: Color
    let tree2: Color
    let tree3: Color
    let tree4: Color
    let tree5: Color

    // Water
    let waterShoreHighlight: Color
    let waterDark: Color
    let waterHighlight: Color

}

// https://stackoverflow.com/a/56874327/73479
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct Palette_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default

        VStack(alignment: .leading) {
            Group {
                Text("Sky Ball")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.skyBallForeground)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.skyBallHalo)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Group {
                Text("Sky")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.sky)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.haze)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.clouds)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Group {
                Text("Hills")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.peaks)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.hillFar)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.hillNear)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.shore)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Group {
                Text("Trees")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.tree1)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.tree2)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.tree3)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.tree4)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.tree5)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Group {
                Text("Water")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.waterShoreHighlight)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.waterDark)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.waterHighlight)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Spacer()
        }
        
    }

}

