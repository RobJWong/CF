//
//  ActionViewController.swift
//  ActionExtension
//
//  Created by Robert Wong on 10/13/17.
//  Copyright © 2017 Robert Wong. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var defaultLanguage: String = "fr"
    
    var translationLink = "https://api-platform.systran.net/translation/text/translate?key=e1c5251c-4b1c-4808-846f-9fbd8e60a00e&source=auto&target="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var textFound = false
        for item: Any in self.extensionContext!.inputItems {
            let inputItem = item as! NSExtensionItem
            for provider: Any in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePlainText as String) {
                    itemProvider.loadItem(forTypeIdentifier: kUTTypePlainText as String, options: nil, completionHandler: { (text, error) in
                        if let text = text as? String {
                            DispatchQueue.main.async {
                                let formattedText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                                let apiURL = self.urlFormat(translationTarget: formattedText, language: self.defaultLanguage)
                                self.translate(link: apiURL)
                                
                            }
                        }
                    })
                    
                    textFound = true
                    break
                }
            }
            
            if (textFound) {
                // We only handle one snippet of text, so stop looking for more.
                break
            }
        }
    }
    
    func urlFormat(translationTarget: String, language: String) -> String {
        var urlString = translationLink + language + "&input="
        if let correctURL = translationTarget.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            urlString += correctURL
        }
        print (urlString)
        return urlString
    }
    
    func translate(link: String) {
        let url = URL(string: link)
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            DispatchQueue.main.async (execute: {
                if let error = error {
                    print("error is \(error)")
                } else {
                    self.retrieveData(jsonData: data!)
                }
            })
        }
        
        dataTask.resume()
    }
    
    func retrieveData(jsonData: Data) {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, AnyObject>
            if let output = json["outputs"] as! NSArray?{
                let translatedOutput = output[0] as! Dictionary<String, AnyObject>
                if let translation = translatedOutput["output"] {
                    self.textView.text = translation as! String
                }
            }
        } catch {
            print("Error getting response")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
