import UIKit

extension UIImage{
    static var cache: [String:UIImage] = [String:UIImage]()
    
    static func loadImageFromPath(_ path: String) -> UIImage? {
        let image = UIImage(contentsOfFile: path)
        guard let img = image else { return nil }
        return img
    }
    
    static func loadImageFromName(_ imgName: String) -> UIImage?{
        do{
            if cache[imgName] != nil{
                return cache[imgName]
            }
            let path = try Path.inDocuments(imgName)
            cache[imgName] = UIImage(contentsOfFile: path.path)
            return cache[imgName]
        }catch _{
            return nil
        }
    }
    
    func writeImage(imgName name: String ) -> Bool{
        let data = self.jpegData(compressionQuality: 0.1)
        
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
