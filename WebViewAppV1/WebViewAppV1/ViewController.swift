//
//  ViewController.swift
//  WebViewAppV1
//
//  Created by Robert Wong on 9/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate, WKNavigationDelegate {
    var webView: WKWebView?
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        webView?.goBack()
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        webView?.goForward()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        let request = URLRequest(url: (webView?.url)!)
        webView!.load(request)
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        // Do any additional setup after loading the view, typically from a nib.
        webView?.navigationDelegate = self as WKNavigationDelegate
        let url = URL(string:"https://en.wikipedia.org/wiki/Main_Page")
        let request = URLRequest(url: url!)
        webView!.load(request)
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        barView.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        if let unformattedURLField = urlField.text, !unformattedURLField.isEmpty
        {
            if !unformattedURLField.hasPrefix("http://") || !unformattedURLField.hasPrefix("https://") {
                let formattedUrlField = "https://" + unformattedURLField
                let searchURL = URL(string: formattedUrlField)
                webView!.load(URLRequest(url: searchURL!))
            }
            let searchURL = URL(string: unformattedURLField)
            webView!.load(URLRequest(url: searchURL!))
        }
        return false
    }

}
