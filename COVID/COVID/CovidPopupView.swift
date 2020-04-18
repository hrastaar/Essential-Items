//
//  CovidPopupView.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/13/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class CovidPopupView: UIView {
    
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    
    @IBOutlet var providedLabel: UILabel!
    var covidData: CovidData?
    
    func designPopup() {
        
        self.covidData = CovidData()
        self.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(self.superview!).offset(UIScreen.main.bounds.maxY*(1/4))
            make.left.equalTo(self.superview!).offset(30)
            make.bottom.equalTo(self.superview!).offset(-UIScreen.main.bounds.maxY*(1/4))
            make.right.equalTo(self.superview!).offset(-30)
        }
        self.popupHeadingLabel = UILabel()
        self.confirmedCaseLabel = UILabel()
        self.criticalCaseLabel = UILabel()
        self.deathsLabel = UILabel()
        self.recoveredLabel = UILabel()
        self.providedLabel = UILabel()
        while(self.covidData?.confirmedCount == "") {
            // wait until a response is given TODO: Implement a better way of doing this
        }
        updateCovidLabels()
        self.layer.cornerRadius = 15
        self.addSubview(popupHeadingLabel)
        self.addSubview(confirmedCaseLabel)
        self.addSubview(criticalCaseLabel)
        self.addSubview(deathsLabel)
        self.addSubview(recoveredLabel)
        self.addSubview(providedLabel)
    }
    
    func updateCovidLabels() {
        
        print("Entered updateCovidLabels")
        
        self.popupHeadingLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 10, width: superview!.bounds.width - 60, height: 75))
        self.popupHeadingLabel.textAlignment = .center
        self.popupHeadingLabel.font = UIFont.regularFont(size: 32)
        self.popupHeadingLabel.textColor = .white

        self.confirmedCaseLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 85, width: superview!.bounds.width - 60, height: 50))
        self.confirmedCaseLabel.textAlignment = .center
        self.confirmedCaseLabel.numberOfLines = 0
        self.confirmedCaseLabel.font = UIFont.regularFont(size: 18)
        self.confirmedCaseLabel.textColor = .white

        
        self.criticalCaseLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 135, width: superview!.bounds.width - 60, height: 50))
        self.criticalCaseLabel.textAlignment = .center
        self.criticalCaseLabel.numberOfLines = 0
        self.criticalCaseLabel.font = UIFont.regularFont(size: 18)
        self.criticalCaseLabel.textColor = .white

        
        self.deathsLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 185, width: superview!.bounds.width - 60, height: 50))
        self.deathsLabel.textAlignment = .center
        self.deathsLabel.numberOfLines = 0
        self.deathsLabel.font = UIFont.regularFont(size: 18)
        self.deathsLabel.textColor = .white

        
        self.recoveredLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 235, width: superview!.bounds.width - 60, height: 50))
        self.recoveredLabel.textAlignment = .center
        self.recoveredLabel.numberOfLines = 0
        self.recoveredLabel.font = UIFont.regularFont(size: 18)
        self.recoveredLabel.textColor = .white

        self.providedLabel = UILabel(frame: CGRect(x: superview!.bounds.minX, y: 300, width: superview!.bounds.width - 60, height: 50))
        self.providedLabel.textAlignment = .center
        self.providedLabel.numberOfLines = 0
        self.providedLabel.font = UIFont.regularFont(size: 12)
        self.providedLabel.textColor = .gray
        
        print("Created label details")
        
        self.popupHeadingLabel.text = "Current Covid Data"
        self.confirmedCaseLabel.text = self.covidData!.confirmedCount + " confirmed cases"
        self.criticalCaseLabel.text = self.covidData!.criticalCount + " patients in critical condition"
        self.deathsLabel.text = self.covidData!.deathCount + " people died."
        self.recoveredLabel.text = self.covidData!.recoveredCount + " people recovered"
        self.providedLabel.text = "Data Provided by Johns Hopkins University"
        print("Updated label text")
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func show() {
        self.isHidden = false
    }

}
