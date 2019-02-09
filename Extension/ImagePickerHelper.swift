import UIKit

class ImagePickerHelper{
    static func imagePicker(_ source: UIImagePickerController.SourceType,vc: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate){
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.delegate = vc
        picker.allowsEditing = true
        vc.present(picker, animated: true)
    }
    static func addAction(titleString: String?, messageString: String?,vc: UIViewController & UINavigationControllerDelegate & UIImagePickerControllerDelegate){
        
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.camera, vc: vc)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            alert.addAction(UIAlertAction(title: "저장된 앨범", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.savedPhotosAlbum, vc: vc)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            alert.addAction(UIAlertAction(title: "포토 라이브러리", style: .default, handler: { (_) in
                ImagePickerHelper.imagePicker(.photoLibrary, vc: vc)
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        vc.present(alert, animated: true)
        
    }
}
