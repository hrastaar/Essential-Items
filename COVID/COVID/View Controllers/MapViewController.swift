//
//  MapViewController.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/9/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import CoreLocation
import SwiftUI
import SnapKit
import Firebase

class MapViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var locationManager: CLLocationManager!
    var mapView: MKMapView?
    
    var mainLabel: UILabel!
    @IBOutlet var showPopoverButton: UIButton!
    @IBOutlet var dismissPopoverButton: UIButton!
    @IBOutlet var trackingBtn: UIButton!
    @IBOutlet var addBtn: UIButton!
    @IBOutlet var popupHeadingLabel: UILabel!
    @IBOutlet var confirmedCaseLabel: UILabel!
    @IBOutlet var criticalCaseLabel: UILabel!
    @IBOutlet var deathsLabel: UILabel!
    @IBOutlet var recoveredLabel: UILabel!
    var popoverView: CovidPopupView!
    
    var itemList = ["Face Masks", "Gloves", "Hand Sanitizer", "Soap", "Toilet Paper"]
    var selectedItem: String?
    @IBOutlet var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        mainLabel = UILabel(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: 75))
        mainLabel.text = "Essential Item Tracker"
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.regularFont(size: 40)
        mainLabel.numberOfLines = 0
        view.addSubview(mainLabel)
        // set up ui-picker
        textField = UITextField(frame: CGRect(x: self.view.center.x, y: view.bounds.maxY/4, width: 300, height: 50))
        createPickerView()
        dismissPickerView()
        locationSetup()
        // set up map view
        mapView = MKMapView(frame: UIScreen.main.bounds)
        mapSetup()
        view.addSubview(mapView!)
        view.sendSubviewToBack(mapView!)
        
        popoverView = CovidPopupView()
        view.addSubview(popoverView)
        popoverView.hide()
        popoverView.designPopup()
        
        showPopoverButton = UIButton(type: .custom)
        showPopoverButton.setButton()
        showPopoverButton.setTitle("Show Covid-19 Data", for: .normal)
        showPopoverButton.addTarget(self, action: #selector(showPopup), for: .touchUpInside)

        dismissPopoverButton = UIButton(type: .custom)
        dismissPopoverButton.setButton()
        dismissPopoverButton.setTitle("Exit", for: .normal)
        dismissPopoverButton.addTarget(self, action: #selector(hidePopup), for: .touchUpInside)
        dismissPopoverButton.isHidden = true
        
        trackingBtn = UIButton(type: .custom)
        trackingBtn.setImage(UIImage(systemName: "location"), for: .normal)
        trackingBtn.addTarget(self, action: #selector(centerMap), for: .touchUpInside)
        view.addSubview(trackingBtn)
        
        addBtn = UIButton(type: .custom)
        addBtn.setButton()
        addBtn.setTitle("Add", for: .normal)
        addBtn.addTarget(self, action: #selector(showForm), for: .touchUpInside)
        view.addSubview(addBtn)
        
        view.addSubview(showPopoverButton)
        view.addSubview(dismissPopoverButton)
        view.bringSubviewToFront(showPopoverButton)
        setupTextField()
        setButtonLayout()
    }
    
    // configures map settings
    func mapSetup() {
        self.mapView?.showsUserLocation = true
        self.mapView?.showsTraffic = true
        self.mapView?.showsBuildings = true
        self.mapView?.showsCompass = true
        centerMap()
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
            self.mapView?.camera = MKMapCamera(lookingAtCenter: self.locationManager.location!.coordinate, fromEyeCoordinate: self.locationManager.location!.coordinate, eyeAltitude: 5000)
            print("Map Configured!")
        } else {
            print("Couldn't complete map configuration because system hasn't shared location with app. Please go to system settings.")
        }
    }
    
    @objc func showPoints(item: String) {
        clearPointsOnMap()
        Firestore.firestore().collection("items").getDocuments { (snapshot, error) in
            if error == nil && snapshot != nil {
                for document in snapshot!.documents {
                    let documentData = document.data()
                    self.addPointToMap(latitude: documentData["xCoord"] as! Double, longitude: documentData["yCoord"] as! Double, storeName: documentData["storeName"] as! String, productName: documentData["product"] as! String, quantity: documentData["quantity"] as! String)
                }
            }
        }
    }
    
    // add points to the map from our API
    func addPointToMap(latitude: Double, longitude: Double, storeName: String, productName: String, quantity: String) {
        let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = storeName
            annotation.subtitle = productName + ", Quantity: \(quantity)"

        self.mapView?.addAnnotation(annotation)
        print("Point added at latitude: \(latitude), longitude: \(longitude)")
    }
    
    func clearPointsOnMap() {
        for point in self.mapView!.annotations {
            self.mapView?.removeAnnotation(point)
        }
        print("Removed annotations from map")
    }
    
    func locationSetup() {
        // set location manager data
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        print("Location Setup Complete!")
    }
    
    @objc func showForm() {
        self.showDetailViewController(ProductFormViewController.init(), sender: self)
    }
    
    // update the view to the center
    @objc func centerMap() {
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
           // update the map
            mapView?.setCenter(locationManager.location!.coordinate, animated: true)
           print("Map has been centered to user location")
        } else {
            print("Couldn't recenter because user didn't grant this app location access. Please go to system settings.")
        }
    }

    @objc func showPopup(_ sender: UIButton){
        self.dismissPopoverButton.isHidden = false
        self.showPopoverButton.isHidden = true

        UIView.animate(withDuration: 0.2, animations: {
            self.popoverView.frame = CGRect(x: self.view.center.x, y: self.view.center.y, width: 300, height: 300)
            self.popoverView.center = self.view.center
            self.popoverView.alpha = 1
            self.popoverView.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.8)
        },
            completion: {(value: Bool) in
                self.popoverView.show()
        })
    }
    
    @objc func hidePopup(){
        self.dismissPopoverButton.isHidden = true
        self.showPopoverButton.isHidden = false
        self.popoverView.hide()
    }
    
    func setButtonLayout() {
        self.showPopoverButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(5/6))
            make.left.equalTo(view).offset(100)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-100)
        }
        
        self.dismissPopoverButton.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(5/6))
            make.left.equalTo(view).offset(100)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-100)
        }
        self.trackingBtn.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(5/6))
            make.left.equalTo(view).offset(UIScreen.main.bounds.maxX - 75)
            make.bottom.equalTo(view).offset(-20)
            make.right.equalTo(view).offset(-25)
        }
        self.addBtn.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(1/6)-25)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10+(-2*UIScreen.main.bounds.maxX)/3)
            make.bottom.equalTo(view).offset(-UIScreen.main.bounds.maxY*(2/3)-25)
        }
    }
    
    func setupTextField() {
        // add to the main UIView
        view.addSubview(textField)
        view.bringSubviewToFront(textField)
        textField.textAlignment = .center
        textField.font = UIFont.regularFont(size: 20)
        // make some constraints
        self.textField.snp.makeConstraints{ (make) -> Void in
            make.top.equalTo(view).offset(UIScreen.main.bounds.maxY*(1/6)-25)
            make.left.equalTo(view).offset(UIScreen.main.bounds.maxX/3)
            make.bottom.equalTo(view).offset(-UIScreen.main.bounds.maxY*(2/3)-25)
            make.right.equalTo(view).offset(-10)
        }
        self.textField.layer.cornerRadius = 20.0
        self.textField.text = "Find an Essential Item"
        self.textField.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        self.textField.textColor = .white
        
    }
    
}

extension UIButton {
    func setButton() {
        self.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.85)
        self.titleLabel!.font = UIFont.regularFont(size: 18)
        self.layer.cornerRadius = 15
        self.setTitleColor(.white, for: .normal)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension MapViewController {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemList[row]
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = itemList[row]
        textField.text = selectedItem
        showPoints(item: selectedItem!)
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        textField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
       view.endEditing(true)
        if(self.selectedItem != nil && self.selectedItem != "") {
            print(self.selectedItem!)
        }
    }
}
