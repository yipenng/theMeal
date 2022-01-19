//
//  detailViewController.swift
//  theMeal
//
//  Created by yipeng li on 1/8/22.
//

import UIKit

class detailViewController: UIViewController {
    var details = [[String:Any]]()
    var meal: [String:Any]!
    
    @IBOutlet weak var IngredientText: UITextView!
    @IBOutlet weak var instructionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseUrl = "https://www.themealdb.com/api/json/v1/1/lookup.php?i="
        let mealPath = meal["idMeal"] as! String
        let url = URL(string: baseUrl + mealPath)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
             // This will run when the network request returns
             if let error = error {
                    print(error.localizedDescription)
             } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]

                 self.details = dataDictionary["meals"] as! [[String:Any]]

                 let detail = self.details[0]
                 let detailDescribtion = detail["strInstructions"]
                 self.instructionText.text = detailDescribtion as! String
                 
                 var ingredients:[String:String] = [:]
                 var measures:[String:String] = [:]
                 
                 for (k, valu) in detail {
                     let measure = String(describing:valu)
                     let num = k.filter { "0"..."9" ~= $0 }
                     let a: Int? = Int(num)
                     if (a ?? 0 > 0) {
                         if !measure.isEmpty{
                             if k.contains("i"){
                                 ingredients[num] = measure
                             }else{
                                 measures[num] = measure
                             }
                             
                         }
                     }
                 }
                 
                 var instructionDisplay = ""
                 for(i, valuI) in ingredients{
                     for (m, valuM) in measures{
                         if i == m {
                             if valuI != "<null>" && valuM != "<null>" && valuI != " " && valuM != " "{
                                 instructionDisplay += valuI + " : " + valuM + "\n"
                             }
                         }
                     }
                 }
                 self.IngredientText.text = instructionDisplay
             }
        }
        task.resume()
        
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
