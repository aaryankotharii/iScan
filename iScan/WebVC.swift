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
        showWebsite()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WebVC: WKNavigationDelegate {
    func showWebsite(){
        webView = WKWebView()
            
        webView.navigationDelegate = self
            
        view = webView
                   
        let url = URL(string: self.url)!
            
        webView.load(URLRequest(url: url))
            
        webView.allowsBackForwardNavigationGestures = true
    }
}
