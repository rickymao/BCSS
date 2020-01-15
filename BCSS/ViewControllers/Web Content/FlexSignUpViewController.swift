//
//  FlexSignUpViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2019-10-23.
//  Copyright © 2019 Ricky Mao. All rights reserved.
//

import UIKit
import WebKit

class FlexSignUpViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
            //UI SETUP
               
            //Setting nav-bar color
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]
        
        //Setting back button to arrow
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        
              //NETWORK SETUP
               let wifiChecker = NetworkController();

               //Checks for internet connection
               if !wifiChecker.checkWiFi() {

                   let internetAlert = UIAlertController(title: "No Connection", message: "Please connect to WiFi to sign up for flex time", preferredStyle: UIAlertController.Style.alert)

                   let findNetworkAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default)

                   internetAlert.addAction(findNetworkAction)

                   present(internetAlert, animated: true, completion: nil)


               
    }
        
        

        //Loads PDF
        pdfLoad.navigationDelegate = self
        let request = URLRequest.init(url: url!)
        pdfLoad.load(request)
        
        pdfLoad.allowsBackForwardNavigationGestures = true;
                          
        //Animating loading icon
        if pdfLoad.isLoading {
           loadingIcon.startAnimating()
           loadingIcon.isHidden = false
        
        }

    

}
    //VARIABLES
    let url = URL.init(string: "http://central.myweeklyplanner.net/")
    
    override func viewWillAppear(_ animated: Bool) {
        
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
    
    //Website functions
    @IBAction func back(_ sender: Any) {
        pdfLoad.goBack()
    }
    @IBAction func refresh(_ sender: Any) {
        if pdfLoad.url != nil {
            pdfLoad.reloadFromOrigin()
        } else {
            let request = URLRequest.init(url: url!)
            pdfLoad.load(request)
        }
        
    }
    
    @IBAction func forward(_ sender: Any) {
        pdfLoad.goForward();
    }
}
