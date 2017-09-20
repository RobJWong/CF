//
//  ViewController.swift
//  WebViewAppV1
//
//  Created by Robert Wong on 9/18/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView?
    
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
        // Do any additional setup after loading the view, typically from a nib.
        webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        let url = URL(string:"https://en.wikipedia.org/wiki/Main_Page")
        let request = URLRequest(url: url!)
        webView!.load(request)
        
        backButton.isEnabled = false
        forwardButton.isEnabled = false
    }
    
}
