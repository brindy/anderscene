
import SwiftUI

public class Config: ObservableObject {

    @Published var palette: Palette
    @Published var scene: Anderscene

    public init(palette: Palette, scene: Anderscene) {
        self.palette = palette
        self.scene = scene
    }

}
