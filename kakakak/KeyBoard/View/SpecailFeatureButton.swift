import UIKit
class SpecailFeatureButton: CustomFocusControl{
    lazy var spView: SpeacialFeatureInputView = {
        let view = SpeacialFeatureInputView(frame: .zero)
        let plist = UserDefaults.standard
        let keyboardHeight = plist.double(forKey: "keyboardHeight")
        if keyboardHeight >= 180{
            view.frame.size.height = CGFloat(keyboardHeight)
        }else{
            view.autoresizingMask = .flexibleHeight
        }
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.inputView = spView
        self.addTarget(self, action: #selector(firstReponder), for: .touchUpInside)
    }
    @objc func firstReponder(){
        self.becomeFirstResponder()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
