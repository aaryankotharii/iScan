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
    let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    override func viewDidLoad() {
        super.viewDidLoad()
        sessionSetup()
        addBlur()
        print(getMaskSize())
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        outputCheck()

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
                session.addOutput(metadataOutput)
               metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               metadataOutput.metadataObjectTypes = [.qr]
           } else {
              print("failed")
            z
           }
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

//MARK:- AVCaptureMetadataOutputObjects Delegate Method
extension ViewController : AVCaptureMetadataOutputObjectsDelegate{
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let url = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            print(url)
        }
        session.stopRunning()
    }
}


