import Foundation
import RealmSwift

class MessageProcessor{
    
    var room: Room
    var messages: [Message]
    let realm = try! Realm()
    weak var vc: ChatVC?
    
    
    enum EditContent{
        case text(String)
        case image(String)
        case sendFail(Bool)
        case dateLine(Date)
        case dateTime(Date)
        case duration(Int)
    }
    
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
        case .delete: return true
        case .date: return false
        case .enter: return false
        case .exit: return false
        case .image: return true
        case .text: return true
        case .call: return true
        case .record: return true
        }
    }
    
    func reload(){     
        for idx in stride(from: messages.count - 1, through: 0, by: -1){
            if !checkUserMessage(message: messages[idx]){
                continue
            }
            messages[idx].isFirstMessage =  checkFirst(index: idx, message: messages[idx])
        }
        
        for idx in stride(from: 0, through: messages.count - 1, by: 1){
            if !checkUserMessage(message: messages[idx]){
                continue
            }
            messages[idx].isLastMessage =  checkLast(index: idx, message: messages[idx])
        }
        
    }
    
    func deleteMessages(rows: [Int],tableview: UITableView){
        try! realm.write {
            for row in Array(rows.sorted{ $0 > $1 }){
                // primary key로 지우는게 안전할듯한데
                messages.remove(at: row) // atomic으로 지우는게 안전할듯.
                room.messages.remove(at: row)
            }
            reload()
            tableview.reloadData()
        }
    }
    
    func modifyMessage(row: Int, contents: [EditContent]){
        try! realm.write {
            // tableview에서도 수정하고, manger에서도 수정하고 2번 일처리.
            
            for editContnet in contents{
                switch editContnet{
                case .dateLine(let date):
                    messages[row].sendDate = date
                    room.messages[row].sendDate = date
                case .dateTime(let time):
                    messages[row].sendDate = time
                    room.messages[row].sendDate = time
                case .duration(let duration):
                    messages[row].duration = duration
                    room.messages[row].duration = duration
                case .image(let imgName):
                    messages[row].messageImageUrl = imgName
                     room.messages[row].messageImageUrl = imgName
                case .sendFail(let isFail):
                    messages[row].isFail = isFail
                    room.messages[row].isFail = isFail
                case .text(let string):
                    messages[row].messageText = string
                    room.messages[row].messageText = string
                }
            }
            
            reload()
            vc?.tableView.reloadData()
        }
        
    }
    func modifyTimes(rows: [Int], contents: EditContent){
        try! realm.write {
            switch contents {
            case .dateTime(let time):
                for row in rows{
                    messages[row].sendDate = time
                    self.room.messages[row].sendDate = time
                }
            default: break
            }
            reload()
            vc?.tableView.reloadData()
        }
    }
    
//    func modifyMessage(row: Int, tableView: UITableView, message: Message){
//        try! realm.write {
//            messages[row] = message
//            room.messages[row] = message
//            reload()
//            tableView.reloadData()
//        }
//    }
    func addLast(message: Message, tableView: UITableView){
        try! realm.write {
            if let owner = message.owner{
                
                message.noReadUser = room.actviateUserExcepteMe(me: owner)
            }
            
            room.messages.append(message)
            messages.append(message)
            reload()
//            advanceLast(index: messages.count - 1, message: message)
            
            tableView.reloadData()
            tableView.scrollToBottom(animation: false)
        }
    }
    
    func getSelectedMessages() -> [Message]{
        return self.messages.filter{
            $0.isSelected
        }
    }
    func getSelectedMessaegIndexes() -> [Int]{
        var indexes = [Int]()
        for (idx,msg) in self.messages.enumerated(){
            if msg.isSelected {
                indexes.append(idx)
            }
        }
        return indexes
    }
    
    func enterUser(inviter: User, invitedUsers: [Preset]){
        //invite가 찾아서 메시지 삽입해주기.
        //room 에
        
        
        var invitedList = List<User>()
  
       
        
        try! realm.write {
            
            for preset in invitedUsers{
                let user = User(preset: preset)
                invitedList.append(user)
                
            }
            room.users.append(objectsIn: invitedList)
            
            
            let msg = Message.makeEnterMessage(from: inviter, to: invitedList)
            
            messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
        }        
    }
    
    func eixtUser(presetId: String){
        try! realm.write {
            var dUser: User? = nil
            for (idx,user) in room.users.enumerated(){
                if user.presetId == presetId{
                    dUser = user
                    room.users.remove(at: idx)
                    break
                }
            }
            for msg in room.messages{
                for (idx,user) in msg.noReadUser.enumerated(){
                    if user.presetId == presetId{
                        msg.noReadUser.remove(at: idx)
                        break
                    }
                }
            }
            
            guard let user = dUser else { return }
            let msg = Message.makeExitMessage(exit: user)
            
            
            room.messages.append(msg)
            messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
            
        }
    }
    
    
    
    
    func getMessage(idx: Int) -> Message{
        return messages[idx]
    }
    
    func deleteSelectedMessages(){
        try! self.realm.write {
            for idx in self.messages.indices.reversed(){
                let msg = self.messages[idx]
                if msg.isSelected{
                    self.realm.delete(msg)
                    self.messages.remove(at: idx)
                }
            }
            self.vc?.messageManager.reload()
            self.vc?.tableView.reloadData()
            self.vc?.refreshEdit()
        }
    }
    
    func sendDeleteMessage(owner: User?){
        let msg = Message.makeDeleteMessage(owner: owner, sendDate: room.currentDate)
        msg.noReadUser = room.actviateUserExcepteMe(me: owner!)
        try! self.realm.write {
            messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
        }
    }
    
    
    
    func sendMessaegImage(imageName: String,user: User){
        //보내는사람, 이미지 이름, 보내는날짜
        let msg = Message.makeImageMessage(owner: user, sendDate: room.currentDate, imageUrl: imageName)
        msg.noReadUser = room.actviateUserExcepteMe(me: user)
        try! realm.write {
            self.messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
        }
    }
    func addDateLine(sendDate: Date){
        let msg = Message.makeDateMessage(date: sendDate)
        try! realm.write {
            self.messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
            
        }
    }
    func sendRecordMessage(owner: User, minute: Int, second: Int){
        let msg = Message.makeRecordMessage(duration: minute * 60 + second, owner: owner)
        msg.noReadUser = room.actviateUserExcepteMe(me: owner)
        try! realm.write {
            self.messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
            
        }
    }
    
    func userReadMessage(owner: User){
        var change: Bool = false
        try! realm.write {
            for message in room.messages{
                
                for (idx,user) in message.noReadUser.enumerated(){
                    if user.id == owner.id {
                        message.noReadUser.remove(at: idx)
                        change = true
                        break
                    }
                }
            }
            if change {
                reload()
                self.vc?.tableView.reloadData()
            }
        }
    }
    
    
    func sendCallMessage(owner: User,minute: Int, second: Int, callType: Message.callType){
        let msg = Message.makeCallMessage(duration: minute * 60 + second, owner: owner, ctype: callType)
        try! realm.write {
            self.messages.append(msg)
            room.messages.append(msg)
            reload()
            self.vc?.tableView.reloadData()
            self.vc?.tableView.scrollToBottom(animation: false)
            
        }
        
    }
    // 알아야될것. 현재 유저가 누구인지
    
    
}
