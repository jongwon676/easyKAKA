import UIKit
import GoogleMobileAds
class ViewController: UIViewController{
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet var fontTestLabel: UILabel!{
        didSet{
            fontTestLabel.font = UIFont(name: "xeicon", size: 18)
            fontTestLabel.text = "\u{e9aa}"
            fontTestLabel.textColor = UIColor.lightGray
//            .xi-error:before {
//                content: "\e9aa";
//            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
//        let request = GADRequest()
//        print("request \(request)")
//        bannerView.load(request)
    }
}
