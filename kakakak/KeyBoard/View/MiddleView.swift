import UIKit
class MiddleView: UIView{
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "sharp"), for: .normal)
        return btn
    }()
    
    lazy var smileButton: TimeButton = {
        let btn = TimeButton(type: .custom)
        btn.setImage(UIImage(named: "emoji_origin"), for: .normal)
        return btn
    }()
    
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
    
    let textViewInset: UIEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 30)
    
    init() {
        super.init(frame: CGRect.zero)
        
        
        
            self.layer.borderColor = #colorLiteral(red: 0.9097726345, green: 0.9057027698, blue: 0.917971909, alpha: 1)
            self.layer.borderWidth = 1
            self.backgroundColor = UIColor.white
            
            let specailFeatureButton = UIButton()
            specailFeatureButton.setImage(UIImage(named: "special_features_origin"), for: .normal)
            let rightStackView = UIStackView()
            
            rightStackView.addArrangedSubview(smileButton)
            rightStackView.addArrangedSubview(sendButton)
            
            rightStackView.axis = .horizontal
            rightStackView.spacing = 15
            rightStackView.alignment = .center
            rightStackView.distribution = .fill
            
            smileButton.snp.makeConstraints { (mk) in
                mk.width.height.equalTo(20)
            }
            sendButton.snp.makeConstraints { (mk) in
                mk.width.height.equalTo(25)
            }
            self.addSubview(textView)
            self.addSubview(rightStackView)
            self.addSubview(specailFeatureButton)
            specailFeatureButton.snp.makeConstraints { (mk) in
                mk.left.equalTo(self).offset(10)
                mk.bottom.equalTo(self).inset(15)
                mk.width.height.equalTo(20)
            }
            
            textView.snp.makeConstraints({ (mk) in
                mk.top.equalTo(self.snp.top).offset(5)
                mk.bottom.equalTo(self.snp.bottom).offset(-5)
                mk.left.equalTo(specailFeatureButton.snp.right).offset(10)
                mk.right.equalTo(self).offset(-10)
                mk.height.equalTo(30)
            })
            
            rightStackView.snp.makeConstraints { (mk) in
                mk.right.equalTo(textView.snp.right).inset(2)
                mk.width.equalTo(60)
                mk.height.equalTo(30)
                mk.centerY.equalTo(specailFeatureButton)
            }
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
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

