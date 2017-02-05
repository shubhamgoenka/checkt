//
//  GroupInfoVC.swift
//  Checkt
//
//  Created by Shubham Goenka on 23/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit

class GroupInfoVC: UIViewController {

    var card: UIView!
    var group: Group!
    var profPicImageView: UIImageView!
    var groupDescLabel: UILabel!
    var iconImageView: UIImageView!
    var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setupCardView()
        setupVC()
    }
    
    func setupCardView() {
        
        card = GroupInfoCardView(frame: CGRect(x: 30, y: 30, width: view.frame.width - 60, height: view.frame.height - 60))
        view.addSubview(card)
        
        // Add rounded corners
        let maskLayer = CAShapeLayer()
        maskLayer.frame = card.bounds
        maskLayer.path = UIBezierPath(roundedRect: card.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 30, height: 30)).cgPath
        // Add shadows
        maskLayer.shadowColor = UIColor.black.cgColor
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
        view.backgroundColor = UIColor(red: 0.87, green: 0.84, blue: 0.84, alpha: 1.0)
        
        profPicImageView = UIImageView(frame: CGRect(x: (view.frame.width - card.frame.height * 2/5)/2, y: 80, width: card.frame.height * 2/5, height: card.frame.height * 2/5))
        group.getGroupImage(withBlock: { retrievedImage -> Void in
            self.profPicImageView.image = retrievedImage
        })
        view.addSubview(profPicImageView)
        
        groupDescLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 130, width: view.frame.width - 140, height: view.frame.height - (card.frame.height * 2/5) - 310))
        //groupDescLabel.text = group.description
//        groupDescLabel.text = group.description
        groupDescLabel.textColor = .black
        groupDescLabel.textAlignment = .justified
        view.addSubview(groupDescLabel)
        
        iconImageView = UIImageView(frame: CGRect(x: view.frame.width * 0.5 - 25, y: view.frame.height - 130, width: 50, height: 50))
        iconImageView.image = UIImage(named: "Lock-50")
        view.addSubview(iconImageView)
        
        dismissButton = UIButton(frame: CGRect(x: view.frame.width/2 + card.frame.height/5 - 30, y: view.frame.height - 130, width: 30, height: 50))
        dismissButton.setBackgroundImage(UIImage(named: "Exit-50"), for: .normal)
        dismissButton.addTarget(self, action: #selector(tappedExit), for: .touchUpInside)
        view.addSubview(dismissButton)
    }
    
    func tappedExit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

