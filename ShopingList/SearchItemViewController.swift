//
//  SearchItemViewController.swift
//  ShopingList
//
//  Created by David Kababyan on 31/03/2017.
//  Copyright © 2017 David Kababyan. All rights reserved.
//

import UIKit
import SwipeCellKit

protocol SearchItemViewControllerDelegate {
    
    func didChooseItem(groceryItem: GroceryItem)
}

class SearchItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate, UISearchResultsUpdating {

    var delegate: SearchItemViewControllerDelegate?
    
    let searchController = UISearchController(searchResultsController: nil)

    var shoppingList: ShoppingList?
    
    var groceryItems: [GroceryItem] = []
    var filteredGroceryItems: [GroceryItem] = []
    
    var defaultOptions = SwipeTableOptions()
    var isSwipeRightEnabled = false

    var clickToEdit = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()//to change the currency
        self.tableView.setContentOffset(CGPoint(x: 0.0, y: 44.0), animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButtonOutlet.isHidden = clickToEdit
        addButtonOutlet.isHidden = !clickToEdit
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        tableView.tableHeaderView = searchController.searchBar

        loadGroceryItems()
    }
    
    //MARK: TableView dataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            return filteredGroceryItems.count
            
        }
        
        return groceryItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GroceryTableViewCell
        
        cell.delegate = self
        cell.selectedBackgroundView = createSelectedBackgroundView()
        
        
        var item: GroceryItem

        if searchController.isActive && searchController.searchBar.text != "" {
            
            item = filteredGroceryItems[indexPath.row]
            
        } else {
            
            item = groceryItems[indexPath.row]
        }


        cell.bindData(item: item)
        
        return cell
    }
    
    
    //MARK: Tableview delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        var item: GroceryItem
        
        if searchController.isActive && searchController.searchBar.text != "" {
            
            item = filteredGroceryItems[indexPath.row]
            
        } else {
            
            item = groceryItems[indexPath.row]
        }

        if !clickToEdit {

            self.delegate!.didChooseItem(groceryItem: item)
            
            self.dismiss(animated: true, completion: nil)
        } else {
            
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddShoppingItemViewController
            
            vc.groceryItem = item
            self.present(vc, animated: true, completion: nil)

        }
        
    }


    //MARK: Load ShoppingItems
    
    func loadGroceryItems() {
        
        firebase.child(kGROCERYITEM).child(FUser.currentId()).observe(.value, with: {
            snapshot in
            
            self.groceryItems.removeAll()
            
            if snapshot.exists() {
                
                let allItems = (snapshot.value as! NSDictionary).allValues as NSArray
                
                
                for item in allItems {
                    
                    let currentItem = GroceryItem.init(dictionary: item as! NSDictionary)
                    
                    self.groceryItems.append(currentItem)
                    
                }
                
            } else{
                
                print("no snapshot")
            }
            
            self.tableView.reloadData()
        })
        
    }

    
    
    //MARK: IBActions

    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func addButtoPressed(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddItemVC") as! AddShoppingItemViewController
        
        
        vc.shoppingList = shoppingList
        vc.addingToList = true
        
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK: SwipeTableviewCell delegate
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .left {
            guard isSwipeRightEnabled else { return nil }
        }
        
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            
            var item: GroceryItem
            
            if self.searchController.isActive && self.searchController.searchBar.text != "" {
                
                item = self.filteredGroceryItems[indexPath.row]
                self.filteredGroceryItems.remove(at: indexPath.row)
            } else {
                
                item = self.groceryItems[indexPath.row]
                self.groceryItems.remove(at: indexPath.row)
            }
            
            item.deleteItemInBackground(groceryItem: item)
            
            // Coordinate table view update animations
            self.tableView.beginUpdates()
            action.fulfill(with: .delete)
            self.tableView.endUpdates()
            
        }
        
        configure(action: delete, with: .trash)
        
        return [delete]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = defaultOptions.transitionStyle
        options.buttonSpacing = 11

        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color

    }

    //MARK: SearchController functions
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        filteredGroceryItems = groceryItems.filter({ (item) -> Bool in
            return item.name.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }



}
