//
//  MenuViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-25.
//  Copyright © 2018 Ricky Mao. All rights reserved.
//

import UIKit
import WebKit

class MenuViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI SETUP
        
        //Setting nav-bar color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        let wifiChecker = NetworkController();
        
        //NETWORK SETUP

        //Check for user's internet collection
        if !wifiChecker.checkWiFi() {

            let internetAlert = UIAlertController(title: "No Connection", message: "Please connect to WiFi to update the menu", preferredStyle: UIAlertController.Style.alert)

            let findNetworkAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)

            internetAlert.addAction(findNetworkAction)

            present(internetAlert, animated: true, completion: nil)


        }

        //Loading content from URL
        let url = URL.init(string: "https://drive.google.com/file/d/1IRaX06h6-rAC8CpVU2W2WnILxAAg-Qh7/view")
        pdfLoad.navigationDelegate = self
        let menuRequest = URLRequest.init(url: url!)
        pdfLoad.load(menuRequest)
        
        //Animating loading icon
        if pdfLoad.isLoading {
            loadingIcon.startAnimating()
            loadingIcon.isHidden = false
        }
       
    }
    
    
    //VARIABLES
    let url = URL.init(string: "https://drive.google.com/file/d/1IRaX06h6-rAC8CpVU2W2WnILxAAg-Qh7/view")
    
    deinit {
        print("deinitialized")
    }
    
    //Check when loading finishes
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIcon.stopAnimating()
        loadingIcon.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //OUTLETS
    @IBOutlet weak var pdfLoad: WKWebView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
}
