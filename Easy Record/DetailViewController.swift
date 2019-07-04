//
//  DetailViewController.swift
//  Easy Record
//
//  Created by Michael Pan on 9/26/17Tuesday.
//  Copyright © 2017 Michael Pan. All rights reserved.
//

import UIKit
import CoreData

var display_month = Int16(0);
var display_year = Int16(0);

struct month_money {
    let year: Int
    let month: Int
    var number: Int16
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var monthtotal_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var records:[Record] = []
    var months:[String:month_money] = [:]
    var month_keys:[String] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self

        let ctx = appDelegate.persistentContainer.viewContext
        do {
            let request : NSFetchRequest<Record> = Record.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
            records = try ctx.fetch(request)
        } catch {
            print("failed")
        }
        
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        var month_total = Int16(0)

        for record in records {
            let record_year = calendar.component(.year, from: record.created! as Date)
            let record_month = calendar.component(.month, from: record.created! as Date as Date)
            if year == record_year && month == record_month {
                month_total += record.number
            }

            let year_month = "\(record_year)/ \(record_month)"
            if months.index(forKey: year_month) == nil {
                months[year_month] = month_money(year: record_year, month: record_month, number: 0)
                month_keys.append(year_month)
            }
            months[year_month]?.number += record.number
        }
        monthtotal_label.text? = String(month_total)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return month_keys.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dates", for: indexPath) as! MonthTableCell
        let month = month_keys[indexPath.row]
        cell.title?.text = month
        cell.number?.text = "$ \(months[month]!.number)"

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let month = month_keys[indexPath.row]
        display_year = Int16(months[month]!.year)
        display_month = Int16(months[month]!.month)

        performSegue(withIdentifier: "monthdetail", sender: self)
    }
    
    @IBAction func thisMonthButtonPressed(_ sender: UIButton) {
        let today = Date()
        let calendar = Calendar.current
        display_year = Int16(calendar.component(.year, from: today))
        display_month = Int16(calendar.component(.month, from: today))
        
        performSegue(withIdentifier: "monthdetail", sender: self)
    }

    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
