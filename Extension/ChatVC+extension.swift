import UIKit
import RealmSwift

extension ChatVC: UITextViewDelegate{
    
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
            
            for idx in stride(from: 0, through: room.messages.count - 1, by: 1){
                if !checkUserMessage(message: room.messages[idx]){
                    continue
                }
                room.messages[idx].isLastMessage = true
                advanceLast(index: idx, message: room.messages[idx])
            }
        }
    }
    
 
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textview begin edit")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    @objc func calcKeyBoardFrame(_ notification: NSNotification){
        guard let userInfo = notification.userInfo else { return }
        let keyFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if self.bottomController.keyFrame == nil && keyFrame.height >= 200{
            
            self.bottomController.timeInputView.frame = keyFrame
//            self.bottomController.textView.frame = keyFrame
            
            print("calc keyboard \(keyFrame)")
            NotificationCenter.default.removeObserver(self)
//            bottomController.middleView.textViewResignFirstResponder()
//
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(adjustInsetForKeyboard(_:)),
//                name: UIResponder.keyboardWillHideNotification,
//                object: nil
//            )
//
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(adjustInsetForKeyboard(_:)),
//                name: UIResponder.keyboardWillShowNotification,
//                object: nil)

        }
        
        

        return
    }
    @objc func adjustInsetForKeyboard(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let keyFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        print("init keyFrame\(keyFrame)")
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        
        keyBoardFrame = keyFrame
       
        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false
        guard let keyBoardFrame = keyBoardFrame else { return }
        

        
        
        if show{
            UIView.animate(withDuration: duration) {
                self.bottomController.view.snp.updateConstraints({ (mk) in
                    mk.bottom.equalTo(self.view).offset(-keyFrame.size.height)
                })
            }
            self.view.layoutIfNeeded()
        }else{
            UIView.animate(withDuration: duration, animations: {
                self.bottomController.view.snp.updateConstraints({ (mk) in
                    mk.bottom.equalTo(self.view).offset(0)
                })
            })

            self.view.layoutIfNeeded()
        }
        
    }
    
    
    
    
    var bottomMost:IndexPath{
        return IndexPath(row: messages.count - 1, section: 0)
    }
    
    func makeDummyCells(){
//        try! realm.write {
//            realm.delete(messages)
//        }
        
        var dummymsgs = [Message]()
        if messages.count < 2000{
            for idx in 0 ..< 20{
                var txt = ""
                for idx in  0 ..< arc4random_uniform(200) + 1{
                    txt += String(idx)
                }
                let msg = Message(owner: room.users[0], sendDate: room.currentDate, messageText: txt)
                dummymsgs.append(msg)
            }
            for idx in 0 ..< 1 {
                let msg = Message.makeDateMessage()
                dummymsgs.append(msg)
            }
            for idx in 0 ..< 1{
                let msg = Message.makeExitMessage(exit: room.users[0])
                dummymsgs.append(msg)
            }
            try! realm.write {
                messages.append(objectsIn: dummymsgs)
            }
        }
    }
}

extension ChatVC: bottomInfoReceiver{
    func sendMessage(text: String) {
        guard let currentUser = bottomController.selectedUser else { return }

        room.addMessage(message: Message(owner: currentUser, sendDate: room.currentDate, messageText: text))
//
        
    }
    
    func addMinute(minute: Int) {
        try! realm.write {
            room.currentDate = room.currentDate.addingTimeInterval(60.0 * Double(minute))
            
            self.navigationItem.title = Date.timeToStringSecondVersion(date: self.room.currentDate)
        }
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
    }
}
extension ChatVC: EditChatting{
    func excuteDelete() {
        print("delete 버튼이 클릭도이ㅓ씁니다.")
        showDeleteMessagesModal()
    }
    
    func excuteCancel() {
        self.tableView.indexPathsForSelectedRows?.forEach({ (indexPath) in
            self.tableView.deselectRow(at: indexPath, animated: false)
        })
    }
    
    func excuetEdit() {
        print("eidt button이 클릭되엇습니다.")
    }
    
    func excuteEsc() {
        isEditMode = false
    }
    
    
    
}
