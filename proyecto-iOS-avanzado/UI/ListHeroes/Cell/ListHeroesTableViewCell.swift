//
//  ListHeroesTableViewCell.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 23/10/23.
//

import UIKit
import Kingfisher

class ListHeroesTableViewCell: UITableViewCell {
    
    static let identifier: String = "ListHeroesTableViewCell"
    static let estimatedHeight: CGFloat = 100
    
    @IBOutlet weak var imageViewCell: UIImageView!
    @IBOutlet weak var nameLabelCell: UILabel!
    @IBOutlet weak var descriptionLabelCell: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabelCell.text = nil
        imageViewCell.image = nil
        descriptionLabelCell.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        selectionStyle = .none
    }

    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.nameLabelCell.text = name
        self.descriptionLabelCell.text = description
        self.imageViewCell.kf.setImage(with: URL(string: photo ?? ""))
    }
    
}
