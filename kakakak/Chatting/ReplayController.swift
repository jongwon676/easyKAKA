//
//  ReplayController.swift
//  kakakak
//
//  Created by 성용강 on 19/01/2019.
//  Copyright © 2019 성용강. All rights reserved.
//

import UIKit
import RealmSwift
class ReplayController: UIViewController {

    var token: NotificationToken?
    let defaultRealm = try! Realm()
    let replayRealm = RealmProvider.replayRealm.realm
    var copyUsers = [String: User]()
    lazy var tableView: UITableView = {
       let tableView = ChatTableView()
        tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNextMessage)))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ (mk) in
            mk.left.right.top.equalTo(self.view)
            mk.bottom.equalTo(self.middleView.snp.top)
        })
        
        return tableView
    }()
    
    lazy var middleView: MiddleView = {
       let middleView = MiddleView()
        middleView.textView.isEditable = false
        middleView.sendButton.setImage(UIImage(named: "enter"), for: .normal)
        self.view.addSubview(middleView)
        middleView.snp.makeConstraints({ (mk) in
            mk.left.right.equalTo(self.view)
            mk.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            mk.height.equalTo(40)
        })
        return middleView
    }()
    
    
    
    
    var messages = List<Message>()
    
    var displayMessages = Message.all(in: RealmProvider.replayRealm.realm)
    
    
    var room: Room!{
        didSet{
            messages = room.messages
            for user in room.users{
                if copyUsers[user.id] == nil{
                    copyUsers[user.id] = (user.copy() as! User)
                }
            }
            try! replayRealm.write {
                replayRealm.deleteAll()
            }
        }
    }
    
    deinit {
        token?.invalidate()
        try! replayRealm.write {
            replayRealm.deleteAll()
        }
        
    }
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        token = messages.observe{ [weak tableView] changes in
            guard let tableView = tableView else { return }
            switch changes{
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        }
    }
    
    @objc func addNextMessage(){
        if displayMessages.count >= messages.count{ return }
        try! replayRealm.write {
            replayRealm.add(messages[displayMessages.count].copy() as! Message)
        }
    }
    
}

extension ReplayController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = displayMessages[indexPath.row]
        switch msg.type {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.reuseId) as! TextCell
            let users = (msg.owner)!
            cell.incomming = !users.isMe
            cell.configure(message: msg)
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: ChattingImageCell.reuseId) as! ChattingImageCell
            let users = (msg.owner)!
            cell.incomming = !users.isMe
            cell.configure(msg)
            
            return cell
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: DateCell.reuseId) as! DateCell
            cell.configure(message: msg)
            return cell
        case .enter:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserEnterCell.reuseId) as! UserEnterCell
            cell.configure(message: msg)
            return cell
        case .exit:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserExitCell.reuseId) as! UserExitCell
            cell.configure(message: msg)
            return cell

    }
    }
    
    
}
