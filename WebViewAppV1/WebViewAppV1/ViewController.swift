//
//  ViewController.swift
//  WebViewAppV1
//
//  Created by Robert Wong on 9/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, UITextFieldDelegate {
    var webView: WKWebView?
    
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var barView: UIView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        // Do any additional setup after loading the view, typically from a nib.
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
    
    func displayWebPage(url: String) {
        
    }

}

//    var webView: WKWebView?
//    
//    @IBOutlet weak var barView: UIView!
//    @IBOutlet weak var urlField: UITextField!
//    @IBOutlet weak var backButton: UIBarButtonItem!
//    @IBOutlet weak var forwardButton: UIBarButtonItem!
//    @IBOutlet weak var reloadButton: UIBarButtonItem!
//    
//    @IBAction func back(_ sender: UIBarButtonItem) {
//        webView?.goBack()
//    }
//    
//    @IBAction func foward(_ sender: UIBarButtonItem) {
//        webView?.goForward()
//    }
//    
//    @IBAction func reload(_ sender: UIBarButtonItem) {
//        let request = URLRequest(url:(webView?.url!)!)
//        webView?.load(request)
//    }
//    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if (keyPath == "loading") {
//            backButton.isEnabled = (webView?.canGoBack)!
//            forwardButton.isEnabled = (webView?.canGoForward)!
//        }
//    }
//    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        barView.frame = CGRect(x: 0, y: 0, width: size.height, height: 30)
//    }
//    
//    override func loadView() {
//        let webConfiguration = WKWebViewConfiguration()
//        webView = WKWebView(frame: .zero, configuration: webConfiguration)
//        webView?.uiDelegate = self
//        //view can be initalized in loadView or viewDidLoad. Don't know the difference between the two
//        view = webView
//        
//        print ("WebViewController loaded its view.")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        barView.frame = CGRect(x:0, y:0, width: view.frame.width, height: 30)
//        //webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
//        webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
//        // Do any additional setup after loading the view, typically from a nib.
//        let url = URL(string:"https://9gag.com/trending")
//        let request = URLRequest(url: url!)
//        webView!.load(request)
//        
//        backButton.isEnabled = false
//        forwardButton.isEnabled = false
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        urlField.resignFirstResponder()
//        if let unformattedURLField = urlField.text {
//            if !unformattedURLField.hasPrefix("http://") || !unformattedURLField.hasPrefix("https://") {
//                let formattedUrlField = "https://" + unformattedURLField
//                let searchURL = URL(string: formattedUrlField)
//                webView!.load(URLRequest(url: searchURL!))
//            }
//        }
//        return false
//    }

