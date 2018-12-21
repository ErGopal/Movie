//
//  MovieListTblCell.swift
//  Movie
//
//  Created by mac-0005 on 19/12/18.
//  Copyright © 2018 mac-0005. All rights reserved.
//

import UIKit
import Cosmos

class MovieListTblCell: UITableViewCell {

    // MARK: -
    // MARK: - @IBOutlets.
    @IBOutlet fileprivate var lblMovieName : UILabel!
    @IBOutlet fileprivate var lblMovieDescription : UILabel!
    @IBOutlet fileprivate var lblReleaseDate : UILabel!
    @IBOutlet fileprivate var lblAverageRating : UILabel!
    @IBOutlet fileprivate var lblAgeCategory : UILabel!
    @IBOutlet fileprivate var btnBuyTicket : UIButton!
    @IBOutlet fileprivate var imgMovie : UIImageView!
    @IBOutlet fileprivate var viewStarRating : CosmosView!
    
    // MARK: -
    // MARK: - Override Methods.
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgMovie.layer.cornerRadius = 20
        btnBuyTicket.layer.cornerRadius = btnBuyTicket.CViewHeight/2.0
        
        lblAgeCategory.layer.cornerRadius = lblAgeCategory.CViewHeight/2.0
        lblAgeCategory.layer.borderWidth = 1.0
        lblAgeCategory.layer.borderColor = CRGB(r: 170, g: 170, b: 170).cgColor
    }
    
}

//MARK: -
//MARK: - General Methods
extension MovieListTblCell {
    
    func configureCell(movieDetails:MovieDetails) {
        
        if let strTitle = movieDetails.title {
            lblMovieName.text = strTitle
        }
        
        if let strAgeCategory = movieDetails.age_category {
            lblAgeCategory.text = strAgeCategory
        }
        
        if let rate = movieDetails.rate {
            viewStarRating.rating = Double(rate)
            lblAverageRating.text = "\(rate)"
        }
        
        if let strDescription = movieDetails.description {
            lblMovieDescription.text = strDescription
        }
        
        if let posterPath = movieDetails.poster_path?.toURL {
            imgMovie.kf.setImage(with:posterPath)
        }
        
        self.lblReleaseDate.text = movieDetails.strReleaseDate
    }
}
