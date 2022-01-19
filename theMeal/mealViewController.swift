//
//  mealViewController.swift
//  theMeal
//
//  Created by yipeng li on 1/7/22.
//

import UIKit

class mealViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var meals = [[String:Any]]()
    var category: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let baseUrl = "https://www.themealdb.com/api/json/v1/1/filter.php?c="
        let mealPath = category["strCategory"] as! String
        let url = URL(string: baseUrl + mealPath)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.meals = dataDictionary["meals"] as! [[String:Any]]
                 self.tableView.reloadData()
//                 print(self.meals)
             }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "singleMealTableViewCell") as! singleMealTableViewCell
        
        let meal = meals[indexPath.row]
        let type = meal["strMeal"] as! String
        
        cell.titleLabel.text = type
        
        return cell
    }
    
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let meal = meals[indexPath!.row]

            let detailViewController = segue.destination as! detailViewController

            detailViewController.meal = meal
        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
