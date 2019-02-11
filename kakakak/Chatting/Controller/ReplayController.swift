import UIKit
import RealmSwift
import ReplayKit
import SpriteKit
import SnapKit


class ReplayController: UIViewController {
    var bgType: BgType = .dark{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
            self.navigationController?.navigationBar.tintColor = bgType.barTintColor()
        }
    }
    
    var messageManager: MessageProcessor!
    var window: UIWindow?
    var pvController: RPPreviewViewController?{
        didSet{
            if pvController != nil{
                downloadBUtton.isHidden = false
                self.present(pvController!, animated: true)
            }
        }
    }
    
    lazy var recordButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "recordStart").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(processTouchRecord), for: .touchUpInside)
        return btn
    }()
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
        middleView.sendButton.setImage(#imageLiteral(resourceName: "sharp").withRenderingMode(.alwaysOriginal), for: .normal)
        middleView.smileButton.setImage(#imageLiteral(resourceName: "emoji_origin").withRenderingMode(.alwaysOriginal), for: .normal)
        self.view.addSubview(middleView)
        middleView.snp.makeConstraints({ (mk) in
            mk.left.right.equalTo(self.view)
            mk.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        })
        return middleView
    }()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let colorIndex = room.backgroundcolorIndex
        tableView.backgroundColor = Style.allColors[colorIndex]
        tableView.backgroundView = nil
        navigationController?.navigationBar.barTintColor = Style.allColors[colorIndex]
        setupNavBar()
        
        bgType = Style.getBgType(color: tableView.backgroundColor!)
        
    }
    
    func setupNavBar(){
        let tableColor = tableView.backgroundColor
        self.navigationController?.navigationBar.layer.backgroundColor = nil
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage(withColours: [tableColor! ,tableColor!], location: [0,1], view: (self.navigationController?.navigationBar)! ), for: .default)
    }
    func gradientImage(withColours colours: [UIColor], location: [Double], view: UIView) -> UIImage {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).0
        gradient.endPoint = (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5)).1
        gradient.locations = location as [NSNumber]
        gradient.cornerRadius = view.layer.cornerRadius
        return UIImage.image(from: gradient) ?? UIImage()
    }
   
    @IBOutlet var childView: UIView!
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        recordButton.isHidden = true
        downloadBUtton.isHidden = true
        closeButotn.isHidden = true
        screenView.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        recordButton.removeFromSuperview()
        
//        window?.removeFromSuperview()
//        window = nil
        
    }
    
    
    lazy var backButton: UIBarButtonItem = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
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
        btn.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
        btn.snp.makeConstraints({ (mk) in
            mk.width.equalTo(60/3)
            mk.height.equalTo(44/3)
        })
        return UIBarButtonItem(customView: btn)
    }()
    
    lazy var searchButton:UIBarButtonItem = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "searchCopy")!.withRenderingMode(.alwaysTemplate), for: .normal)
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
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
    
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
        btn.addTarget(self, action: #selector(downloadButtonClicked), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    @objc func downloadButtonClicked(){
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let statusHeight = UIApplication.shared.statusBarFrame.height
        closeButotn.frame = CGRect(x: 17, y: statusHeight, width: 40, height: 40)
        downloadBUtton.frame = CGRect(x: UIScreen.main.bounds.width - 40 - 15, y: statusHeight, width: 40, height: 40)
        screenView.frame.size = CGSize(width: 394 / 3, height: 40)
        screenView.center.x = UIScreen.main.bounds.center.x
        screenView.frame.origin.y = statusHeight
        
        var recordButtonYMargin:CGFloat = 10
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            recordButtonYMargin += bottomPadding ?? 0
        }
        recordButtonYMargin += middleView.frame.height
        let recordButtonSize:CGFloat = 50
        
        recordButton.frame = CGRect(x: UIScreen.main.bounds.center.x - recordButtonSize / 2, y: UIScreen.main.bounds.height - recordButtonYMargin - recordButtonSize, width: recordButtonSize, height: recordButtonSize)
        setupNavBar()
        
    }
    @objc func backButtonClick(){
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func addNextMessage(){
        messageManager.update(tableView: tableView, liveView: screenView)
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
            cell.bgType = bgType
            
            (cell as? ChattingCellProtocol)?.configure(message: msg, bgType: bgType)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
    
    @objc fileprivate func processTouchRecord() {
        let recorder = RPScreenRecorder.shared()
        if !recorder.isRecording {
            
            recorder.startRecording { [weak self] (error) in
                guard error == nil else {
                    print("Failed to start recording")
                    return
                }
                self?.recordButton.setImage(#imageLiteral(resourceName: "recordStop").withRenderingMode(.alwaysOriginal), for: .normal)
                self?.screenView.isRecord = true
            }
        } else {
            recorder.stopRecording(handler: { [weak self] (previewController, error) in
                guard let `self` = self else { return }
                guard error == nil else {
                    print("Failed to stop recording")
                    return
                }
                self.pvController = previewController
                
                previewController?.previewControllerDelegate = self
                
                self.screenView.isRecord = false
                self.recordButton.isHidden = true
                
                
            })
        }
    }

    func setUpRecordIndicationWindow() {
        
        
        
        
        
        
        
        
        window = CustomWindow(frame: view.bounds)

        window?.backgroundColor = UIColor.clear
        window?.isUserInteractionEnabled = true
        window?.addSubview(recordButton)
        window?.addSubview(closeButotn)
        window?.addSubview(downloadBUtton)
        window?.addSubview(screenView)
        screenView.totalMessageCount = messageManager.room.messages.count
        screenView.currentMessageNumbr = 0
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
    
    var currentMessageNumbr = 0{
        didSet {
            print("currentMessgaeNumber \(currentMessageNumbr)")
            setupText()
        }
    }
    var totalMessageCount = 0 { didSet { setupText() }}
    
    func setupText(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        
        let dotColor: UIColor = isRecord ? #colorLiteral(red: 1, green: 0.2705882353, blue: 0.2274509804, alpha: 1) : #colorLiteral(red: 0.5019036531, green: 0.5019937158, blue: 0.5018979907, alpha: 1)
        let attrText = NSMutableAttributedString(string: "●  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),.foregroundColor:  dotColor,.paragraphStyle: paragraphStyle])
        
        
        attrText.append(NSAttributedString(string: "LIVE:    ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .bold),.foregroundColor: UIColor.white,.paragraphStyle: paragraphStyle,NSAttributedString.Key.baselineOffset : 0]))
        
        attrText.append(NSAttributedString(string: "\(currentMessageNumbr)/\(totalMessageCount)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular),.foregroundColor: UIColor.white,.paragraphStyle: paragraphStyle,NSAttributedString.Key.baselineOffset : 0]))
        
        titleLabel.attributedText = attrText
        setNeedsDisplay()
        
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
