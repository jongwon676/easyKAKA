import UIKit
import GoogleMobileAds
class ViewController: UIViewController{
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        bannerView.rootViewController = self
//        let request = GADRequest()
//        print("request \(request)")
//        bannerView.load(request)
    }
}
