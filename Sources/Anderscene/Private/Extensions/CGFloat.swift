
import SwiftUI

infix operator +% : AdditionPrecedence
infix operator -% : AdditionPrecedence
extension CGFloat {

    static func +% (left: CGFloat, right: CGFloat) -> CGFloat {
        return left * (1 + right)
    }

    static func -% (left: CGFloat, right: CGFloat) -> CGFloat {
        return left * (1 - right)
    }

}
