//
//  ViewController.swift
//  iScan
//
//  Created by Aaryan Kothari on 03/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    
    //MARK: Variables
    let session: AVCaptureSession = AVCaptureSession()
    let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()
    var success : Bool = true
    var label : UILabel!
    var image: UIImageView!

    
    //MARK:- VC lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true /// Hide Nav bar
        //MARK: Add respective components
        sessionSetup()
        addBlur()
        addLabel()
        addCorners()
    }
    
    //MARK: Methods for when view appears
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        outputCheck()
        runSession()
        self.label.text = "Find a code to scan"
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: Setup camera session
    func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video ) else  { errorAlert("camera missing") ; return } /// Check camera
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        do {   try session.addInput(AVCaptureDeviceInput(device: device))   }
        catch {  errorAlert(error.localizedDescription) }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        session.startRunning() /// Start session
    }
    
    //MARK: Check for if camera video can be displayed
    func outputCheck(){
        
        //MARK: Check output
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            //errorAlert("Cannot display camera output")
        }
    }
    
    //MARK:- Add Blur with custom mask
    func addBlur(){
        //MARK: Add Blur view
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let scanLayer = CAShapeLayer()
        let maskSize = getMaskSize()
        let outerPath = UIBezierPath(roundedRect: maskSize, cornerRadius: 30)
        
        //MARK: Add Mask
        let superlayerPath = UIBezierPath(rect: blurView.frame)
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = .evenOdd
        
        view.addSubview(blurView) /// FInal blur layer
        blurView.layer.mask = scanLayer
    }
    
    // Get mask size respect to screen size
    private func getMaskSize() -> CGRect {
        let viewWidth = view.frame.width
        let rectwidth = viewWidth - 114
        let halfWidth = rectwidth/2
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        return CGRect(x: x, y: y, width: rectwidth, height: rectwidth)
    }
    
    //MARK: Instantiate VC
    func goToWebsite(_ url : String){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "WebVC") as! WebVC
        vc.url = url
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //Return to session
    private func runSession(){
        if !session.isRunning{
            session.startRunning()
        }
    }
    
    //MARK: Add disclaimer label
    func addLabel(){
        let lableDimension = (92/896)*view.frame.height
        label = UILabel(frame: CGRect(x: 0, y: 0, width: lableDimension+100, height: lableDimension))
        label.center = CGPoint(x: view.center.x, y: 100)
        label.textAlignment = .center
        label.text = "Find a code to scan"
        label.font = label.font.withSize(20)
        label.textColor = .white
        label.clipsToBounds = true
        label.layer.cornerRadius = (46/896)*view.frame.height
        view.addSubview(label)
    }
    
    func addCorners(){
        let maskSize = getMaskSize().height
        let imageWidth = maskSize * 1.0866666667
        let halfWidth = (imageWidth) / 2
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        let imageFrame = CGRect(x: x, y: y, width: imageWidth, height: imageWidth)
        image = UIImageView()
        image.frame = imageFrame
        image.image = UIImage(named: "corners")
        print(imageFrame)
        view.addSubview(image)
        animateCorner()
        
    }
    
    func animateCorner(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
         animation.duration=2
         animation.timingFunction=CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeOut)
         animation.autoreverses=true
        image.layer.add(animation, forKey:"animate")
    }
    
    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { print("Torch isn't available"); return }

        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            // Optional thing you may want when the torch it's on, is to manipulate the level of the torch
            if on { try device.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel.significand) }
            device.unlockForConfiguration()
        } catch {
            print("Torch can't be used")
        }
    }
}

//MARK:- AVCaptureMetadataOutputObjects Delegate Method
extension ViewController : AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let url = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            SuccessAlert(url)
            self.label.text = "✅"
        }
        session.stopRunning()
    }
}

//MARK:- Alert Functions
extension ViewController {
    public func SuccessAlert(_ message : String){
        let ALert = UIAlertController(title: "Heres Your result 😉", message: message, preferredStyle: .alert)
        let goAction = UIAlertAction(title: "Go to page", style: .default) { (UIAlertAction) in
            self.goToWebsite(message)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)  { (UIAlertAction) in
            self.session.startRunning()
            self.label.text = "Find a code to scan"
        }
        ALert.addAction(cancelAction)
        ALert.addAction(goAction)
        self.present(ALert,animated: true)
    }
    
    public func errorAlert(_ message: String){
        let aLert = UIAlertController(title: "Uh oh! 😕", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "return", style: .default, handler: nil)
        aLert.addAction(action)
        self.present(aLert,animated: true)
    }
}

