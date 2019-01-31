import UIKit

extension IndexPath {
    static func fromRow(_ row: Int) -> IndexPath {
        return IndexPath(row: row, section: 0)
    }
}

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        beginUpdates()
        deleteRows(at: deletions.map(IndexPath.fromRow), with: .none)
        insertRows(at: insertions.map(IndexPath.fromRow), with: .none)
        reloadRows(at: updates.map(IndexPath.fromRow), with: .none)
        endUpdates()
    }
    func scrollToBottom(animation: Bool){
        let cnt = self.numberOfRows(inSection: 0)
        guard cnt > 0 else { return }
        self.scrollToRow(at: IndexPath.fromRow(cnt-1), at: .bottom, animated: animation)
    }
}
