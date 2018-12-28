//
//  MenuViewController.swift
//  BCSS
//
//  Created by Ricky Mao on 2018-08-25.
//  Copyright © 2018 Treeline. All rights reserved.
//

import UIKit
import WebKit

class MenuViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 0.612, green: 0.137, blue: 0.157, alpha: 100)]

        // Do any additional setup after loading the view.
        let url = URL.init(string: "https://drive.google.com/file/d/1IRaX06h6-rAC8CpVU2W2WnILxAAg-Qh7/view")
        pdfLoad.navigationDelegate = self
        let menuRequest = URLRequest.init(url: url!)
        pdfLoad.load(menuRequest)
        
        if pdfLoad.isLoading {
            loadingIcon.startAnimating()
            loadingIcon.isHidden = false
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        pdfLoad.stopLoading()
    }
    
    deinit {
        print("deinitialized")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIcon.stopAnimating()
        loadingIcon.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var pdfLoad: WKWebView!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
}
