//
//  MealTableViewController.swift
//  ElegantLogin
//
//  Created by NemesissLin on 2019/10/15.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class MealTableViewController: UITableViewController {

    var MealList : [Meal] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadFakeData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    
    private func LoadFakeData() {
        let Meal0 = Meal(Image: UIImage(named: "Meal-0")!, Name: "红烧肉盘", Rating: 3)
        let Meal1 = Meal(Image: UIImage(named: "Meal-1")!, Name: "第二种菜", Rating: 4)
        let Meal2 = Meal(Image: UIImage(named: "Meal-2")!, Name: "第三种菜", Rating: 2)
        
        MealList += [Meal0,Meal1, Meal2]
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // 返回有多少个Section, 例如一月，二月这样的分割栏。
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 返回单个Section中有多少行
        return MealList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell else {
            fatalError("不能将cell向下转换到目标类型MealTableViewCell")
        }
        
        let meal = MealList[indexPath.row]
        
        cell.MealImage.image = meal.Image
        cell.MealTitle.text = meal.Name
        cell.MealDescription.text = "Rating: \(meal.Rating)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let NavigateType = segue.identifier
        let detail = segue.destination as? MealDetailViewController
        switch NavigateType {
        case "AddItem":
            print("点击新增按钮，进入新建模式")
            break
        
        case "ShowDetail":
            print("点击Cell  进入预览模式")
            let selectedCell = sender as? MealTableViewCell
            let index = tableView.indexPath(for: selectedCell!)!
            let meal = MealList[index.row]
            detail?.MealInstance = meal
            break
        default:
            break
        }
    }
    
    @IBAction func unwindToMealList(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        
        guard let detail = sourceViewController as? MealDetailViewController else {
            print("不是从Meal Detail View中返回，不作任何处理")
            return
        }
        
        if let meal = detail.MealInstance {
            // 如果是编辑模式，则重新加载当前Cell的信息
            if let selectedIndex = tableView.indexPathForSelectedRow {
                let editedIndex = selectedIndex.row
                MealList[editedIndex] = meal
                tableView.reloadRows(at: [selectedIndex], with: .none)
            }
        // 否则只好新增信息
            else {
                let newIndexPath = IndexPath(row: MealList.count, section: 0)
                MealList.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
    }

}
