//
//  ViewController.swift
//  InfoController
//
//  Created by Rana Eltahir on 4/13/20.
//  Copyright © 2020 Rana Eltahir. All rights reserved.
//

import UIKit
import AVFoundation
class InfoViewController: UIViewController, UINavigationBarDelegate, UIPickerViewDelegate,UIPickerViewDataSource,AVCapturePhotoCaptureDelegate {
    // UIPicker (with options like “Face Masks”, “Gloves”, “Hand Sanitizer”, etc.)
    // a textfield for store name, a text field for quantity
    // a camera view where they take a picture (not accessing photo library, just camera)
    // and a submit button with a target function that makes an http request
    let dataArray = ["Face Masks", "Gloves", "Hand Sanitizer"]
    var navigationBar = UINavigationBar()
    var UIPicker = UIPickerView()
    var storeNameTxtField = UITextField()
    var slider = UISlider()
    var myView = UIView()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var captureImageView = UIImageView()
    var label = UILabel()
    var quanlabel = UILabel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()

            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
    }
    
    @objc func selectorX() {
           print("here send data to database")
        
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        myView.layer.addSublayer(videoPreviewLayer)
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            self.videoPreviewLayer.frame = self.myView.bounds
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = dataArray[row]
       return row
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIPicker.delegate = self as UIPickerViewDelegate
        UIPicker.dataSource = self as UIPickerViewDataSource
        navigationBar.delegate = self;
        // Do any additional setup after loading the view.
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        Label()
        textfields()
        picker()
        camera()
        Slider()
        
        navBar()
        view.addSubview(UIPicker)
        view.addSubview(storeNameTxtField)
        view.addSubview(slider)
        view.addSubview(myView)
        view.addSubview(navigationBar)
    }
    
    func Label()
    {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 190, y: 270)
        label.textAlignment = .center
        label.text = "quantity:"
        self.view.addSubview(label)
        
        quanlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        quanlabel.center = CGPoint(x: 240, y: 270)
        quanlabel.textAlignment = .center
        quanlabel.text = "\(Int(slider.value))"
        self.view.addSubview(quanlabel)
    }
    
    func camera(){
        myView.frame = CGRect(x:0, y:  self.view.frame.size.height/2 - 100, width: self.view.frame.size.width, height: self.view.frame.size.height/2 + 100)
        
        let cameraView = UIView()
        cameraView.frame = CGRect(x: 0, y: 0, width: Int(myView.frame.size.width), height: Int(myView.frame.size.height) * 6/10)
        
        let button = UIButton(frame: CGRect(x: 30, y: Int(myView.frame.size.height) * 3/4 , width: 100, height: 50))
        button.setTitle("Take Photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        captureImageView.frame = CGRect(x: Int(myView.frame.size.width)/2, y: Int(myView.frame.size.height) * 6/10, width: Int(myView.frame.size.width)/2, height: Int(myView.frame.size.height) * 4/10)
        myView.addSubview(button)
        myView.addSubview(captureImageView)
        myView.addSubview(cameraView)
    }
    
    @objc func buttonAction(sender: UIButton!) {
      let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
      stillImageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let image = UIImage(data: imageData)
        captureImageView.image = image
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func Slider(){
        slider = UISlider()
        slider.frame = CGRect(x: 80, y: 285, width: 250, height: 35)

        slider.minimumTrackTintColor = .black
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = .black

        slider.maximumValue = 100
        slider.minimumValue = 0
        slider.setValue(50, animated: false)

        slider.addTarget(self, action: #selector(ViewController.changeVlaue(_:)), for: .valueChanged)
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        quanlabel.text = "\(Int(slider.value))"
    }
    
    func textfields(){
        // Create UITextField
        storeNameTxtField = UITextField(frame: CGRect(x: 60, y: 210, width: 300.00, height: 30.00));
         // Or you can position UITextField in the center of the view
        //storeNameTxtField.center = self.view.center
               
        // Set UITextField placeholder text
        storeNameTxtField.placeholder = "Store Name"
               
        // Set UITextField border style
        storeNameTxtField.borderStyle = UITextField.BorderStyle.line
               
        // Set UITextField background colour
        storeNameTxtField.backgroundColor = UIColor.white
               
        // Set UITextField text color
        storeNameTxtField.textColor = UIColor.blue
    }
    
    func picker(){
       // UIPicker = UIPickerView(frame: CGRect(x: 0, y: 140, width: self.view.frame.size.width, height: 300))
        UIPicker.frame = CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 200)
        //UIPicker.center = self.view.center
    }
    
    func navBar(){
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: 44)) // Offset by 20 pixels vertically to take the status bar into account

        navigationBar.backgroundColor = UIColor.white
        let navItem = UINavigationItem(title: "")
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: nil, action: #selector(selectorX))
        navItem.rightBarButtonItem = doneItem
        navigationBar.setItems([navItem], animated: false)
        
    }

}

