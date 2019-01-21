import Foundation
import RealmSwift

class MessageProcessor{
    
    var room: Room
    var messages: [Message]
    let realm = try! Realm()
    
    init(room: Room) {
        self.room = room
        self.messages = Array(self.room.messages)
    }
    func clear(){ self.messages.removeAll() }
    
    
    func update(tableView: UITableView){
        if messages.count >= room.messages.count{ return }
        
        let left = messages.count
        var right = left
        while right <= room.messages.count && room.messages[right].type == .date{
            right += 1
        }
        right = min(right, room.messages.count-1)
        messages.append(contentsOf: (left...right).map{ room.messages[$0] })
        reload()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath.row(row: messages.count - 1), at: .bottom, animated: false)
    }
    
    func checkFirst(index: Int,message: Message) -> Bool{
        for idx in stride(from: index-1, through: 0, by: -1){
            if messages[idx].owner != message.owner{
                return true
            }
            if !checkUserMessage(message: message){
                return true
            }
            
            if Date.timeToString(date: messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                return true
            }
            
            return false
        }
        return true
    }
    
    func checkLast(index: Int, message: Message) -> Bool{
        for idx in stride(from: index + 1, through: messages.count - 1, by: 1){
            if messages[idx].owner != message.owner{
                return true
            }
            if !checkUserMessage(message: message){
                return true
            }
            if Date.timeToString(date: messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                return true
            }
            return false
        }
        return true
    }
    
    func advanceFirst(index: Int, message: Message){
        for idx in stride(from: index + 1, through: messages.count - 1, by: 1){
            if messages[idx].owner != message.owner{
                break
            }
            if !checkUserMessage(message: message){
                break
            }
            if messages[idx].isFirstMessage == false{
                break
            }
            if Date.timeToString(date: messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                break
            }
            messages[idx].isFirstMessage = false
        }
    }
    
    func advanceLast(index: Int, message: Message){
        
        
        for idx in stride(from: index - 1, through: 0, by: -1){
            if messages[idx].owner != message.owner{
                break
            }
            if !checkUserMessage(message: message){
                break
            }
            if messages[idx].isLastMessage == false{
                break
            }
            if Date.timeToString(date: messages[idx].sendDate) != Date.timeToString(date: message.sendDate) {
                break
            }
            messages[idx].isLastMessage = false
        }
        
    }
    
    func checkUserMessage(message: Message) -> Bool{
        switch message.type {
            
        case .date: return false
        case .enter: return false
        case .exit: return false
        case .image: return true
        case .text: return true
        case .voice: return true
        }
    }
    
    func reload(){
        
        
            
        for idx in stride(from: messages.count - 1, through: 0, by: -1){
            if !checkUserMessage(message: messages[idx]){
                continue
            }
            if checkFirst(index: idx, message: messages[idx]){
                messages[idx].isFirstMessage = true
            }
        }
        
        for idx in stride(from: 0, through: messages.count - 1, by: 1){
            if !checkUserMessage(message: messages[idx]){
                continue
            }
            if checkLast(index: idx, message: messages[idx]){
                messages[idx].isLastMessage = true
            }
        }
        
    }
    
    func deleteMessages(rows: [Int],tableview: UITableView){
        try! realm.write {
            for row in Array(rows.sorted{ $0 > $1 }){
                print("delete message row\(row)")
                // primary key로 지우는게 안전할듯한데
                messages.remove(at: row) // atomic으로 지우는게 안전할듯.
                room.messages.remove(at: row)
            }
            reload()
            tableview.reloadData()
        }
    }
    
    func modifyMessage(row: Int, tableView: UITableView, message: Message){
        try! realm.write {
            messages[row] = message
            room.messages[row] = message
            reload()
            tableView.reloadData()
        }
    }
    func addLast(message: Message, tableView: UITableView){
        try! realm.write {
            room.messages.append(message)
            messages.append(message)
            tableView.reloadData()
        }
    }
    
    
    
    func getMessage(idx: Int) -> Message{
        return messages[idx]
    }
    
}
