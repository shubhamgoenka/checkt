//
//  EmailSignupVC.swift
//  Checkt
//
//  Created by Jessica Chen on 11/16/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import SwiftMessages

class EmailSignupVC: UIViewController {
    var firstName: String?
    var lastName: String? 
    @IBOutlet weak var emailTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        emailTF.placeholder = "checkt@checkt.org"
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Step 2 of 4"))
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
//        let button = UIButton()
//        button.setImage(#imageLiteral(resourceName: "leftArrow"), for: .normal)
//        button.addTarget(self, action: #selector(previousScreen), for: .touchUpInside)
//        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
//        let barButton = UIBarButtonItem()
//        barButton.customView = button
//        self.navigationItem.backBarButtonItem = barButton



        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmailSignupVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func previousScreen() {
        performSegue(withIdentifier: "toNameSignupVC", sender: self)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func isValidEmail(email2Test:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = email2Test.range(of: emailRegEx, options: .regularExpression)
        let result = range != nil ? true : false
        return result
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "toPasswordVC"{
            let view = MessageView.viewFromNib(layout: .CardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            var config = SwiftMessages.Config()
            //config.dimMode = .gray(interactive: true)
            config.duration = .seconds(seconds: 3)
            let iconText = ["😳","😲","😧","😨","☹️"].sm_random()!
            if ((emailTF.text?.isEmpty)!) {
                view.configureContent(title: "Missing Field", body: "Please enter your email.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
                //            }
                //            else if (emailTF.text?.range(of: "@") == nil) {
                //                view.configureContent(title: "Invalid email", body: "Please enter a valid email address.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                //                SwiftMessages.show(config: config, view: view)
                //                return false
                
            } else  if (!isValidEmail(email2Test: emailTF.text!)){
                view.configureContent(title: "Invalid email", body: "Please enter a valid email address.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
                
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPasswordVC"{
            let next = segue.destination as! PasswordVC
            next.firstName = self.firstName
            next.lastName = self.lastName
            next.email = emailTF.text
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
