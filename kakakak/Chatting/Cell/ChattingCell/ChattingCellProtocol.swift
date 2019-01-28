
import Foundation
protocol ChattingCellProtocol:class {
    static var reuseId: String { get }
    func configure(message:Message)
}
