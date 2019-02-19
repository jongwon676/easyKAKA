import Foundation
import UIKit
extension ChatVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @objc func handleHamburger(){
        self.bottomController.keyboardHide()
        
        let alert = UIAlertController(title: nil, message: "옵션", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "대화방 시간 변경", style: .default, handler: { (_) in
            self.bottomController.middleView.smileButton.becomeFirstResponder()
            
        }))
        
        alert.addAction(UIAlertAction(title: "녹화하기", style: .default, handler: { (action) in
            
            let replayControlelr = self.storyboard?.instantiateViewController(withIdentifier: "ReplayController") as! ReplayController
            
            replayControlelr.room = self.room
            replayControlelr.bgType = self.bgType
            let nav = CustomNavigationController(rootViewController: replayControlelr)
            nav.type = self.bgType
            self.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "사진찍기", style: .default, handler: { (action) in
            self.bottomController.mode = .capture
            self.setNavTitle()
        }))
        
        
        
        alert.addAction(UIAlertAction(title: "등장인물 초대", style: .default, handler: { (_) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            if let roomAddVC = storyboard.instantiateViewController(withIdentifier: "RoomAddVC") as? RoomAddVC{
                
                roomAddVC.type = .invite
                roomAddVC.excludeId = self.room.activeUserId(exceptMe: false)
                roomAddVC.canInviteUser = self.room.activateUsers
                roomAddVC.messageManager = self.messageManager
                self.present(roomAddVC, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "등장인물 퇴장", style: .default, handler: {
            (_) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
            if let roomAddVC = storyboard.instantiateViewController(withIdentifier: "RoomAddVC") as? RoomAddVC{
                
                roomAddVC.type = .exit
                roomAddVC.includeId = self.room.activeUserId(exceptMe: true)
                roomAddVC.messageManager = self.messageManager
                self.present(roomAddVC, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "대화방 이름 변경하기", style: .default, handler: {
            (_) in
            self.changeChattingRoomTitle()
            
        }))
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "배경 변경", style: .default, handler: { (action)
            in
            
            let backGroundController = BackgroundSelectController(collectionViewLayout: UICollectionViewFlowLayout())
            backGroundController.room = self.room
            let nav = UINavigationController(rootViewController: backGroundController)
            self.present(nav, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true) 
        
    }
    
    func changeChattingRoomTitle(){
        let alert = UIAlertController(title: nil, message: "대화방 이름을 입력해주세요.", preferredStyle: .alert)
        // alert -> room
        alert.addTextField { [weak self] (textField) in
            textField.text = self?.room.getRoomTitleName()
        }
        let saveAction = UIAlertAction(title: "확인", style: .default) { [weak self] (action) in
            guard let textField = alert.textFields?.first else { return }
            try! self?.realm.write {
                if textField.text!.isEmpty{
                    self?.room.title = nil
                }else{
                    self?.room.title = textField.text
                }
                self?.setNavTitle()
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            let imageName = Date().currentDateToString() + ".jpg"
            img.writeImage(imgName: imageName)
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
        alertController.addAction(okayAction)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        alertController.view.addConstraint(height);
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //selected date func
    @objc func dateSelected(datePicker:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MMM월 d일 EEE"
    }
    
    func showDeleteMessagesModal(){
        let alert = UIAlertController(title: "메시지를 삭제 하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { (action) in
            self.messageManager.deleteSelectedMessages()
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


