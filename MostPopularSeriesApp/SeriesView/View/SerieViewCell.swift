//
//  SerieViewCell.swift
//  MostPopularSeriesApp
//
//  Created by Marcelo Santoro on 11/08/2018.
//  Copyright © 2018 Marcelo Santoro. All rights reserved.
//

import UIKit
import Kingfisher

class SerieViewCell: UICollectionViewCell {

    static var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tbCoverImageView: UIImageView!
    
    func setup(with serie: Serie?) {
        guard let serie = serie else {
            // We could work with the empty state in here
            return
        }
        
        titleLabel.text = serie.serieName
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        
        //kf = KingFisher = Image Caching
        tbCoverImageView.kf.setImage(with: URL(string: "\(serie.tbSerieImage!)"))
        
    }
    
    
}
