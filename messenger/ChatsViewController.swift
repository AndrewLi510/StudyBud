//
//  ChatsViewController.swift
//  messenger
//
//  Created by Andrew Li on 3/31/19.
//  Copyright © 2019 Andrew Li. All rights reserved.
//

import UIKit

class ChatsViewController: UIViewController {
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true

        
    }
    
    //MARKS: IBActions
    @IBAction func createNewChatButtonPressed(_ sender: Any) {
        
        let userVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersTableView") as! UsersTableViewController
        
        self.navigationController?.pushViewController(userVC, animated: true)
        
    }
    
}
