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
        //urlField.text = String(describing: (webView?.url)!)
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        webView?.goForward()
        //urlField.text = String(describing: (webView?.url)!)
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        let request = URLRequest(url: (webView?.url)!)
        print(request)
        print("Reloading Page")
        webView!.load(request)
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView!
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "loading") {
            backButton.isEnabled = (webView?.canGoBack)!
            forwardButton.isEnabled = (webView?.canGoForward)!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barView.frame = CGRect(x:0, y: 0, width: view.frame.width, height: 30)
        webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        // Do any additional setup after loading the view, typically from a nib.
        webView?.navigationDelegate = self as WKNavigationDelegate
        let url = URL(string:"https://en.wikipedia.org/wiki/Main_Page")
        let request = URLRequest(url: url!)
        webView!.load(request)
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        barView.frame = CGRect(x:0, y: 0, width: size.width, height: 30)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlField.resignFirstResponder()
        if let unformattedURLField = urlField.text, !unformattedURLField.isEmpty
        {
            if let validURL: NSURL = NSURL(string: unformattedURLField)
            {
                if UIApplication.shared.canOpenURL(validURL as URL) {
                    webView!.load(URLRequest(url: validURL as URL))
                }
                let testURL = "https://" + String(describing: validURL)
                webView!.load(URLRequest(url: NSURL(string: testURL) as! URL))
            }
        }
        return false
    }
    
    //            if !unformattedURLField.hasPrefix("http://") || !unformattedURLField.hasPrefix("https://") {
    //                let formattedUrlField = "http://" + unformattedURLField
    //                let searchURL = URL(string: formattedUrlField)
    //                if UIApplication.shared.canOpenURL(searchURL!) {
    //                    webView!.load(URLRequest(url: searchURL!))
    //                } else {
    //                    invalidURL()
    //                }
    //            }
    //            let searchURL = URL(string: unformattedURLField)
    //            if UIApplication.shared.canOpenURL(searchURL!) {
    //                webView!.load(URLRequest(url: searchURL!))
    //            }
    //            else {
    //                invalidURL()
    //            }
    
    func invalidURL() {
        let alertController = UIAlertController(title: "Error", message: ("Invalid URL"), preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

