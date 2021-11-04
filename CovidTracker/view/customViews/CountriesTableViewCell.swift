//
//  CountriesTableViewCell.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 04/10/2021.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var flagIcon: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var casesLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        flagIcon.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func populateCountryData(with model: CountryData){
        let imageLink =  URL(string: (model.countryInfo?.flag)!)

        countryNameLabel.text = model.country
        casesLabel.text = String(model.cases)
        
        do {
            if let urlData = imageLink {
                let url_data = try Data(contentsOf: urlData)
                flagIcon.image = UIImage(data: url_data)
            }
            else{
                flagIcon.image = #imageLiteral(resourceName: "app_logo")
            }
           
        }
        catch{
            print("Image Error", error)
        }
    }
    
}
