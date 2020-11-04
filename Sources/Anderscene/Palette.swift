
import SwiftUI

public struct Palette {

    static let `default` = Palette(
        c1: Color(hex: "ffffff"),
        c2: Color(hex: "ecf0ff"),
        c3: Color(hex: "dde5ff"),
        c4: Color(hex: "d9e2ff"),

        c5: Color(hex: "a2b8ff"),
        c6: Color(hex: "cbf5ab"),
        c7: Color(hex: "bded9a"),
        c8: Color(hex: "aae67a"),
        c9: Color(hex: "9bd96f"),
        c10: Color(hex: "6fbf5c"),

        c11: Color(hex: "7f8c76")
    )

    // Sky
    let c1: Color
    let c2: Color
    let c3: Color
    let c4: Color

    // Hills and most trees
    let c5: Color
    let c6: Color
    let c7: Color
    let c8: Color
    let c9: Color
    let c10: Color

    // Some trees, shadows
    let c11: Color
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

        VStack {
            Group {
                Text("Sky")

                Rectangle()
                    .foregroundColor(Palette.default.c1)
                Rectangle()
                    .foregroundColor(Palette.default.c2)
                Rectangle()
                    .foregroundColor(Palette.default.c3)
                Rectangle()
                    .foregroundColor(Palette.default.c4)
            }

            Group {
                Text("Hills & Trees")
                Rectangle()
                    .foregroundColor(Palette.default.c5)
                Rectangle()
                    .foregroundColor(Palette.default.c6)
                Rectangle()
                    .foregroundColor(Palette.default.c7)
                Rectangle()
                    .foregroundColor(Palette.default.c8)
                Rectangle()
                    .foregroundColor(Palette.default.c9)
                Rectangle()
                    .foregroundColor(Palette.default.c10)
            }
            Group {
                Text("Trees & Rocks")
                Rectangle()
                    .foregroundColor(Palette.default.c11)
            }
        }

    }
}

