//
//  RoomTableViewCell.swift
//  LightHouse
//
//  Created by Sam Lee on 11/29/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class RoomTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var roomTitleLabel: UILabel!
    @IBOutlet weak var cellTableView: UITableView!
    
    var currentBeacon: String?
    var lightsArray = [Light]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellTableView.dataSource = self
        cellTableView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let beacon = currentBeacon {
                let cell = UITableViewCell()
                cell.detailTextLabel?.text = beacon
                
                return cell
            }
            else {
                let cell = UITableViewCell()
                cell.detailTextLabel?.text = "No current beacon exists"
                
                return cell
            }
        }
        else {
            let cell = UITableViewCell()
            cell.detailTextLabel?.text = lightsArray[indexPath.row].roomName
            
            return cell
        }
    }

}
