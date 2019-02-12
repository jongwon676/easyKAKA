import UIKit

class ImagePickerHelper{
    static let shared = ImagePickerHelper()
    private init(){}
    func imagePicker(_ source: UIImagePickerController.SourceType,vc: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,allowEdit: Bool){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = vc
        picker.allowsEditing = allowEdit
        vc.present(picker, animated: true)
    }
    func addAction(titleString: String?, messageString: String?,vc: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate,allowEdit: Bool = true){
        
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
                self.imagePicker(.camera, vc: vc, allowEdit: allowEdit)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
                self.imagePicker(.savedPhotosAlbum, vc: vc, allowEdit: allowEdit)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
                self.imagePicker(.photoLibrary, vc: vc, allowEdit: allowEdit)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        vc.present(alert, animated: true)
        
    }
}
