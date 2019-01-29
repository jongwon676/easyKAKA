import UIKit
class SpecailFeatureButton: CustomFocusControl{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(firstReponder), for: .touchUpInside)
    }
    @objc func firstReponder(){
        self.becomeFirstResponder()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
