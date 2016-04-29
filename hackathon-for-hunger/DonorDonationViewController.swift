//
//  DonorDonationViewController.swift
//  hackathon-for-hunger
//
//  Created by ivan lares on 4/28/16.
//  Copyright © 2016 Hacksmiths. All rights reserved.
//

import UIKit

class DonorDonationViewController: UIViewController {
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private let cellIdentifier = "DonationCell"
    var foodToDonate: [String]!
    
    override func viewDidLoad() {
        foodToDonate = [String]()
        
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
    }
    
    //MARK: Actions 
    
    @IBAction func didTapDonate(sender: AnyObject) {
        print("Donate button was tapped on DonorDonationViewController")
    }
    
}

extension DonorDonationViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodToDonate.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! DonationTableViewCell
        cell.delegate = self
        cell.label.text = foodToDonate[indexPath.row]
        return cell
    }
}

extension DonorDonationViewController: UITableViewDelegate{
    
}

extension DonorDonationViewController: DonationCellDelegate{
    
    func didTapCancel(cell: DonationTableViewCell){
        if let selectedIndex = tableView.indexPathForCell(cell){
            foodToDonate.removeAtIndex(selectedIndex.row)
            tableView.deleteRowsAtIndexPaths([selectedIndex], withRowAnimation: .Fade)
        }
    }
}

extension DonorDonationViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard let food = textField.text else { return }
        
        if !food.isBlank{
            foodToDonate.append(food)
            tableView.reloadData() //TODO: update table view correctly
            textField.text = nil
        }
    }
}
