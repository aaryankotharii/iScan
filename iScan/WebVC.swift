//
//  WebVC.swift
//  iScan
//
//  Created by Aaryan Kothari on 03/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import WebKit


class WebVC: UIViewController {
    
    @IBOutlet var errorImage: UIImageView!
    
    var webView: WKWebView!
    
    var url = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        errorImage.isHidden = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if urlChecker(self.url){
        let url = URL(string: self.url)!
        showWebsite(url)
        }
        else{
            errorImage.isHidden = false
            print("INVALID")
        }

    }
    
  func urlChecker (_ urlString: String) -> Bool {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        return false
    }
}

extension WebVC: WKNavigationDelegate {
    func showWebsite(_ url : URL){
        print("FUNC called")
        webView = WKWebView()
            
        webView.navigationDelegate = self
            
        view = webView
                               
        webView.load(URLRequest(url: url))
            
        webView.allowsBackForwardNavigationGestures = true
    }
}
