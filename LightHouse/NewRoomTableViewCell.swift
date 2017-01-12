//
//  NewRoomTableViewCell.swift
//  LightHouse
//
//  Created by Sam Lee on 12/15/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class NewRoomTableViewCell: UITableViewCell {

    @IBOutlet weak var lightTextLabel: UILabel!
    
    var parentViewController: NewRoomViewController?
    
    @IBAction func addLightToRoomButton(_ sender: AnyObject) {
        parentViewController?.addLight(light: lightTextLabel.text!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
