//
//  RightSideMenuVC.swift
//  Checkt
//
//  Created by Eliot Han on 11/17/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class RightSideMenuVC: UIViewController{
    var tableView: UITableView! = UITableView()
    var profPic: UIImageView! = UIImageView()
    var nameLabel: UILabel?
    var screenWidth = UIScreen.main.bounds.width * 0.85
    var screenHeight = UIScreen.main.bounds.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupUI()
    }
    
    func setupTableView() {
        tableView.frame = CGRect(x: 0, y: screenHeight - (screenHeight * (1/8)), width: screenWidth, height: (1/4) * screenHeight)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = screenHeight * (1/8)
        tableView.register(RightSideMenuTableViewCell.self, forCellReuseIdentifier: "rightSideCell")
        view.addSubview(tableView!)
    }
    
    func setupUI(){
        profPic.frame = CGRect(x: 0.20 * screenWidth, y: 0.1 * screenHeight, width: 0.3 * screenHeight, height: 0.3 * screenHeight)
        AppState.currentUser?.displayProfPic(withBlock: {retrievedImage -> Void in
            self.profPic.image = retrievedImage
        })
        profPic.contentMode = UIViewContentMode.scaleAspectFill
        profPic.layer.cornerRadius = profPic.frame.size.height / 2;
        profPic.clipsToBounds = true;
        self.view.addSubview(profPic)
        
        nameLabel = UILabel(frame: CGRect(x: 0.20 * screenWidth, y: 0.43 * screenHeight, width: 0.3 * screenHeight, height: 0.05 * screenHeight))
        nameLabel?.textAlignment = .center
        nameLabel?.font = UIFont(name: "Montserrat-Medium", size: 25)
        nameLabel?.textColor = Constants.greenThemeCol
        let first = (AppState.currentUser?.firstName) ?? "Error"
        let last = (AppState.currentUser?.lastName) ?? "Error"
        nameLabel?.text = "\(first) \(last)"
        self.view.addSubview(nameLabel!)
        
        view.backgroundColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
        
    }
    
    func logout(){
        try! FIRAuth.auth()!.signOut()
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "Main", bundle: nil)
        let firstSigninVC = mainView.instantiateViewController(withIdentifier: "FirstSigninVC") as! FirstSigninVC        
        let navigationController = UINavigationController(rootViewController: firstSigninVC)
        
        
        UIView.transition(with: self.view.window!, duration: 0.25, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationController;
            //self.view.window!.rootViewController = navigationController
            navigationController.popToRootViewController(animated: false)
            self.dismiss(animated: false, completion: {})

        }, completion: nil)

    }
        
}

extension RightSideMenuVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rightSideCell", for: indexPath) as! RightSideMenuTableViewCell
//        for subview in cell.contentView.subviews{
//            subview.removeFromSuperview()
//        }
        cell.awakeFromNib()
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let menuCell = cell as! RightSideMenuTableViewCell
        if indexPath.row == 0 {
            menuCell.leftIcon.image = #imageLiteral(resourceName: "Exit-50")
            menuCell.centerTitle.text = "Log Out"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            logout()
        }
    }
    
}

