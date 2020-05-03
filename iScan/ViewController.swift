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
    
    let session: AVCaptureSession = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        sessionSetup()
        addBlur()
        // Do any additional setup after loading the view.
    }
    
    func sessionSetup(){
        guard let device = AVCaptureDevice.default(for: .video ) else  { return }
        
        session.sessionPreset = AVCaptureSession.Preset.high
        
        do {   try session.addInput(AVCaptureDeviceInput(device: device))   }
        catch {  print(error.localizedDescription)  }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.layer.bounds
        self.view.layer.addSublayer(previewLayer)
    }
    
    func addBlur(){
        let blur = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurView)
    }
    
}

