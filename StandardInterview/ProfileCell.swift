//
//  ProfileCell.swift
//  StandardInterview
//
//  Created by Scott Lydon on 7/10/22.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet var theImageView: UIImageView!
    @IBOutlet var label: UILabel!

    func set(item: Profile) {
        label.text = item.name
        theImageView.setImage(for: item.url) { [weak label] _ in item.name == label?.text }
    }
}
