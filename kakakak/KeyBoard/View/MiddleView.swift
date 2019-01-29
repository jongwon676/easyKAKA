import UIKit
class MiddleView: UIView{
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "sharp"), for: .normal)
        return btn
    }()
    
    lazy var smileButton: CustomFocusControl = {
        let btn = CustomFocusControl(type: .custom)
        btn.setImage(UIImage(named: "emoji_origin"), for: .normal)
        return btn
    }()
    
    
    
    let specailFeatureButton = SpecailFeatureButton()
    
    lazy var textView: customTextView = {
        let textView = customTextView()
        textView.isUserInteractionEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = textViewInset
        textView.layer.cornerRadius = 16
        textView.layer.borderColor = #colorLiteral(red: 0.9097726345, green: 0.9057027698, blue: 0.917971909, alpha: 1)
        textView.backgroundColor = #colorLiteral(red: 0.9726272225, green: 0.9645878673, blue: 0.9726623893, alpha: 1)
        
        textView.layer.borderWidth = 1
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        return textView
    }()
    
    let textViewInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 62)
    
    
    func setup(){
        self.layer.borderColor = #colorLiteral(red: 0.9097726345, green: 0.9057027698, blue: 0.917971909, alpha: 1)
        self.layer.borderWidth = 1
        self.backgroundColor = UIColor.white
        
        specailFeatureButton.setImage(UIImage(named: "special_features_origin"), for: .normal)
        
        
        self.addSubview(textView)
        self.addSubview(specailFeatureButton)
        self.addSubview(sendButton)
        self.addSubview(smileButton)
        
        
        smileButton.snp.makeConstraints { (mk) in
            mk.width.height.equalTo(20)
            mk.right.equalTo(sendButton.snp.left).offset(-22)
//            mk.centerY.equalTo(textView)
            mk.bottom.equalTo(textView).inset(7.5)
        }
        
        sendButton.snp.makeConstraints { (mk) in
            mk.width.equalTo(14)
            mk.height.equalTo(16)
            mk.right.equalTo(textView.snp.right).inset(14)
//            mk.centerY.equalTo(textView)
            mk.bottom.equalTo(textView).inset(8.5)
        }
        
        
        
        specailFeatureButton.snp.makeConstraints { (mk) in
            mk.left.equalTo(self).offset(10)
            mk.bottom.equalTo(textView).inset(8.5)
            mk.width.height.equalTo(20)
        }
        
        textView.snp.makeConstraints({ (mk) in
            mk.top.equalTo(self.snp.top).offset(5)
            mk.bottom.equalTo(self.snp.bottom).offset(-5)
            mk.left.equalTo(specailFeatureButton.snp.right).offset(10)
            mk.right.equalTo(self).offset(-10)
            mk.height.equalTo(36)
        })
        
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
        
        
        
    }

    var text: String{
        get { return self.textView.text }
        set { self.textView.text = newValue}
    }
    func isEmpty() -> Bool{
        return self.textView.text.isEmpty
    }
    func textViewResignFirstResponder(){
        textView.resignFirstResponder()
    }
    func textViewBecomeFirstResponder(){
        textView.becomeFirstResponder()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
//        fatalError("init(coder:) has not been implemented")
    }
}

extension MiddleView{
    static let smileButtonWidth:CGFloat = 20
    static let smileButtonHeight:CGFloat = 20
    static let sendButtonWidth: CGFloat = 14
    static let sendButtonHeight: CGFloat = 16
    static let textViewHeight:CGFloat = 36
    static let middleViewHeight:CGFloat = 44
    
}

