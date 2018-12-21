//
//  HomeCell.swift
//  Movie
//
//  Created by Mac-0004 on 19/12/18.
//  Copyright © 2018 0004. All rights reserved.
//

import UIKit
import ScalingCarousel
import Kingfisher

class HomeCell: ScalingCarouselCell {
    
    // MARK: -
    // MARK: - @IBOutlets.
    @IBOutlet fileprivate weak var btnBook: UIButton!
    @IBOutlet fileprivate weak var lblPreSale: UILabel!
    @IBOutlet fileprivate weak var imgPoster: UIImageView!
    @IBOutlet weak var cnBtnBookHeight: NSLayoutConstraint!
    
    // MARK: -
    // MARK: - Override Methods.
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lblPreSale.layer.cornerRadius = lblPreSale.CViewHeight/2.0
        lblPreSale.layer.masksToBounds = true
    }
    
    override func scale(withCarouselInset carouselInset: CGFloat) {
        super.scale(withCarouselInset: carouselInset)
        let scalledValue = (self.mainView.transform.a - 0.9) * 10
        btnBook.alpha = scalledValue
        cnBtnBookHeight.constant = 40.0 * scalledValue
    }
}

// MARK: -
// MARK: - General Methods.
extension HomeCell {
    
    func configureCell(movieDetails:MovieDetails) {
        if let posterPath = movieDetails.poster_path?.toURL {
            imgPoster.kf.setImage(with:posterPath)
        }
        if let presaleFlag = movieDetails.presale_flag {
            lblPreSale.isHidden = presaleFlag == 0
        }
    }
}

