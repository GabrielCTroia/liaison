//
//  RecordTableViewCell.swift
//  Liaison
//
//  Created by gabriel troia on 3/26/17.
//  Copyright © 2017 gabriel troia. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    //MARK: Properties

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
