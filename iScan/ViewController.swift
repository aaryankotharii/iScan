//
//  ViewController.swift
//  iScan
//
//  Created by Aaryan Kothari on 03/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session: AVCaptureSession = AVCaptureSession()
    let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        outputCheck()
        sessionSetup()
        addBlur()
        
        // Do any additional setup after loading the view.
    }
    
    func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video ) else  { print("input fail"); return }
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        do {   try session.addInput(AVCaptureDeviceInput(device: device))   }
        catch {  print(error.localizedDescription)  }
        
 
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    func outputCheck() {
        
        //MARK: Check output
        if session.canAddOutput(metadataOutput) {
               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               session.addOutput(metadataOutput)
               metadataOutput.metadataObjectTypes = [.qr]
           } else {
              print("failed")
           }
    }
    
    func addBlur(){
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        let scanLayer = CAShapeLayer()
        
        let outerPath = UIBezierPath(roundedRect: CGRect(x: 57, y: 298, width: 300, height: 300),
                                     cornerRadius: 30)
        
        let superlayerPath = UIBezierPath.init(rect: blurView.frame)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = .evenOdd
        scanLayer.fillColor = UIColor.black.cgColor
        
        
        view.addSubview(blurView)
        blurView.layer.mask = scanLayer
    }
    
}

