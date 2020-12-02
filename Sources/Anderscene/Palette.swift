
import SwiftUI

public struct Palette {

    public static let `default` = Palette(
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
        tree5: Color(hex: "5a9c4b"),
        tree6: Color(hex: "7f8c76"),

        waterShoreHighlight: Color(hex: "dde5ff"),
        waterDark: Color(hex: "bcccff"),
        waterHighlight: Color(hex: "d9e2ff"),
        waterDarkSparkle: Color(hex: "dde5ff"),
        waterHighlightSparkle: Color(hex: "ecf0ff"),

        rock: Color(hex: "66705f"),
        rockHighlight: Color(hex: "7f8c76"),

        islandGrass: Color(hex: "6fbf5c"),
        islandHighlight: Color(hex: "9bd96f"),
        islandReflection: Color(hex: "a2b8ff")
    )

    public static let dark = Palette(
        skyBallForeground: Color(hex: "99e4ff"),
        skyBallHalo: Color(hex: "99e4ff").opacity(0.3),

        sky: Color(hex: "1f5da2"),
        haze: Color(hex: "209fee"),
        clouds: Color(hex: "35a9e8"),

        peaks: Color(hex: "0b89e8"),
        hillFar: Color(hex: "125ba3"),
        hillNear: Color(hex: "166fc7"),
        shore: Color(hex: "234a8c"),

        tree1: Color(hex: "125ba3"),
        tree2: Color(hex: "166fc7"),
        tree3: Color(hex: "13305e"),
        tree4: Color(hex: "1c3f7a"),
        tree5: Color(hex: "1c3f7a"),
        tree6: Color(hex: "13305e"),

        waterShoreHighlight: Color(hex: "28a2ff"),
        waterDark: Color(hex: "0b89e8"),
        waterHighlight: Color(hex: "28a2ff"),
        waterDarkSparkle: Color(hex: "28a2ff"),
        waterHighlightSparkle: Color(hex: "0b89e8"),

        rock: Color(hex: "166fc7"),
        rockHighlight: Color(hex: "0b89e8"),

        islandGrass: Color(hex: "13305e"),
        islandHighlight: Color(hex: "28a2ff"),
        islandReflection: Color(hex: "1c3f7a")
    )

    // Sky Ball
    public let skyBallForeground: Color
    public let skyBallHalo: Color

    // Sky
    public let sky: Color
    public let haze: Color
    public let clouds: Color

    // Hills
    public let peaks: Color
    public let hillFar: Color
    public let hillNear: Color
    public let shore: Color

    // Trees
    public let tree1: Color
    public let tree2: Color
    public let tree3: Color
    public let tree4: Color
    public let tree5: Color
    public let tree6: Color

    // Water
    public let waterShoreHighlight: Color
    public let waterDark: Color
    public let waterHighlight: Color
    public let waterDarkSparkle: Color
    public let waterHighlightSparkle: Color

    // Rocks
    public let rock: Color
    public let rockHighlight: Color

    // Island
    public let islandGrass: Color
    public let islandHighlight: Color
    public let islandReflection: Color

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
                    Rectangle()
                        .foregroundColor(palette.tree6)
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
                    Rectangle()
                        .foregroundColor(palette.waterDarkSparkle)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.waterHighlightSparkle)
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

            Group {
                Text("Island")
                HStack {
                    Rectangle()
                        .foregroundColor(palette.islandGrass)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.islandHighlight)
                        .frame(width: 50, height: 50, alignment: .center)
                        .border(Color.black)
                    Rectangle()
                        .foregroundColor(palette.islandReflection)
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

        let config = Config(
            palette: .dark,
            scene: Anderscene.generate(withSeed: 111111))

        AndersceneView()
            .previewLayout(.fixed(width: 300, height: 600))
            .environmentObject(config)

        PaletteView(palette: .default).previewLayout(.fixed(width: 300, height: 600))

        PaletteView(palette: .dark).previewLayout(.fixed(width: 300, height: 600))

    }

}

