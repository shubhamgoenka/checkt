//
//  NameSignupVC.swift
//  Checkt
//
//  Created by Jessica Chen on 11/16/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit
import SwiftMessages

class NameSignupVC: UIViewController {

    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        lastNameTF.font = UIFont(name: "Montserrat-ExtraLight", size: 17)
        firstNameTF.placeholder = "John"
        lastNameTF.placeholder = "Smith"
        let imageView = UIImageView(image: #imageLiteral(resourceName: "Step 1 of 4"))
        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cross"), for: .normal)
        button.addTarget(self, action: #selector(quitSignup), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        let barButton = UIBarButtonItem()
        barButton.customView = button
        self.navigationItem.leftBarButtonItem = barButton
        
        // Do any additional setup after loading the view.
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NameSignupVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func quitSignup() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "toEmailSignupVC"{
            let view = MessageView.viewFromNib(layout: .CardView)
            view.configureTheme(.warning)
            view.configureDropShadow()
            var config = SwiftMessages.Config()
            //config.dimMode = .gray(interactive: true)
            config.duration = .seconds(seconds: 3)
            let iconText = ["😳","😲","😧","😨","☹️"].sm_random()!
            if ((firstNameTF.text?.isEmpty)! && (lastNameTF.text?.isEmpty)!) {
                view.configureContent(title: "Missing Fields", body: "Please enter your first and last name.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if(firstNameTF.text?.isEmpty)!{
                view.configureContent(title: "Missing Field", body: "Please enter your first name.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else if (lastNameTF.text?.isEmpty)! {
                view.configureContent(title: "Missing Field", body: "Please enter your last name.", iconImage: nil, iconText: iconText, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
                SwiftMessages.show(config: config, view: view)
                return false
            } else {
                return true
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toEmailSignupVC"{
            let next = segue.destination as! EmailSignupVC
            next.firstName = firstNameTF.text
            next.lastName = lastNameTF.text
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
