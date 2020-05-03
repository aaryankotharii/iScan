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
    
    var webView: WKWebView!
    
    var url = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let url = URL(string: self.url)
        showWebsite(url!)

    }

}

extension WebVC: WKNavigationDelegate {
    func showWebsite(_ url : URL){
        webView = WKWebView()
            
        webView.navigationDelegate = self
            
        view = webView
                               
        webView.load(URLRequest(url: url))
            
        webView.allowsBackForwardNavigationGestures = true
    }
}
