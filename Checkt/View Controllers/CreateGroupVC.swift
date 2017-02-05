//
//  CreateGroupVC.swift
//  Checkt
//
//  Created by Shubham Goenka on 23/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class CreateGroupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    var card: UIView!
    var greyBackgroundView: UIView!
    var isPrivate: Bool = false
    var groupNameTextField: UITextField!
    var profPicImageButton: UIButton!
    var groupDescTextView: UITextView!
    var statusLabel: UILabel!
    var lockButton: UIButton!
    var doneButton: UIButton!
    var cancelButton: UIButton!
    let screenwidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    var imagePicker = UIImagePickerController()
    var actionSheetController: UIAlertController = UIAlertController(title: "Please Select an Option:", message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        scrollView = UIScrollView(frame: view.frame)
        contentView = UIView(frame: view.frame)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        setupCardView()
        setupVC()
        profPicImageButton.imageView?.contentMode = .scaleAspectFit
        profPicImageButton.imageView?.clipsToBounds = true
        
        imagePicker.delegate = self
        setupActionSheet()
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NameSignupVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        groupNameTextField.delegate = self
        groupDescTextView.delegate = self

    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupCardView() {
        
        card = CreateGroupCardView(frame: CGRect(x: 25, y: 25, width: view.frame.width - 50, height: view.frame.height - 50))
        contentView?.addSubview(card)
        
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = card.bounds
        maskLayer.path = UIBezierPath(roundedRect: card.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 30, height: 30)).cgPath
        // Add shadows
        maskLayer.shadowColor = UIColor.white.cgColor
        maskLayer.shadowOffset = CGSize(width: 10, height: 10);
        maskLayer.shadowOpacity = 0.5
        
        card.layer.mask = maskLayer
        
        // Add border
        let borderLayer = CAShapeLayer()
        borderLayer.path = maskLayer.path // Reuse the Bezier path
        borderLayer.fillColor = UIColor.white.cgColor
        borderLayer.strokeColor = UIColor(red: 0.00, green: 0.62, blue: 0.57, alpha: 1.0).cgColor
        borderLayer.lineWidth = 30
        borderLayer.frame = card.bounds
        card.layer.addSublayer(borderLayer)
    }
    
    func setupVC() {
        
        view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.75)
        
        cancelButton = UIButton(frame: CGRect(x: 55, y: 55, width: 20, height: 20))
        cancelButton.setImage(#imageLiteral(resourceName: "blackCross"), for: .normal)
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        cancelButton.addTarget(self, action: #selector(tappedX), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        
        groupNameTextField = UITextField(frame: CGRect(x: 25, y: 85, width: screenwidth - 50, height: 50))
        groupNameTextField.placeholder = "Group Name"
        groupNameTextField.font = Constants.defaultL
        groupNameTextField.textAlignment = .center
        groupNameTextField.textColor = .black
        groupNameTextField.adjustsFontSizeToFitWidth = true
        contentView.addSubview(groupNameTextField)
        
        profPicImageButton = UIButton(frame: CGRect(x: (view.frame.width - card.frame.height * 0.3)/2, y: 140, width: card.frame.height * 0.3, height: card.frame.height * 0.3))
        profPicImageButton.setImage(UIImage(named: "Image File-500"), for: .normal)
        profPicImageButton.imageView?.contentMode = .scaleAspectFill
        profPicImageButton.clipsToBounds = true
        profPicImageButton.addTarget(self, action: #selector(self.tappedImage(_:)), for: UIControlEvents.touchUpInside)
        contentView.addSubview(profPicImageButton)
        
        greyBackgroundView = UIView(frame: CGRect(x: 40, y: card.frame.height * 0.3 + 160, width: view.frame.width - 80, height: card.frame.height * 0.3))
        greyBackgroundView.backgroundColor = UIColor(red: 0.87, green: 0.84, blue: 0.84, alpha: 1.0)
        contentView.addSubview(greyBackgroundView)
        
        groupDescTextView = UITextView(frame: CGRect(x: 55, y: card.frame.height * 0.3 + 175, width: view.frame.width - 110, height: card.frame.height * 0.3 - 30))
        groupDescTextView.backgroundColor = UIColor(red: 0.87, green: 0.84, blue: 0.84, alpha: 1.0)
        //groupDescTextView.placeholder = "Enter a brief description."
        groupDescTextView.textColor = .black
        groupDescTextView.font = UIFont(name: "HelveticaNeue", size: 20)
        groupDescTextView.textAlignment = .justified
        
        //groupDescTextField.contentInset = UIEdgeInsetsMake(-groupDescTextField.frame.height/2, 0, 0, 0)
        contentView.addSubview(groupDescTextView)
        
        statusLabel = UILabel(frame: CGRect(x: screenwidth * 0.25, y: card.frame.height * 0.6 + 175, width: screenwidth * 0.4, height: screenwidth * 0.1))
        statusLabel.textAlignment = .left
        statusLabel.text = "Public or Private?"
        statusLabel.font = Constants.defaultL
        statusLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(statusLabel)
        
        lockButton = UIButton(frame: CGRect(x: screenwidth * 0.65, y: card.frame.height * 0.6 + 175, width: screenwidth * 0.1, height: screenwidth * 0.1))
        lockButton.setBackgroundImage(UIImage(named: "Unlock-50"), for: .normal)
        lockButton.addTarget(self, action: #selector(togglePrivacy), for: .touchUpInside)
        contentView.addSubview(lockButton)
        
        doneButton = UIButton(frame: CGRect(x: screenwidth * 0.4, y: card.frame.height * 0.6 + screenwidth * 0.1 + 185, width: screenwidth * 0.2, height: 30))
        doneButton.setTitle("Create", for: .normal)
        doneButton.setTitleColor(UIColor(red:0.36, green:0.71, blue:0.91, alpha:1.0), for: .normal)
        doneButton.setTitleColor(.black, for: .highlighted)
        doneButton.titleLabel!.font = Constants.defaultL
        doneButton.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        contentView.addSubview(doneButton)
    }
    
    //add user input to Firebase: Create a group with the child attributes 
    func donePressed(){
        if (groupNameTextField.text! == "") {
            showErrorMessage(title: "Error", body: "Please enter group name.")
        } else if (profPicImageButton.imageView?.image == #imageLiteral(resourceName: "Image File-500")) {
            showErrorMessage(title: "Error", body: "Please select a group image.")
        } else if (groupDescTextView.text! == "") {
            showErrorMessage(title: "Error", body: "Please enter a group description.")
        } else {
            let groupDict: [String: Any] = ["description": groupDescTextView.text!, "admins": [AppState.currentUser!.uid]]
            let dbRef = FIRDatabase.database().reference()
            let groupRef = dbRef.child("groups").child(groupNameTextField.text!)
            groupRef.setValue(groupDict)
            
            //Image References: Firebase Storage stuff
            let storageRef = FIRStorage.storage().reference(forURL: "gs://checkt-22ac2.appspot.com")
            let groupImagesRef = storageRef.child("groupImages")
            
            //Set Picture
            if(self.profPicImageButton.imageView?.image != nil){
                var data = NSData()
                data = UIImageJPEGRepresentation((self.profPicImageButton.imageView?.image)!, 0.8)! as NSData
                
                // Upload the file to the path eventImageRef
                var downloadURL: URL?
                let uploadTask = groupImagesRef.put(data as Data, metadata: nil) { metadata, error in
                    if (error != nil) {
                        // Uh-oh, an error occurred!
                    } else {
                        // Metadata contains file metadata such as size, content-type, and download URL.
                        downloadURL = metadata!.downloadURL()
                    }
                    
                    groupRef.child("groupImageURL").setValue(downloadURL?.absoluteString){ (error, snap) in
                        print("downloadURL added to unique groupRef")
                    }
                }
                
                let groupId = groupNameTextField.text!
                let group = Group(key: groupId, groupDict: groupDict as [String : AnyObject])
                let userGroupIdsRef = Constants.dbRef.child("users").child((AppState.currentUser?.uid)!).child("groupIds")
                AppState.currentUser?.groups.append(group)
                
                var groupIds: [String] = []
                userGroupIdsRef.observeSingleEvent(of: .value, with: { snapshot in
                    if snapshot.exists() {
                        if let groupIdsArray = snapshot.value as? [String] {
                            groupIds = groupIdsArray
                            groupIds.append(groupId)
                            userGroupIdsRef.setValue(groupIds)
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                    } else {
                        print("This is the user's first group!")
                        groupIds.append(groupId)
                        userGroupIdsRef.setValue(groupIds){ (error, snap) in
                            print(error)
                            print("Success in creating groupIds Array and adding to users groupIds in Firdatabase")
                            self.dismiss(animated: true, completion: nil)
                            return

                        }
                        
                    }
                })

          
            }

        }
        

    }
    
    func showErrorMessage(title: String, body: String){
        let iconText = ["😳","😲","😧","😨","☹️"].sm_random()!
        let mview = MessageView.viewFromNib(layout: .CardView)
        mview.configureTheme(.warning)
        //mview.configureDropShadow()
        var config = SwiftMessages.Config()
        //config.dimMode = .gray(interactive: true)
        config.duration = .seconds(seconds: 3)
        config.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        mview.configureContent(title: title, body: body, iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        SwiftMessages.show(config: config, view: mview)
    }
    
    
    
    func setupActionSheet() {
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        actionSheetController.addAction(cancelAction)
        
        let cameraAction: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(cameraAction)
        
        let libraryAction: UIAlertAction = UIAlertAction(title: "Select from Camera Roll", style: .default) { action -> Void in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetController.addAction(libraryAction)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profPicImageButton.setImage(image, for: .normal)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func tappedImage(_ sender: UIButton!) {
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func tappedCreate(_ sender: UIButton!) {
        // Add the group to Firebase
        // Dismiss the VC
    }
    
    func tappedX() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func togglePrivacy() {
        if (isPrivate) {
            isPrivate = false
            lockButton.setBackgroundImage(UIImage(named: "Unlock-50"), for: .normal)
        } else {
            isPrivate = true
            lockButton.setBackgroundImage(UIImage(named: "Lock-50-2"), for: .normal)
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == groupNameTextField {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 30
        }
        return false
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        return textView.text.characters.count + (text.characters.count - range.length) <= 140
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if textView == groupDescTextView {
//            guard let text = textView.text else { return true }
//            
//            let newLength = text.utf16.count + text.utf16.count - range.length
//            return newLength <= 10
//        }
//        return false
//    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == groupDescTextView {
            let p = CGPoint(x: 0, y: 250)
            scrollView.setContentOffset(p, animated: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let p = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(p, animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
