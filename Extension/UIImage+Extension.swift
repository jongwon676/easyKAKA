import UIKit

extension UIImage{
    
    static func loadImageFromPath(_ path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        guard let img = image else { return nil }
        return img
    }
    
    static func loadImageFromName(_ imgName: String) -> UIImage?{
        do{
            let path = try Path.inDocuments(imgName)
            return UIImage(contentsOfFile: path.path)
        }catch _{
            return nil
        }
    }
    
    func writeImage(imgName name: String) -> Bool{
        let data = self.jpegData(compressionQuality: 1.0)
        
        guard let imgData = data else { return false }
        do{
            try print(Path.inDocuments(name))
            try imgData.write(to: Path.inDocuments(name))
        }catch let err as NSError{
            print(err.localizedDescription)
            return false
        }
        return true
    }
    
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
