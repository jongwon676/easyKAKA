import UIKit
import RealmSwift
import ReplayKit
import SpriteKit


class ReplayController: UIViewController {
    
    var messageManager: MessageProcessor!
    var window: UIWindow?
    var recordButton: UIButton!
    var room: Room!

    var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
            self.tableView.keyboardDismissMode = .interactive
            self.tableView.allowsSelection = false
            self.tableView.tableFooterView = UIView()
            self.tableView.separatorStyle = .none
            self.tableView.isUserInteractionEnabled = true
            tableView.bounces = false
            
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addNextMessage)))
        }
    }
    
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
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let backgroundUrl = room.backgroundImageName, let backgroundImage = UIImage.loadImageFromName(backgroundUrl){
            
            let imageView = UIImageView(image: backgroundImage)
            imageView.contentMode = .scaleAspectFill
            imageView.layer.masksToBounds = true
            
            tableView.backgroundView = UIImageView(image: backgroundImage)
            tableView.backgroundColor = nil
        }else if let colorHex = room.backgroundColorHex{
            tableView.backgroundColor = UIColor.init(hexString: colorHex)
            tableView.backgroundView = nil
            
        }else{
            navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
            tableView.backgroundColor = #colorLiteral(red: 0.7427546382, green: 0.8191892505, blue: 0.8610599637, alpha: 1)
            tableView.backgroundView = nil
        }
    }
   
    @IBOutlet var childView: UIView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recordButton.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        recordButton.removeFromSuperview()
//        window?.removeFromSuperview()
//        window = nil
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        messageManager = MessageProcessor(room: self.room)
        messageManager.clear()
        self.tableView = (children[0] as! ChatBaseVC).tableView
        
        

        
        
        
        tableView.snp.makeConstraints({ (mk) in
            mk.left.right.top.equalTo(self.view)
            mk.bottom.equalTo(self.middleView.snp.top)
        })
        childView.snp.makeConstraints { (mk) in
            mk.left.right.bottom.top.equalTo(tableView)
        }
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "뒤로", style: .plain, target: self, action: #selector(backButtonClick)) 
        setUpRecordIndicationWindow()
        
    
   }
    
    @objc func backButtonClick(){
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func addNextMessage(){
        messageManager.update(tableView: self.tableView)
    }
}

class CustomWindow: UIWindow{
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if ((view as? UIButton) != nil){
            return view
        }
        else { return nil  }
    }
}

extension ReplayController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {        
        return messageManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messageManager.getMessage(idx: indexPath.row)
        if let cell = tableView.dequeueReusableCell(withIdentifier: msg.getIdent()) as? BaseChat{
            cell.selectionStyle = .none
            cell.editMode = false
            (cell as? ChattingCellProtocol)?.configure(message: msg)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
    
    @objc fileprivate func processTouchRecord() {
        let recorder = RPScreenRecorder.shared()
        if !recorder.isRecording {
            recorder.startRecording { (error) in
                guard error == nil else {
                    print("Failed to start recording")
                    return
                }
                self.recordButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            }
        } else {
            recorder.stopRecording(handler: { (previewController, error) in
                guard error == nil else {
                    print("Failed to stop recording")
                    return
                }
                
                previewController?.previewControllerDelegate = self
                self.present(previewController!, animated: true)

                
                self.recordButton.setImage(#imageLiteral(resourceName: "ic_camera"), for: .normal)
            })
        }
    }

    func setUpRecordIndicationWindow() {
        
        recordButton = UIButton(type: .system)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(recordButton)
        }
        
        
        
        
        
        recordButton.addTarget(self, action: #selector(processTouchRecord), for: .touchUpInside)
        
        recordButton.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.recordButton.setImage(#imageLiteral(resourceName: "ic_camera"), for: .normal)
        
        
//        window = CustomWindow(frame: view.bounds)
//
//        window?.backgroundColor = UIColor.clear
//        window?.isUserInteractionEnabled = true
//
//        window?.addSubview(recordButton)
//        window?.makeKeyAndVisible()
        
    }
    
}
extension ReplayController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
