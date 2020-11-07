
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
        waterHighlight: Color(hex: "d9e2ff"),

        rock: Color(hex: "66705f"),
        rockHighlight: Color(hex: "7f8c76")
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

    // Rocks
    let rock: Color
    let rockHighlight: Color

}

struct PaletteView: View {

    let palette: Palette

    var body: some View {

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

            Group {
                Text("Rocks")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.rock)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.rockHighlight)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                }
            }

            Spacer()
        }

    }

}

struct Palette_Previews: PreviewProvider {
    static var previews: some View {

        let palette = Palette.default
        PaletteView(palette: palette)

    }

}

