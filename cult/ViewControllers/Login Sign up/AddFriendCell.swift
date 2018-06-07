//
//  AddFriendCell.swift
//  Cult
//
//  Created by Han on 5/22/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit

protocol AddFriendCellDelegate {
    func didAddButtonPressed(button: UIButton)
}

class AddFriendCell: UITableViewCell {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cultNameLabel: UILabel!
    
    var delegate: AddFriendCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    @IBAction func onAddButton(_ sender: Any) {
        
        delegate.didAddButtonPressed(button: sender as! UIButton)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
