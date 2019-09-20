//
//  ViewController.swift
//  CarfaxList
//
//  Created by Chris Lin on 9/18/19.
//  Copyright © 2019 Chris Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CarInfoCellCDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var carlist = [CarInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let _ = CarInfo.fetchCarList().done { list in
            self.carlist = list
            self.tableView.reloadData()
        }.ensure {
                
        }.catch { error in
            print(error.localizedDescription)
        }
    }
    
    func makeCall(_ phoneNumber: String) {
        if let phoneURL = URL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carlist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 390
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "carInfoCell", for: indexPath) as? CarInfoTableViewCell else { fatalError("CarInfoTableViewCell not configured") }
        
        let carInfo = carlist[indexPath.row]
        cell.delegate = self
        
        cell.callNumber = carInfo.dealerNumber
        cell.firstLineLabel.text = carInfo.yearMakeModel()
        cell.secondLineLabel.text = carInfo.priceMileageLocation()
        cell.phoneNumberButton.setTitle(carInfo.callNumber(), for: .normal)
        cell.carImage?.downloaded(from: carInfo.photoUrl)
        
        return cell
    }
}

