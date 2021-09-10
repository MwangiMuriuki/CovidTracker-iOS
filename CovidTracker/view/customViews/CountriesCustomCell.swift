//
//  CountriesCustomCell.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 10/09/2021.
//

import UIKit

class CountriesCustomCell: UICollectionViewCell {

    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var casesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        flagIcon.layer.cornerRadius = 22.5
        
        
    }

}
