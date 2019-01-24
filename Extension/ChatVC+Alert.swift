import Foundation
import UIKit
extension ChatVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func handleHamburger(){
        self.bottomController.keyboardHide()
        let alert = UIAlertController(title: nil, message: "옵션", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "등장인물 초대", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "등장인물 퇴장", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "대화방 이름 변경하기", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "대화방 시간 변경", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "사진찍기", style: .default, handler: { (action) in
            self.bottomController.mode = .capture
        }))
        
        alert.addAction(UIAlertAction(title: "미리보기", style: .default, handler: { (action) in
                let replayControlelr = ReplayController()
                replayControlelr.room = self.room
                let nav = UINavigationController(rootViewController: replayControlelr)
                self.present(nav, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "배경 변경", style: .default, handler: { (action)
            in
            
            let backGroundController = BackgroundSelectController(collectionViewLayout: UICollectionViewFlowLayout())
            backGroundController.room = self.room
            let nav = UINavigationController(rootViewController: backGroundController)
            self.present(nav, animated: true, completion: nil)
        }))
        
        present(alert, animated: true) 
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let imageName = Date().currentDateToString() + ".jpg"
            img.writeImage(imgName: imageName)
            //            let msg = Message.makeImageMessage(owner: getCurrentUser(), sendDate: room.currentDate, imageUrl: imageName)
            //            try! realm.write {
            //                    messages.insert(msg, at: guideLineIndex.row)
            //
            //            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func addSpecailFeature(){
        let alert = UIAlertController(title: nil, message: "옵션", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "이미지 추가", style: .default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "날짜선 추가", style: .default, handler: { (action) in
            
            self.dateSelect()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func dateSelect()  {
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 260))
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        datePicker.addTarget(self, action: #selector(dateSelected(datePicker:)), for: UIControl.Event.valueChanged)
        
        let alertController = UIAlertController(title: nil, message:"날짜선 추가" , preferredStyle: UIAlertController.Style.actionSheet)
        
        alertController.view.addSubview(datePicker)//add subview
        
        let okayAction = UIAlertAction(title: "확인", style: .default) { (action) in
            self.dateSelected(datePicker: datePicker)
        }
        
        //add button to action sheet
        alertController.addAction(okayAction)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(height);
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    //selected date func
    @objc func dateSelected(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM월 d일 EEE"
        let currentDate = datePicker.date
//        print(dateFormatter.string(from: currentDate))
        // "yyyy년 MMM월 d일 EEE"
        // 2018년 4월 27일 금요일
    }
    
    func showDeleteMessagesModal(){
        let alert = UIAlertController(title: "메시지를 삭제 하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
    
}
extension UIImage {
    class var screenShot: UIImage? {
        let imageSize = UIScreen.main.bounds.size as CGSize;
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        for obj : AnyObject in UIApplication.shared.windows {
            if let window = obj as? UIWindow {
                if window.responds(to: #selector(getter: UIWindow.screen)) || window.screen == UIScreen.main {
                    // so we must first apply the layer's geometry to the graphics context
                    
                    
                    context.saveGState();
                    // Center the context around the window's anchor point
                    context.translateBy(x: window.center.x, y: window.center
                        .y);
                    // Apply the window's transform about the anchor point
                    context.concatenate(window.transform);
                    // Offset by the portion of the bounds left of and above the anchor point
                    context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x,
                                        y: -window.bounds.size.height * window.layer.anchorPoint.y);
                    
                    // Render the layer hierarchy to the current context
                    window.layer.render(in: context)
                    
                    // Restore the context
                    context.restoreGState();
                }
            }
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {return nil}
        return image
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}


