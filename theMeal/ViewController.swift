//
//  ViewController.swift
//  theMeal
//
//  Created by yipeng li on 1/7/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var categorys = [[String:Any]]()

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.categorys = dataDictionary["categories"] as! [[String:Any]]
//                 print(type(of: self.categorys))
                 
                 self.categorys = self.categorys.sorted {  String(describing:$0["strCategory"]) < String(describing:$1["strCategory"]) }
                 
                 self.tableView.reloadData()

//                 print(self.categorys)
             }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealTableViewCell") as! mealTableViewCell
        
        let category = categorys[indexPath.row]
        let type = category["strCategory"] as! String
        
        cell.titleLabel.text = type

        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        let category = categorys[indexPath!.row]
        
        let mealViewController = segue.destination as! mealViewController
        
        mealViewController.category = category
    }


}

