//
//  MainTableViewCell.swift
//  ProficiencyExercise
//
//  Created by Wagh, Suniket (Cognizant) on 4/12/20.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    let imageHref = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        imageHref.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        imageHref.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.numberOfLines = 0

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.numberOfLines = 0

        contentView.addSubview(imageHref)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)

        let viewsDict = [
            "image" : imageHref,
            "title" : titleLabel,
            "description" : descriptionLabel
        ] as [String : Any]

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(45)]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-[description]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[title]-[image(45)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[description]-[image(45)]-|", options: [], metrics: nil, views: viewsDict))

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
