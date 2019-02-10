import UIKit
import RealmSwift
import ReplayKit
import SpriteKit
import SnapKit


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
    
    
    lazy var backButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.equalTo(32/3)
            mk.height.equalTo(55/3)
        })
        btn.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return UIBarButtonItem(customView: btn)
        
    }()
    
    lazy var fixedSpace:UIBarButtonItem =
        {
            let space =
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            space.width = 20
            return space
            
    }()
    lazy var hamburgerButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.equalTo(60/3)
            mk.height.equalTo(44/3)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var searchButton:UIBarButtonItem = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "searchCopy")!.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.height.equalTo(53 / 3)
        })
        return UIBarButtonItem(customView: btn)
    }()
    let screenView = LiveScreenView()
    
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
        
        
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItems = [searchButton,fixedSpace,hamburgerButton]
        setUpRecordIndicationWindow()
        
    
   }
    lazy var closeButotn: UIButton = {
       let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "replayClose").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var downloadBUtton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "recordDownload").withRenderingMode(.alwaysOriginal), for: .normal)
//        btn.addTarget(self,, for: .touchUpInside)
        return btn
    }()
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let statusHeight = UIApplication.shared.statusBarFrame.height
        closeButotn.frame = CGRect(x: 17, y: statusHeight, width: 40, height: 40)
        downloadBUtton.frame = CGRect(x: UIScreen.main.bounds.width - 40 - 15, y: statusHeight, width: 40, height: 40)
        screenView.frame.size = CGSize(width: 394 / 3, height: 40)
        screenView.center.x = UIScreen.main.bounds.center.x
        screenView.frame.origin.y = statusHeight
        screenView.currentMessageNumbr = 0
        screenView.totalMessageCount = 0
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
//        if let window = UIApplication.shared.keyWindow {
//            window.addSubview(recordButton)
//        }
//
        
        
        
        
        recordButton.addTarget(self, action: #selector(processTouchRecord), for: .touchUpInside)
        
        recordButton.frame = CGRect(x: 100, y: UIApplication.shared.statusBarFrame.height, width: 100, height: 100)
        self.recordButton.setImage(#imageLiteral(resourceName: "ic_camera"), for: .normal)
        
        
        window = CustomWindow(frame: view.bounds)

        window?.backgroundColor = UIColor.clear
        window?.isUserInteractionEnabled = true

        window?.addSubview(recordButton)
        window?.addSubview(closeButotn)
        window?.addSubview(downloadBUtton)
        window?.addSubview(screenView)
        
        window?.makeKeyAndVisible()
        
    }
    
}




extension ReplayController: RPPreviewViewControllerDelegate {
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        self.dismiss(animated: true, completion: nil)
    }
}
class LiveScreenView: UIView{
    private let titleLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    var currentMessageNumbr = 0{ didSet { setupText() } }
    var totalMessageCount = 0 { didSet { setupText() }}
    
    func setupText(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        let dotColor: UIColor = isRecord ? #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1) : #colorLiteral(red: 0.5019036531, green: 0.5019937158, blue: 0.5018979907, alpha: 1)
        let attrText = NSMutableAttributedString(string: "●  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),.foregroundColor:  dotColor,.paragraphStyle: paragraphStyle])
        
        
        attrText.append(NSAttributedString(string: "LIVE:    ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .bold),.foregroundColor: UIColor.white,.paragraphStyle: paragraphStyle,NSAttributedString.Key.baselineOffset : 0]))
        
        attrText.append(NSAttributedString(string: "\(currentMessageNumbr)/\(totalMessageCount)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular),.foregroundColor: UIColor.white,.paragraphStyle: paragraphStyle,NSAttributedString.Key.baselineOffset : 0]))
        
        titleLabel.attributedText = attrText
        
        
    }
    var isRecord: Bool = false{
        didSet{
            setupText()
        }
    }
    func setup(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.55)
        layer.cornerRadius = frame.height / 2
        layer.masksToBounds = true
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (mk) in
            mk.left.right.top.bottom.equalTo(self)
        }
        
        titleLabel.textAlignment = .center
        setup()
        setupText()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
}
