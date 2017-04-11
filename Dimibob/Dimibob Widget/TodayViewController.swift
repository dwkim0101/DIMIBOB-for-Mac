//
//  TodayViewController.swift
//  Dimibob Widget
//
//  Created by DoraDora(상훈) on 2017. 4. 11..
//  Copyright © 2017년 DoraDora(상훈). All rights reserved.
//

import Cocoa
import NotificationCenter

class TodayViewController: NSViewController, NCWidgetProviding {
    
    @IBOutlet weak var breakfastMealLabel: NSTextField?
    @IBOutlet weak var lunchMealLabel: NSTextField?
    @IBOutlet weak var dinnerMealLabel: NSTextField?
    @IBOutlet weak var snackMealLabel: NSTextField?
    
    @IBOutlet weak var breakfastTitle: NSTextField?
    @IBOutlet weak var lunchTitle: NSTextField?
    @IBOutlet weak var dinnerTitle: NSTextField?
    @IBOutlet weak var snackTitle: NSTextField?
    
    @IBOutlet weak var loadingLabel: NSTextField?
    
    var b : Bool = false

    override var nibName: String? {
        return "TodayViewController"
    }
    
    func loadBob() {
        breakfastMealLabel?.alphaValue = 0
        lunchMealLabel?.alphaValue = 0
        dinnerMealLabel?.alphaValue = 0
        snackMealLabel?.alphaValue = 0
        breakfastTitle?.alphaValue = 0
        lunchTitle?.alphaValue = 0
        dinnerTitle?.alphaValue = 0
        snackTitle?.alphaValue = 0
        
        loadingLabel?.alphaValue = 1
        
        let url = URL(string: "http://dimigo.in/pages/dimibob_getdata.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with:request, completionHandler: {(data, response, error) in
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                
                //print(json["breakfast"])
                
                let breakfastCell = self.breakfastMealLabel?.cell as! NSTextFieldCell
                let lunchCell = self.lunchMealLabel?.cell as! NSTextFieldCell
                let dinnerCell = self.dinnerMealLabel?.cell as! NSTextFieldCell
                let snackCell = self.snackMealLabel?.cell as! NSTextFieldCell
                
                breakfastCell.title = json["breakfast"] as! String
                lunchCell.title = json["lunch"] as! String
                dinnerCell.title = json["dinner"] as! String
                snackCell.title = json["snack"] as! String
                
                self.breakfastMealLabel?.alphaValue = 1
                self.lunchMealLabel?.alphaValue = 1
                self.dinnerMealLabel?.alphaValue = 1
                self.snackMealLabel?.alphaValue = 1
                self.breakfastTitle?.alphaValue = 1
                self.lunchTitle?.alphaValue = 1
                self.dinnerTitle?.alphaValue = 1
                self.snackTitle?.alphaValue = 1
                
                self.loadingLabel?.alphaValue = 0
            } catch let error as NSError {
                print(error)
            }
        }).resume()
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            self.loadBob()
            completionHandler(.newData)
        }
        
        if(!b) {
            self.loadBob()
            b = true
            completionHandler(.newData)
        }
        
    
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.noData)
        
    }

    override func viewWillTransition(to newSize: NSSize) {
        self.preferredContentSize = CGSize(width: 320, height: 220)
    }
}
