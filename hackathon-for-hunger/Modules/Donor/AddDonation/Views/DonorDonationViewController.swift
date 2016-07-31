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
    private let donationPresenter = DonationPresenter(donationService: DonationService())
    @IBOutlet weak var addDonationButton: UIButton!
    var activityIndicator : ActivityIndicatorView!
    
    override func viewDidLoad() {
        addDonationButton.enabled = false
        foodToDonate = [String]()
        donationPresenter.attachView(self)
        tableView.dataSource = self
        tableView.delegate = self
        inputTextField.delegate = self
        activityIndicator = ActivityIndicatorView(inview: self.view, messsage: "Saving")
    }
    
    //MARK: Actions 
    
    @IBAction func didTapDonate(sender: AnyObject) {
        self.startLoading()
        print("Donation: \(foodToDonate)")
        donationPresenter.createDonation(self.foodToDonate)
    }
    
    func checkButtonStatus()
    {
        if foodToDonate.count > 0 {
            addDonationButton.enabled = true
        } else {
            addDonationButton.enabled = false
        }
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
            checkButtonStatus()
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
            checkButtonStatus()
        }
    }
}

extension DonorDonationViewController: DonationView {
    func startLoading() {
        self.activityIndicator.startAnimating()
    }
    func finishLoading() {
        self.activityIndicator.stopAnimating()
    }
    func donations(sender: DonationPresenter, didSucceed donation: Donation) {
        self.finishLoading()
        self.foodToDonate = []
        self.tableView.reloadData()
        SweetAlert().showAlert("Donation Saved!", subTitle: nil, style: AlertStyle.Success)
    }
    func donations(sender: DonationPresenter, didFail error: NSError) {
        self.finishLoading()
        SweetAlert().showAlert("Could not save donation!", subTitle: error.localizedDescription, style: AlertStyle.Error)
    }
}
