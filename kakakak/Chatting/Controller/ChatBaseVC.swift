//
//  ChatBaseVC.swift
//  kakakak
//
//  Created by 성용강 on 07/02/2019.
//  Copyright © 2019 성용강. All rights reserved.
//
import SnapKit
import UIKit

class ChatBaseVC: UIViewController {

    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func loadView() {
        super.loadView()
//        self.view = tableView
    }

}
