//
//  PasswordVC.swift
//  Checkt
//
//  Created by Rochelle on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import Firebase
import SwiftMessages

class PasswordVC: UIViewController {
    var email: String?
    var firstName: String?
    var lastName: String?
    var passwordTitle: UILabel!
    var passwordDesc: UILabel!
    
    var lineOne: UIImageView!
    var enterPasswordTF: UITextField!
    var reenterPasswordTF: UITextField!
    var lineTwo: UIImageView!
    var reenterText: UILabel!
    
    var rightArrow: UIButton!
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTopLabels()
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Step 3 of 4"))
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true


        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PasswordVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func createTopLabels() {
        passwordTitle = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.05 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        passwordTitle.text = "Set your password"
        passwordTitle.font = UIFont(name: "Montserrat-Medium", size: 25)
        passwordTitle.textColor = UIColor.white
        self.view.addSubview(passwordTitle)
        
        passwordDesc = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.12 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        passwordDesc.numberOfLines = 1
        passwordDesc.text = "Enter your password."
        passwordDesc.font = UIFont(name: "Montserrat-Light", size: 16)
        passwordDesc.textColor = UIColor.white
        self.view.addSubview(passwordDesc)
        
        enterPasswordTF = UITextField(frame: CGRect(x: 0.1 * screenWidth, y: 0.18 * screenHeight, width:  0.9 * screenWidth, height: 0.2 * screenHeight))
        enterPasswordTF.isSecureTextEntry = true
        enterPasswordTF.textColor = UIColor.white
        enterPasswordTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        self.view.addSubview(enterPasswordTF)
        
        lineOne = UIImageView(frame: CGRect(x: 0.1 * screenWidth, y: 0.20 * screenHeight, width:  0.85 * screenWidth, height: 0.2 * screenHeight))
        lineOne.image = #imageLiteral(resourceName: "Line")
        lineOne.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(lineOne)
        
        reenterText = UILabel(frame: CGRect(x: 0.1 * screenWidth, y: 0.27 * screenHeight, width: 0.9 * screenWidth, height: 0.2 * screenHeight))
        reenterText.text = "Re-enter your password"
        reenterText.font = UIFont(name: "Montserrat-Light", size: 16)
        reenterText.textColor = UIColor.white
        self.view.addSubview(reenterText)
        
        reenterPasswordTF = UITextField(frame: CGRect(x: 0.1 * screenWidth, y: 0.33 * screenHeight, width:  0.9 * screenWidth, height: 0.2 * screenHeight))
        reenterPasswordTF.isSecureTextEntry = true
        reenterPasswordTF.textColor = UIColor.white
        reenterPasswordTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        self.view.addSubview(reenterPasswordTF)
        
        lineTwo = UIImageView(frame: CGRect(x: 0.1 * screenWidth, y: 0.35 * screenHeight, width:  0.85 * screenWidth, height: 0.2 * screenHeight))
        lineTwo.image = #imageLiteral(resourceName: "Line")
        lineTwo.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(lineTwo)
        
        rightArrow = UIButton(frame: CGRect(x: 0.8 * screenWidth, y: 0.53 * screenHeight, width:  0.2 * screenWidth, height: 0.2 * screenWidth))
        rightArrow.setImage(#imageLiteral(resourceName: "Right-50"),for: .normal)
        rightArrow.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightArrow.addTarget(self, action: #selector(goToImagePicker), for: .touchUpInside)
        self.view.addSubview(rightArrow)
    }
    
    func goToImagePicker() {
        if (shouldPerformSegue(withIdentifier: "toImageSignupVC", sender: rightArrow)) {
            self.performSegue(withIdentifier: "toImageSignupVC", sender: self)
        }
        
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
         if identifier == "toImageSignupVC"{
            let view = MessageView.viewFromNib(layout: .CardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            var config = SwiftMessages.Config()
            //config.dimMode = .gray(interactive: true)
            config.duration = .seconds(seconds: 3)
            let iconText = ["😳","😲","😧","😨","☹️"].sm_random()!
            if ((enterPasswordTF.text?.isEmpty)! && (reenterPasswordTF.text?.isEmpty)!) {
                view.configureContent(title: "Missing Fields", body: "Please enter both fields.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if(enterPasswordTF.text?.isEmpty)! {
                view.configureContent(title: "Missing Field", body: "Please enter your password.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if (reenterPasswordTF.text?.isEmpty)! {
                view.configureContent(title: "Missing Field", body: "Please re-enter your password.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if (enterPasswordTF.text != reenterPasswordTF.text) {
                view.configureContent(title: "Passwords don't match", body: "Please re-enter your password.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if ((enterPasswordTF.text?.characters.count)! < 6) {
                view.configureContent(title: "Invalid password", body: "Password must be at least six characters long.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else {
                return true
            }
        }
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageSignupVC"{
            let next = segue.destination as! ImageSignupVC
            next.firstName = self.firstName
            next.lastName = self.lastName
            next.email = self.email
            next.password = self.enterPasswordTF.text
        }
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

