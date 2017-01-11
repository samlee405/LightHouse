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
        cellTableView.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lightsArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let beacon = currentBeacon {
                let cell = cellTableView.dequeueReusableCell(withIdentifier: "roomModuleCell", for: indexPath)
                cell.textLabel?.text = beacon
                cell.isUserInteractionEnabled = false
                
                return cell
            }
            else {
                let cell = cellTableView.dequeueReusableCell(withIdentifier: "roomModuleCell", for: indexPath)
                cell.textLabel?.text = "No current beacon exists"
                cell.isUserInteractionEnabled = false
                
                return cell
            }
        }
        else {
            let cell = cellTableView.dequeueReusableCell(withIdentifier: "roomModuleCell", for: indexPath)
            cell.textLabel?.text = lightsArray[indexPath.row - 1].lightID
            cell.isUserInteractionEnabled = false
            
            var frame: CGRect = self.cellTableView.frame
            frame.size.height = self.cellTableView.contentSize.height
            self.cellTableView.frame = frame
            
            return cell
        }
    }

}
