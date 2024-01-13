//
//  IngredientsMeasuresTableViewCell.swift
//  Tripy
//
//

import UIKit

class IngredientsMeasuresTableViewCell: UITableViewCell {
    

    @IBOutlet weak var ingredientMeasureLabel: UILabel!
    
    @IBOutlet weak var circleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
