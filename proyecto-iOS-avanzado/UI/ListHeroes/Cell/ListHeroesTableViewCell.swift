//
//  ListHeroesTableViewCell.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 23/10/23.
//

import UIKit

class ListHeroesTableViewCell: UITableViewCell {
    
    static let identifier: String = "ListHeroesTableViewCell"
    static let estimatedHeight: CGFloat = 200
    
    @IBOutlet weak var viewCell: UIView!
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
        
        viewCell.layer.cornerRadius = 8
        viewCell.layer.shadowColor = UIColor.gray.cgColor
        viewCell.layer.shadowOffset = .zero
        viewCell.layer.shadowRadius = 8
        viewCell.layer.shadowOpacity = 0.4
        
        selectionStyle = .none
    }

    func updateView(
        name: String? = nil,
        photo: String? = nil,
        description: String? = nil
    ) {
        self.nameLabelCell.text = name
        self.descriptionLabelCell.text = description
        
//        TODO: Descargar imagen y setearla en el ImageView
    }
    
}
