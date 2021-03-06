//
//  UsersTableViewController.swift
//  messenger
//
//  Created by Andrew Li on 3/31/19.
//  Copyright © 2019 Andrew Li. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class UsersTableViewController: UITableViewController, UISearchResultsUpdating {

    

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var filterSegmentedControl: UISegmentedControl!
    
    var allUsers: [FUser] = []
    var filteredUsers: [FUser] = []
    var allUsersGroup = NSDictionary() as! [String: [FUser]]
    var sectionTitleList : [String] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
        override func viewDidLoad() {
            
        super.viewDidLoad()
            self.title = "Users"
            navigationItem.largeTitleDisplayMode = .never
            tableView.tableFooterView = UIView()
            
            navigationItem.searchController = searchController
            
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
            
            loadUsers(filter: kCITY)
            
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchController.isActive && searchController.searchBar.text != ""{
            return 1
        }else{
            return allUsersGroup.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            return filteredUsers.count
            
        }else{
            
            //find section title
            let sectionTitle = self.sectionTitleList[section]
            //user for given title
            let user = self.allUsersGroup[sectionTitle]
            return user!.count
            
            }
        }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UserTableViewCell
        
        var user: FUser
        
        if searchController.isActive && searchController.searchBar.text != ""{
            user = filteredUsers[indexPath.row]
        }else{
            let sectionTitle = self.sectionTitleList[indexPath.row]
            
            let users = self.allUsersGroup[sectionTitle]
            
            user = users![indexPath.row]
            }

        
        cell.generateCellWith(fUser: user, indexPath: indexPath)
        
        return cell
    }
    
    func loadUsers(filter: String){
        
        ProgressHUD.show()
        
        var query: Query!
        
            switch filter {
            case kCITY:
                query = reference(.User).whereField(kCITY, isEqualTo: FUser.currentUser()!.city).order(by: kFIRSTNAME, descending: false)
            case kCOUNTRY:
                query = reference(.User).whereField(kCOUNTRY, isEqualTo: FUser.currentUser()!.country).order(by: kFIRSTNAME, descending: false)
                
            default:
                query = reference(.User).order(by: kFIRSTNAME, descending: false)
            }
        
        query.getDocuments { (snapshot, error) in
            
            self.allUsers = []
            self.sectionTitleList = []
            self.allUsersGroup = [:]
            
            if error != nil {
                print(error!.localizedDescription)
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                return
            }
            
            guard let snapshot = snapshot else {
                ProgressHUD.dismiss(); return
            }
            
            if !snapshot.isEmpty{
                
                for userDictionary in snapshot.documents{
                    let userDictionary = userDictionary.data() as NSDictionary
                    let fUser = FUser(_dictionary: userDictionary)
                    if fUser.objectId != FUser.currentId(){
                        self.allUsers.append(fUser)
                    }
                    
                }
                
                
                //Split to groups
                
            }
            
            self.tableView.reloadData()
            ProgressHUD.dismiss()
            
        }
        
        }
    
    //MARK IBActions
    
    @IBAction func filterSegmentValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            loadUsers(filter: kCITY)
        case 1:
            loadUsers(filter: kCOUNTRY)
        case 2:
            loadUsers(filter: "")
        default:
            return
        }
        
    }
    
        
    //MARK: SEarch Controller Functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All"){
        
        filteredUsers = allUsers.filter({ (user) -> Bool in
            return user.firstname.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
        
    }
   
    }


