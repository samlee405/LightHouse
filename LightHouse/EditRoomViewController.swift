//
//  EditRoomViewController.swift
//  LightHouse
//
//  Created by Sam Lee on 12/1/16.
//  Copyright © 2016 Sam Lee. All rights reserved.
//

import UIKit

class EditRoomViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var editRoomNameTextField: UITextField!
    @IBOutlet weak var beaconLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var currentRoom: Room?
    var index: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        editRoomNameTextField.attributedPlaceholder =
            NSAttributedString(string: "Room Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
