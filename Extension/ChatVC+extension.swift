import UIKit
import RealmSwift

extension ChatVC{
    
    func checkFirst(index: Int,message: Message) -> Bool{
        for idx in stride(from: index-1, through: 0, by: -1){
            if room.messages[idx].owner != message.owner{
                return true
            }
            if room.messages[idx].type == Message.MessageType.date ||
                room.messages[idx].type == Message.MessageType.enter ||
                room.messages[idx].type == Message.MessageType.exit{
                return true
            }
            
            if Date.timeToString(date: room.messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                return true
            }
            
            return false
        }
        return true
    }
    
    func checkLast(index: Int, message: Message) -> Bool{
        for idx in stride(from: index + 1, through: room.messages.count - 1, by: 1){
            if room.messages[idx].owner != message.owner{
                return true
            }
            if room.messages[idx].type == Message.MessageType.date ||
                room.messages[idx].type == Message.MessageType.enter ||
                room.messages[idx].type == Message.MessageType.exit{
                return true
            }
            if Date.timeToString(date: room.messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                return true
            }
            return false
        }
        return true
    }
    
    func advanceFirst(index: Int, message: Message){
        
            
            
            for idx in stride(from: index + 1, through: room.messages.count - 1, by: 1){
                if room.messages[idx].owner != message.owner{
                    break
                }
                if room.messages[idx].type == Message.MessageType.date ||
                    room.messages[idx].type == Message.MessageType.enter ||
                    room.messages[idx].type == Message.MessageType.exit{
                    break
                }
                if room.messages[idx].isFirstMessage == false{
                    break
                }
                if Date.timeToString(date: room.messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                    break
                }
                room.messages[idx].isFirstMessage = false
            }
            
        
    }
    
    func advanceLast(index: Int, message: Message){
        
            
            for idx in stride(from: index - 1, through: 0, by: -1){
                if room.messages[idx].owner != message.owner{
                    break
                }
                if room.messages[idx].type == Message.MessageType.date ||
                    room.messages[idx].type == Message.MessageType.enter ||
                    room.messages[idx].type == Message.MessageType.exit{
                    break
                }
                if room.messages[idx].isLastMessage == false{
                    break
                }
                if Date.timeToString(date: room.messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                    break
                }
                room.messages[idx].isLastMessage = false
            
        }
    }
    
    func checkUserMessage(message: Message) -> Bool{
        switch message.type {
        case .date: return false
        case .enter: return false
        case .exit: return false
        case .image: return true
        case .text: return true
        case .guide: return false
        }
    }
    
    func reload(){
        
        try! realm.write {
             for idx in stride(from: room.messages.count - 1, through: 0, by: -1){
                if !checkUserMessage(message: room.messages[idx]){
                    continue
                }
                room.messages[idx].isFirstMessage = true
                advanceFirst(index: idx, message: room.messages[idx])
            }
            for element in room.messages{
                print(element.isFirstMessage)
            }
            
            for idx in stride(from: 0, through: room.messages.count - 1, by: 1){
                if !checkUserMessage(message: room.messages[idx]){
                    continue
                }
                room.messages[idx].isLastMessage = true
                advanceLast(index: idx, message: room.messages[idx])
            }
        }
    }
    func scrolToGuideLine(position: UITableView.ScrollPosition = .middle){
        tableView.scrollToRow(at: guideLineIndex, at: position, animated: false)
        
    }
}

extension IndexPath{
    static func row(row: Int) -> IndexPath{
        return IndexPath(row: row, section: 0)
    }
}

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
        reloadData()
        if insertions.count > 0 {
            scrollToRow(at: IndexPath.row(row: insertions.first!), at: .middle, animated: false)
        }
    }
}
