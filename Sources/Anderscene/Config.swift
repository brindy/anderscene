
import SwiftUI

public class Config: ObservableObject {

    @Published public var palette: Palette
    @Published public var scene: Anderscene

    public init(palette: Palette, scene: Anderscene) {
        self.palette = palette
        self.scene = scene
    }

}
