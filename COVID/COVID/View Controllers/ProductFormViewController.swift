//
//  ProductFormViewController.swift
//  COVID
//
//  Created by Rastaar Haghi on 4/10/20.
//  Copyright © 2020 Rastaar Haghi. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import CoreLocation
import AVFoundation
import Vision
import Combine
import SnapKit
import Firebase
import FirebaseFirestore
import CodableFirebase

// a form that will allow user to select essential item, take a picture as proof, and use CoreML to process if a legitimate product
class ProductFormViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var itemList = ["Face Masks", "Gloves", "Hand Sanitizer", "Soap", "Toilet Paper"]
    var selectedItem: String?
    
    var itemLabel: UILabel!
    @IBOutlet var itemField: UITextField!
    
    var storeLabel: UILabel!
    @IBOutlet var storeTextField: UITextField!
    
    var quantityLabel: UILabel!
    @IBOutlet var quantityTextField: UITextField!
    
    var mainLabel: UILabel!
    @IBOutlet var productName: String!
    var locationManager: CLLocationManager!
    var imageSelected: UIImage!
    
    //var verifyLabel: UILabel!
    var uploadImageButton: UIButton!
    

    override func viewDidLoad() {
        overrideUserInterfaceStyle = .light
        mainLabelInit()
        setupLocation()
        
        self.view.backgroundColor = UIColor(white: 247.0/255.0, alpha: 1)
        
        itemLabel = customizedLabel(text: "What essential item did you find?", size: 24, yPos: 100)
        view.addSubview(itemLabel)
        itemField = customizedTextField(yPos: 150)
        view.addSubview(itemField)
        
        
        storeLabel = customizedLabel(text: "What store are you in?", size: 24, yPos: 225)
        view.addSubview(storeLabel)
        storeTextField = customizedTextField(yPos: 275)
        storeTextField.placeholder = "What was the name of the store?"
        view.addSubview(storeTextField)
        
        
        quantityLabel = customizedLabel(text: "How many did you see in stock?", size: 24, yPos: 350)
        view.addSubview(quantityLabel)
        quantityTextField = customizedTextField(yPos: 400)
        quantityTextField.placeholder = "How many did you see?"
        quantityTextField.keyboardType = .numberPad
        view.addSubview(quantityTextField)
        
        //verifyLabel = customizedLabel(text: "Sub", size: 24, yPos: 475)
        //view.addSubview(verifyLabel)
        imageButtonInit()

        createPickerView()
        dismissPickerView()
        print("Loaded the product page")
    }

    func customizedTextField(yPos: CGFloat) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 30, y: yPos, width: view.bounds.maxX - 60, height: 50))
        textField.font = UIFont.regularFont(size: 18)
        textField.textColor = .white
        textField.textAlignment = .left
        textField.layer.cornerRadius = 15
        textField.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        return textField
    }
    
    func customizedLabel(text: String, size: CGFloat, yPos: CGFloat) -> UILabel {
        let textLabel = UILabel(frame: CGRect(x: 30, y: yPos, width: view.bounds.maxX - 60, height: 50))
        textLabel.text = text
        textLabel.textAlignment = .left
        textLabel.font = UIFont.regularFont(size: size)
        textLabel.numberOfLines = 0
        return textLabel
    }
    
    func setupLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        print("Location Setup Complete!")
    }
    
    // opens image picker, where user can take a picture
    @objc func takePicture() {
        print("Take Picture Called")
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
        submitForm()
    }
    
    @objc func submitForm() {
        // if all required entries present
        if(itemField.hasText && storeTextField.hasText && quantityTextField.hasText) {
            let model = FormResponse(product: selectedItem ?? "", storeName: storeTextField.text ?? "", quantity: quantityTextField.text ?? "", xCoord: (locationManager.location?.coordinate.latitude)!, yCoord: (locationManager.location?.coordinate.longitude)!)
            print(model)
            //let db = Firestore.firestore()
            //db.collection("items").addDocument(data: model.dictionary)
            Firestore.firestore().collection("items").addDocument(data: model.dictionary)
        } else {
            print("Couldn't submit form because one of the required fields was left blank")
        }
    }
    
    func imageButtonInit() {
        self.uploadImageButton = UIButton()
        self.uploadImageButton.setTitle("Submit Form", for: .normal)
        self.uploadImageButton.setButton()
        self.uploadImageButton.frame = CGRect(x: UIScreen.main.bounds.midX - 100, y: view.bounds.height - 200, width: 200, height: 50)
        self.uploadImageButton.titleLabel!.font = UIFont.regularFont(size: 24)
        self.uploadImageButton.backgroundColor = UIColor(red: 0.130, green: 0.130, blue: 0.130, alpha: 0.9)
        self.uploadImageButton.addTarget(self, action: #selector(submitForm), for: .touchUpInside)
        view.addSubview(uploadImageButton)
        print("Upload button created")
    }
    
    func mainLabelInit() {
        mainLabel = UILabel(frame: CGRect(x: 0, y: 15, width: UIScreen.main.bounds.width, height: 75))
        mainLabel.text = "Share Product Info"
        mainLabel.textAlignment = .center
        mainLabel.font = UIFont.regularFont(size: 40)
        mainLabel.numberOfLines = 0
        view.addSubview(mainLabel)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.imageSelected = image

        // print out the image size as a test
        print(image.size)
    }
}

// for the selector
extension ProductFormViewController {

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
        itemField.text = selectedItem
    }
    
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        itemField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        itemField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
       view.endEditing(true)
        if(self.selectedItem != nil && self.selectedItem != "") {
            print(self.selectedItem!)
        }
    }
}
