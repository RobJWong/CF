//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Robert Wong on 2/3/18.
//  Copyright © 2018 CareerFoundry. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var userDefaultsKey = "LinksUserDefaultsKey"
    var userList = [ListContainer]()
    var selectedList: ListContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 1...2 {
            let list = ListContainer()
            list.title = "List \(i)"
            userList.append(list)
        }
        selectedList = userList.first
        
    }
    
    var links: Array<String> {
        get {
            let userDefaults = UserDefaults(suiteName: "group.com.careerfoundry.ShareExtDemo")
            if let links = userDefaults?.object(forKey: userDefaultsKey) as! Array<String>? {
                return links
            }
            return []
        }
        set {
            let userDefaults = UserDefaults(suiteName: "group.com.careerfoundry.ShareExtDemo")
            userDefaults?.set(newValue, forKey:userDefaultsKey)
            userDefaults?.synchronize()
        }
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        
        userDefaultsKey = "LinksUserDefaultsKey"
        if selectedList?.title == "List 2" {
            userDefaultsKey = "LinksUserDefaultsKey2"
        }
        
        let contentType = kUTTypeURL as String
        let content = extensionContext!.inputItems.first as! NSExtensionItem
        
        if let attachment = content.attachments?.first {
            if (attachment as AnyObject).hasItemConformingToTypeIdentifier(contentType) {
                (attachment as AnyObject).loadItem(forTypeIdentifier: contentType, options: nil, completionHandler: { (data, error) in
                    guard error == nil else {
                        print(error)
                        return
                    }
                    
                    let url = data as! NSURL
                    self.links.append(url.absoluteString!)
                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                })
            }
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        if let list = SLComposeSheetConfigurationItem() {
            list.title = "Selected List"
            list.value = selectedList?.title
            list.tapHandler = {
                let vc = ShareSelectViewController()
                vc.userList = self.userList
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [list]
        }
        return nil
    }

}

extension ShareViewController: ShareSelectViewControllerDelegate {
    func selected(list: ListContainer) {
        selectedList = list
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
