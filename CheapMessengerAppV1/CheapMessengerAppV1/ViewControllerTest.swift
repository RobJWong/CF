//
//  ViewControllerTest.swift
//  
//
//  Created by Robert Wong on 10/2/17.
//

import UIKit
import FirebaseDatabase
import Firebase

class ViewControllerTest: UIViewController {
    
    private var chatUsers = [ChatUser]()
    private var selectedChatUsers = [ChatUser]()
    private var userId = AuthenticationManager.sharedInstance.userId!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
