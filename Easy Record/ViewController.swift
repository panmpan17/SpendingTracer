//
//  MainPageViewController.swift
//  Easy Record
//
//  Created by Michael Pan on 9/25/17Monday.
//  Copyright © 2017 Michael Pan. All rights reserved.
//

import UIKit
import CoreData

func date(year: Int, month:Int, day:Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    let userCalendar = Calendar.current
    return userCalendar.date(from: dateComponents)!
}

class MainPageViewController: UIViewController {
    @IBOutlet weak var number_field: UITextField!
    @IBOutlet weak var descripution: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number_field.keyboardType = UIKeyboardType.decimalPad
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submiteButtonPressed(_ sender: UIButton) {
        if number_field.text != "" {
            let number = Int16(number_field.text!)
            let descri = descripution.text!
            
            save(number: number!, descr: descri)
            number_field.text = ""
            descripution.text = ""
        }
    }

    func save(number: Int16, descr: String) {
        save_with_date(number: number, descr: descr, date: Date())
    }
    
    func save_with_date(number: Int16, descr: String, date: Date) {
        print(date)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let ctx = appDelegate.persistentContainer.viewContext
        let record = NSEntityDescription.insertNewObject(
            forEntityName: "Record", into: ctx)
            as! Record
        
        record.number = number
        record.describe = descr
        record.created = date as NSDate
        
        do {
            try ctx.save()
        } catch {
            let refreshAlert = UIAlertController(title: "Fail", message: "Save failed", preferredStyle: UIAlertControllerStyle.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
        }
    }
}
