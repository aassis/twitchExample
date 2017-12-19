//
//  TopGameCollectionViewCell.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

class TopGameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageGame: AlamofireImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameViewers: UILabel!
    @IBOutlet weak var imageFavorite: UIImageView!
    
    func setupWith(_ gameEntry: TwitchTopGameModel, isFavorite: Bool) {
        
        imageFavorite.isHidden = !isFavorite
        
        if let imgUrl = gameEntry.game.box.large {
            imageGame.loadImageFor(url: imgUrl)
        }
        if let name = gameEntry.game.name {
            labelGameName.text = name
        }
        
        if let viewers = gameEntry.viewers {
            labelGameViewers.text = String(format: "%d viewers", viewers)
        }
    }
    
}
