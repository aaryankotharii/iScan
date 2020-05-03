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
        print(getMaskSize())
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
//        if session.canAddOutput(metadataOutput) {
//               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
//               session.addOutput(metadataOutput)
//               metadataOutput.metadataObjectTypes = [.qr]
//           } else {
//              print("failed")
//           }
    }
    
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
        
        view.addSubview(blurView)
        blurView.layer.mask = scanLayer
    }
    
    private func getMaskSize() -> CGRect {
        let viewWidth = view.frame.width
        let rectwidth = viewWidth - 114
        let halfWidth = rectwidth/2
        let x = view.center.x - halfWidth
        let y = view.center.y - halfWidth
        return CGRect(x: x, y: y, width: rectwidth, height: rectwidth)
    }
    
}

