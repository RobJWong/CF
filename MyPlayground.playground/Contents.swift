//: Playground - noun: a place where people can play

import UIKit

let fileManager = FileManager.default

do {
    let documents = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
    
    let url = URL(string: "test_document.txt", relativeTo: documents)
    print(documents)
    let stringToWrite = "This is the string to save to the file"
    if let url = url {
        try
            stringToWrite.write(to: url, atomically: true, encoding: String.Encoding.utf8)
        let textFromFile = try String(contentsOf: url)
    }
} catch {
    print("Error getting path")
}

if let image = UIImage(named: "career-foundry-logo.jpg") {
    let imageData = UIImageJPEGRepresentation(image, 1.0)
    do {
        let documents = try fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask, appropriateFor: nil, create: false)
        
        let url = URL(string: "logo.jpg", relativeTo: documents)
        try imageData?.write(to: url!, options: [.atomic])
        let logo = try Data(contentsOf: url!)
        let logoImage = UIImage(data: logo)
    } catch {
        print("Error writing to file")
    }
}
