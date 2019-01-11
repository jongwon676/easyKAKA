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
        
//        try! realm.write {


            for idx in stride(from: room.messages.count - 1, through: 0, by: -1){
                if !checkUserMessage(message: room.messages[idx]){
                    continue
                }

//                room.messages[idx].isFirstMessage = true


//                advanceFirst(index: idx, message: room.messages[idx])
            }
//            for element in room.messages{
//                print(element.isFirstMessage)
//            }

            for idx in stride(from: 0, through: room.messages.count - 1, by: 1){
                if !checkUserMessage(message: room.messages[idx]){
                    continue
                }

//                    room.messages[idx].isLastMessage = true

//                advanceLast(index: idx, message: room.messages[idx])
            }

//        }
        
    }
    
    enum UpdateType{
        case remove
        case change
        case insert
    }
    
    // 마지막에 추가할때는 좀 다른데?
    
    func apply(index:Int,type: UpdateType){
        var ret = [Int]()
        
        reload()
        
        switch type {
        case .remove:
            if index - 1 >= 0 && index - 1 < room.messages.count { ret.append(index-1) }
            if index < room.messages.count { ret.append(index) }
        case .change:
            ret.append(index)
            if index - 1 >= 0 && index - 1 < room.messages.count { ret.append(index - 1) }
            if index + 1 < room.messages.count { ret.append(index + 1) }
        case .insert:
            tableView.insertRows(at: [IndexPath.row(row: index)], with: .automatic)
            if index - 1 >= 0 && index - 1 < room.messages.count { ret.append(index - 1) }
            if index + 1 < room.messages.count { ret.append(index + 1) }
        }
        
        var scrollIndex = index
        
        if scrollIndex >= room.messages.count{
            scrollIndex -= 1
        }
        
        tableView.reloadData()
        if type == .insert{
            print(scrollIndex)
            print("scroll")
            tableView.scrollToRow(at: IndexPath.row(row: scrollIndex), at: .middle, animated: false)
        }
//        tableView.applyUpdate(updates: ret)
//
//        if scrollIndex >= 0{
//            tableView.scrollToRow(at: IndexPath.row(row: scrollIndex), at: UITableView.ScrollPosition.bottom, animated: false)
//        }
//        tableView.scrollToRow(at: IndexPath.row(row: room.messages.count-1), at: .bottom, animated: false)
        
    }
}

extension IndexPath{
    static func row(row: Int) -> IndexPath{
        return IndexPath(row: row, section: 0)
    }
}


extension UITableView {
    func applyUpdate(updates: [Int]) {
        beginUpdates()
        reloadRows(at: updates.map(IndexPath.row), with: .none)
//        reloadRows(at: updates.map(IndexPath.row), with: .automatic)
        endUpdates()
    }
}
