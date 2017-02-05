//
//  EventInfoVC.swift
//  Checkt
//
//  Created by Shubham Goenka on 23/11/16.
//  Copyright © 2016 Eliot Han. All rights reserved.
//

import UIKit

class EventInfoVC: UIViewController {
    var card: UIView!
    var event: Event!
    var profPicImageView: UIImageView!
    var eventNameLabel: UILabel!
    var groupNameLabel: UILabel!
    var locationLabel: UILabel!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    var logoExitButton: UIButton!
    var textExitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupVC()
    }
    
    func setupCardView() {
        
        card = EventInfoCardView(frame: CGRect(x: 30, y: 30, width: view.frame.width - 60, height: view.frame.height - 160))
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
        borderLayer.strokeColor = UIColor(red: 0.96, green: 0.43, blue: 0.23, alpha: 1.0).cgColor
        borderLayer.lineWidth = 30
        borderLayer.frame = card.bounds
        card.layer.addSublayer(borderLayer)
    }
    
    func setupVC() {
        view.backgroundColor = UIColor(red: 0.87, green: 0.84, blue: 0.84, alpha: 1.0)
        
        profPicImageView = UIImageView(frame: CGRect(x: (view.frame.width - card.frame.height * 2/5)/2, y: 80, width: card.frame.height * 2/5, height: card.frame.height * 2/5))
        profPicImageView.backgroundColor = .black
        view.addSubview(profPicImageView)
        
        eventNameLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 110, width: view.frame.width - 140, height: 70))
        eventNameLabel.text = event.name
        eventNameLabel.adjustsFontSizeToFitWidth = true
        eventNameLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        eventNameLabel.numberOfLines = 2
        eventNameLabel.textColor = .black
        eventNameLabel.textAlignment = .center
        view.addSubview(eventNameLabel)
        
        groupNameLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 185, width: view.frame.width - 140, height: 30))
        groupNameLabel.text = event.hostGroup
        groupNameLabel.font = UIFont(name: "HelveticaNeue-SemiBold", size: 20)
        groupNameLabel.adjustsFontSizeToFitWidth = true
        groupNameLabel.numberOfLines = 1
        groupNameLabel.textColor = UIColor(red: 0.00, green: 0.62, blue: 0.57, alpha: 1.0)
        groupNameLabel.textAlignment = .center
        view.addSubview(groupNameLabel)
        
        locationLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 220, width: view.frame.width - 140, height: 30))
        locationLabel.text = event.location["center"] as! String
        groupNameLabel.font = UIFont(name: "HelveticaNeue-SemiBold", size: 18)
        locationLabel.adjustsFontSizeToFitWidth = true
        locationLabel.numberOfLines = 1
        locationLabel.textColor = .black
        locationLabel.textAlignment = .center
        view.addSubview(locationLabel)
        
        dateLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 255, width: view.frame.width - 140, height: 30))
        dateLabel.text = event.date
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .black
        dateLabel.textAlignment = .center
        view.addSubview(dateLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 70, y: card.frame.height * 2/5 + 290, width: view.frame.width - 140, height: 30))
        timeLabel.text = "\(event.startTime) to \(event.endTime)"
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .black
        timeLabel.textAlignment = .center
        view.addSubview(timeLabel)
        
        logoExitButton = UIButton(frame: CGRect(x: view.frame.width/2 - 20, y: card.frame.height + 60, width: 40, height: 40))
        logoExitButton.setBackgroundImage(UIImage(named: "Checktboard logo Green"), for: .normal)
        logoExitButton.addTarget(self, action: #selector(tappedExit), for: .touchUpInside)
        view.addSubview(logoExitButton)
        
        textExitButton = UIButton(frame: CGRect(x: view.frame.width * 0.1, y: card.frame.height + 110, width: view.frame.width * 0.8, height: 30))
        textExitButton.setTitle("Back to Checktboard", for: .normal)
        textExitButton.setTitleColor(Constants.greenThemeCol, for: .normal)
        textExitButton.titleLabel?.textAlignment = .center
        textExitButton.titleLabel?.adjustsFontSizeToFitWidth = true
        textExitButton.addTarget(self, action: #selector(tappedExit), for: .touchUpInside)
        view.addSubview(textExitButton)
    }
    
    func tappedExit() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

