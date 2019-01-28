
import UIKit
protocol FirstResponderControlDelegate: class {
    func firstResponderControl(_ control: CustomFocusControl, didReceiveText text: String)
    func firstResponderControlDidDeleteBackwards(_ control: CustomFocusControl)
    func firstResponderControlHasText(_ control: CustomFocusControl) -> Bool
}

class CustomFocusControl: UIButton, UIKeyInput {
    var hasText: Bool{
        return true
        //        return self.delegate?.firstResponderControlHasText(self) ?? false
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    private var _inputView: UIView?
    override var inputView: UIView? {
        get {
            return _inputView
        }
        set {
            _inputView = newValue
        }
    }
    
    weak var delegate: FirstResponderControlDelegate?
    
    
    func insertText(_ text: String) {
        self.delegate?.firstResponderControl(self, didReceiveText: text)
    }
    
    func deleteBackward() {
        self.delegate?.firstResponderControlDidDeleteBackwards(self)
    }
    
}



