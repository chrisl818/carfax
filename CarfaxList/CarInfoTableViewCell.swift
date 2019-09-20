//
//  CarInfoTableViewCell.swift
//  CarfaxList
//
//  Created by Chris Lin on 9/19/19.
//  Copyright © 2019 Chris Lin. All rights reserved.
//

import UIKit

protocol CarInfoCellCDelegate: class {
    func makeCall(_ phoneNumber: String)
}

class CarInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    
    weak var delegate: CarInfoCellCDelegate?
    
    var callNumber: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func makeCall(_ sender: Any) {
        guard let phoneNumber = callNumber else {
            return
        }
        delegate?.makeCall(phoneNumber)
    }
}
