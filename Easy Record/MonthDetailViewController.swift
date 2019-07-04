//
//  MonthDetailViewController.swift
//  Easy Record
//
//  Created by Michael Pan on 9/28/17Thursday.
//  Copyright © 2017 Michael Pan. All rights reserved.
//

import UIKit
import CoreData

class MonthDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var records:[Record] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title_label.text? = "\(display_year)/ \(display_month)"

        tableView.dataSource = self
        tableView.rowHeight = 65
        
        let ctx = appDelegate.persistentContainer.viewContext
        let calendar = Calendar.current
        do {
            let request : NSFetchRequest<Record> = Record.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
            let records_list = try ctx.fetch(request)
            
            for record in records_list {
                let record_year = calendar.component(.year, from: record.created! as Date)
                let record_month = calendar.component(.month, from: record.created! as Date)
                if record_year == display_year && record_month == display_month {
                    records.append(record)
                }
            }
        } catch {
            print("failed")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear?", message: "Clear record in \(display_year)/ \(display_month)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            let ctx = self.appDelegate.persistentContainer.viewContext
            for record in self.records {
                ctx.delete(record)
            }
            do {try ctx.save()}
            catch {}
            self.records = []
            self.performSegue(withIdentifier: "backtodetail", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { (action) in alert.dismiss(animated: true, completion: nil)}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = records[indexPath.row].created
        let canlendar = Calendar.current
        let day = String(canlendar.component(.day, from: date! as Date))
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "records", for: indexPath) as! MonthDetailTableCell
        cell.title?.text = String(records[indexPath.row].number)
        cell.subtitle?.text = records[indexPath.row].describe
        cell.date?.text = day
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ctx = self.appDelegate.persistentContainer.viewContext
            let record = records[indexPath.row]
            ctx.delete(record)
            do {try ctx.save()}
            catch {}
            
            records.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
}
