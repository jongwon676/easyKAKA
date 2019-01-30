import UIKit
import RealmSwift

extension ChatVC: UITextViewDelegate{

    func textViewDidBeginEditing(_ textView: UITextView) {
        print("textview begin edit")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    
    
    
    @objc func adjustInsetForKeyboard(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

        let keyFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        let show = (notification.name == UIResponder.keyboardWillShowNotification)
            ? true
            : false

        var offset:CGFloat = 0
        
        if #available(iOS 11.0, *){
            offset = keyFrame.size.height - CGFloat(view.safeAreaInsets.bottom)
        }else{
            offset = keyFrame.size.height
        }
        
        
        print("stackHeight \(bottomController.getKeyBoardHeight())")
        let bHeight = bottomController.getKeyBoardHeight()
        if show {
            UIView.animate(withDuration: duration) {
                self.bottomController.view.snp.updateConstraints({ (mk) in
                    mk.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-offset)
                })
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyFrame.height + bHeight, right: 0)
            }
            tableView.setContentOffset(tableView.contentOffset, animated: false)
            self.view.layoutIfNeeded()
            
        } else{
            UIView.animate(withDuration: duration, animations: {
                self.bottomController.view.snp.updateConstraints({ (mk) in
                    mk.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(0)
                })
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bHeight, right: 0)
            })
            tableView.setContentOffset(tableView.contentOffset, animated: false)
            self.view.layoutIfNeeded()
        }
    }
    
    
    func makeDummyCells(){

    
        func makeDummyText(num: Int,isDelete: Bool = false){
            var msgs = [Message]()
            for _ in 0 ..< num{
                var txt = ""
                for idx in  0 ..< arc4random_uniform(40) + 1{ txt += String(idx) }
                let msg = Message(owner: room.users[0], sendDate: room.currentDate, messageText: txt)
                msg.isDelete = isDelete
                msgs.append(msg)
            }
            try! realm.write {
                room.messages.append(objectsIn: msgs)
            }
        }
        
        func makeDummyDate(num:Int){
            var msgs = [Message]()
            for _ in 0 ..< num {
                let msg = Message.makeDateMessage()
                
                msgs.append(msg)
            }
            try! realm.write {
                room.messages.append(objectsIn: msgs)
            }
        }
        
        func makeImageDummy(num: Int){
            var msgs = [Message]()
            for _ in 0 ..< num{
                let msg = Message.makeImageMessage(owner: room.users[1], sendDate: room.currentDate, imageUrl: "1547971841.679249.jpg")
                msgs.append(msg)
            }
            try! realm.write {
                room.messages.append(objectsIn: msgs)
            }
        }
        
        func makeExitDummy(num: Int){
            var msgs = [Message]()
            for _ in 0 ..< num{
                let msg = Message.makeExitMessage(exit: room.users[1])
                msgs.append(msg)
            }
            try! realm.write {
                room.messages.append(objectsIn: msgs)
            }
        }
        func makeVoiceDummy(num: Int){
            var msgs = [Message]()
            for _ in 0 ..< num{
//                let msg = Message.make
            }
        }
        
//        makeDummyText(num: 1000)
//        makeImageDummy(num: 5)
//        makeDummyText(num: 5, isDelete: true)
//        makeExitDummy(num: 1)
    }
}

extension ChatVC: bottomInfoReceiver{
    func sendMessage(text: String) {
        guard let currentUser = bottomController.selectedUser else { return }
        messageManager.addLast(message: Message(owner: currentUser, sendDate: room.currentDate, messageText: text), tableView: self.tableView)
        
    }
    func addMinute(minute: Int) {
        try! realm.write {
            room.currentDate = room.currentDate.addingTimeInterval(60.0 * Double(minute))
            self.navigationItem.title = Date.timeToStringMinuteVersion(date: self.room.currentDate)
        }
    }
}

extension IndexPath{
    static func row(row: Int) -> IndexPath{
        return IndexPath(row: row, section: 0)
    }
}

extension ChatVC: EditChatting{
    func excuteDelete() {
        showDeleteMessagesModal()
    }
    
    func excuteCancel() {
//        self.tableView.indexPathsForSelectedRows?.forEach({ (indexPath) in
//            self.tableView.deselectRow(at: indexPath, animated: false)
//        })
    }
    
    func excuetEdit() {
        
        let storyboard = UIStoryboard.init(name: "MessageEdit", bundle: Bundle.main)
        
        if let nav = storyboard.instantiateViewController(withIdentifier: "MessageEditNav") as? UINavigationController{
            ((nav.viewControllers[0]) as? MessageEditController)?.messages = messageManager.getSelectedMessages()
            ((nav.viewControllers[0]) as? MessageEditController)?.chatVc = self
            
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func excuteEsc() {
        isEditMode = false
    }
    
    
    
}
