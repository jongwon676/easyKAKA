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
    
    func writeImage(imgName name: String ) -> Bool{
        let maxWidth: CGFloat = UIScreen.main.bounds.width * 0.6
        let maxHeight: CGFloat = UIScreen.main.bounds.height * 0.5
        let imgCompress = resizeImageWithAspect(image: self, scaledToMaxWidth: maxWidth, maxHeight: maxHeight)
//        let data = imgCompress?.jpegData(compressionQuality: 1.0)
        let data = imgCompress?.jpegData(compressionQuality: 0.3)
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
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage? {
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContextWithOptions(newSize,false,UIScreen.main.scale);
        
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }
    
}

class ProfileImageCacher{
    
    static let shared = ProfileImageCacher()
    private var imageCache = [String: UIImage]()
    private init(){}
    
    func requestImage(imgName: String) -> UIImage?{
        return imageCache[imgName]
    }
    func addImageToCache(imgName: String, img: UIImage){
        imageCache[imgName] = img
    }
    func removeAll(){
        imageCache.removeAll()
    }
    
}
