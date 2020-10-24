
import SwiftUI

class Config: ObservableObject {

    @Published var palette: Palette
    @Published var scene: Anderscene

    init(palette: Palette, scene: Anderscene) {
        self.palette = palette
        self.scene = scene
    }

}
