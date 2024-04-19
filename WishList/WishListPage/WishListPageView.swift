//
//  WishListPageView.swift
//  WishList
//
//  Created by 쌩 on 4/16/24.
//

import UIKit
import CoreData

class WishListPageView: UIViewController{
    
    var persistentContainer: NSPersistentContainer? {
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    }
    var myWishList = [MyWishList]()
    
    @IBOutlet weak var wishListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishListTableView.dataSource = self
        wishListTableView.delegate = self
        loadDataFromModel()
        
    }
    func loadDataFromModel() {
        guard let context = self.persistentContainer?.viewContext else { return }
        do{
            let WishList = try context.fetch(MyWishList.fetchRequest()) as! [MyWishList]
            //            print(WishList)
            myWishList = WishList
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    //스와이프 삭제기능
    func deleteData(_ id: NSManagedObjectID) {
        guard let context = self.persistentContainer?.viewContext else { return }
        let request = MyWishList.fetchRequest()
        guard let myLists = try? context.fetch(request) else { return }
        let selectedItem = myLists.filter({ $0.objectID == id })
        for item in selectedItem {
            context.delete(item)
        }
        try? context.save()
    }
}

extension WishListPageView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myWishList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: .none)
        cell.textLabel?.text = "[\(myWishList[indexPath.row].id)] \(myWishList[indexPath.row].title ?? "") $\(myWishList[indexPath.row].price)"
        return cell
    }
    //스와이프 삭제기능 추가
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let selectedOBID = myWishList[indexPath.row].objectID   //선택된 셀 데이터 구분
        if editingStyle == .delete {
            self.deleteData(selectedOBID)
            self.myWishList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.reloadData()
    }
}

