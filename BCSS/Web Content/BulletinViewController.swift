//
//  BulletinViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-25.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import WebKit

class BulletinViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    override func viewDidLoad() {
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        
        let url = URL.init(string: "https://drive.google.com/file/d/1TjV_YIf7Ee3f1wruCAbPqjHpIebMoYZb/view")
        let bulletinRequest = URLRequest.init(url: url!)
        
        let wifiChecker = Network();
        
        if !wifiChecker.checkWiFi() {
            
            let internetAlert = UIAlertController(title: "No Connection", message: "Please connect to WiFi to update the bulletin", preferredStyle: UIAlertController.Style.alert)
            
            let findNetworkAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)
            
            internetAlert.addAction(findNetworkAction)
            
            present(internetAlert, animated: true, completion: nil)
            
            
        }
        
        
        bulletinLoad.navigationDelegate = self
        bulletinLoad.load(bulletinRequest)
        
        if bulletinLoad.isLoading {
            loadingIcon.startAnimating()
            loadingIcon.isHidden = false
        }
        
       

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        

        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var bulletinLoad: WKWebView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIcon.stopAnimating()
        loadingIcon.isHidden = true
    }
    
    
}
