//
//  ImageSignupVC.swift
//  Checkt
//
//  Created by Jessica Chen on 11/16/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import Firebase

class ImageSignupVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!

    var email: String?
    var password: String?
    var firstName: String?
    var lastName: String?
    
    @IBAction func pictureButton(_ sender: Any) {
        self.present(actionSheetController, animated: true, completion: nil)
    }


    
    @IBAction func signupButton(_ sender: AnyObject) {
        signupUser(email: self.email!, password: self.password!)
    }

    
    var imagePicker = UIImagePickerController()
    
    var actionSheetController: UIAlertController = UIAlertController(title: "Please Select an Option:", message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActionSheet()
        self.present(actionSheetController, animated: true, completion: nil)
        

    }
    
  
    func setupUI(){
        imagePickerButton.frame = CGRect(x: view.frame.width/4, y: imagePickerButton.frame.minY, width: view.frame.width * 0.5, height: view.frame.width * 0.5)
        //imagePickerButton.imageView?.contentMode = .scaleAspectFit
        imagePickerButton.imageView?.clipsToBounds = true
        imagePickerButton.imageView?.setRounded()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func signupUser(email: String, password: String){
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print(error)
                return
            } else {
                print("User registered!")
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        //self.signedIn(user)
                        print("signed in!")
                        //Create User Object in FirDatabase
                        let rootRef = FIRDatabase.database().reference()
                        let uid = user!.uid
                        let groupIds: [String] = []
                        let userData: [String: Any] = ["firstName": (self.firstName as NSString?)!, "lastName": (self.lastName as NSString?)!, "email": (self.email as NSString?)!, "uid": (uid as NSString?)!, "groupIds": groupIds]
                        let usersRef = rootRef.child("users")
                        usersRef.child(uid).child("firstName").setValue(self.firstName, withCompletionBlock: {(error, snap) in
                            print(error)
                            print("Success in creating user in Firdatabase")
                        })
                        usersRef.child(uid).setValue(userData){ (error, snap) in
                            print(error)
                            print("Success in creating user in Firdatabase")
                        }
                        
                        //Profile Image Upload
                        
                        //User references: Firebase Database
                        let uniqueUserRef = usersRef.child(uid)
                        
                        //Image References: Firebase Storage stuff
                        let storageRef = FIRStorage.storage().reference(forURL: "gs://checkt-22ac2.appspot.com")
                        let imagesRef = storageRef.child("images")
                        let userImagesRef = imagesRef.child("\(uniqueUserRef.key)")
                        
                        //Set Picture
                        var data = NSData()
                        data = UIImageJPEGRepresentation((self.imagePickerButton.imageView?.image)!, 0.8)! as NSData
                        
                        // Upload the file to the path eventImageRef
                        var downloadURL: URL?
                        let uploadTask = userImagesRef.put(data as Data, metadata: nil) { metadata, error in
                            if (error != nil) {
                                // Uh-oh, an error occurred!
                                print ("An error has occured: \(error)")
                            } else {
                                // Metadata contains file metadata such as size, content-type, and download URL.
                                downloadURL = metadata!.downloadURL()
                                print("Success pic!")
                                print("The actual downloadURL \(downloadURL)")
                            }
                            
                            uniqueUserRef.child("downloadURL").setValue(downloadURL?.absoluteString){ (error, snap) in
                                print("downloadURL added to uniqueeventRef")
                            }
                            
                            //Initialize AppState.currentUser
                            Constants.dbRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                // Get value
                                var value: NSDictionary?
                                if let val = snapshot.value as? NSDictionary{
                                    value = val
                                    //                    let firstName = value?["firstName"] as? String ?? ""
                                    //                    let lastName = value?["lastName"] as? String ?? ""
                                    //                    let email = value?["email"] as? String ?? ""
                                    print ("REAL values \(value)")
                                    AppState.currentUser = User(key: uid, userDict: value as! [String: AnyObject])
                                    print("First name  \(AppState.currentUser!.firstName)")
                                }
                            }) { (error) in
                                print(error.localizedDescription)
                            }
                        }
                        

                        
                        //Open Checktboard Storyboard
                        self.performSegue(withIdentifier: "segueToChecktboard", sender: self)
                    }
                })
            }
        })
        
        
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
            imagePickerButton.setImage(image, for: .normal)
        }
        else{
            print("error occured in setting image")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
