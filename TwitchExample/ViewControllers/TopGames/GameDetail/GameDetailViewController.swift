//
//  GameDetailViewController.swift
//  Practice
//
//  Created by André Assis on 14/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var imageGame: AlamofireImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelViewers: UILabel!
    @IBOutlet weak var labelChannels: UILabel!
    
    @IBOutlet weak var buttonFavorite: RoundButton?
    
    internal var gameEntry: TwitchTopGameModel!
    
    var coreDataManager: CoreDataManager!
    
    private var hideButton: Bool = false
    
    class func instantiateWith(_ gameEntry: TwitchTopGameModel) -> GameDetailViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "gameDetail") as! GameDetailViewController
        
        vc.setGame(gameEntry)
        
        return vc
    }
    
    func vcGameEntry() -> TwitchTopGameModel? {
        return gameEntry
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func setGame(_ gameEntry: TwitchTopGameModel) {
        self.gameEntry = gameEntry
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGameName.text = gameEntry.game.name
        labelViewers.text = "VIEWERS: \(gameEntry.viewers!)"
        labelChannels.text = "CHANNELS: \(gameEntry.channels!)"
        
        if coreDataManager.isGameFavorite(gameEntry.game.id) {
            buttonFavorite?.isSelected = true
            buttonFavorite?.setTitle("ADD FAVORITE", for: .highlighted)
        } else {
            buttonFavorite?.isSelected = false
            buttonFavorite?.setTitle("REMOVE FAVORITE", for: .highlighted)
        }
        
        if let imgUrl = gameEntry.game.box.large {
            imageGame.loadImageFor(url: imgUrl)
        }
    }
    
    @IBAction func addRemoveToFavorites(_ sender: UIButton) {
        _ = coreDataManager.addRemoveFavorite(gameEntry.game.id)
        UIView.transition(with: sender, duration: 0.2, options: UIViewAnimationOptions.transitionCrossDissolve, animations: {
            sender.setTitle(sender.isSelected ? "REMOVE FAVORITE" : "ADD FAVORITE", for: .highlighted)
            sender.isSelected = !sender.isSelected
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class PreviewGameDetailViewController: GameDetailViewController {
    
    override class func instantiateWith(_ gameEntry: TwitchTopGameModel) -> PreviewGameDetailViewController {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "previewGameDetail") as! PreviewGameDetailViewController
        
        vc.setGame(gameEntry)
        
        return vc
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        var previewAction: UIPreviewActionItem!
        if coreDataManager.isGameFavorite(self.gameEntry.game.id) {
            previewAction = UIPreviewAction(title: "REMOVE FAVORITE", style: UIPreviewActionStyle.default) { [weak self] (action, vc) in
                if let s = self,
                    let gameDetailVc = vc as? GameDetailViewController,
                    let gameEntry = gameDetailVc.vcGameEntry() {
                    s.coreDataManager.removeFavoriteGame(gameEntry.game.id)
                    NotificationCenter.default.post(name: NSNotification.Name.init(Config.kNotUpdateGamesState), object: nil, userInfo: nil)
                }
            }
        } else {
            previewAction = UIPreviewAction(title: "ADD FAVORITE", style: UIPreviewActionStyle.default) { [weak self] (action, vc) in
                if let s = self,
                    let gameDetailVc = vc as? GameDetailViewController,
                    let gameEntry = gameDetailVc.vcGameEntry() {
                    _ = s.coreDataManager.addFavoriteGame(gameEntry.game.id)
                    NotificationCenter.default.post(name: NSNotification.Name.init(Config.kNotUpdateGamesState), object: nil, userInfo: nil)
                }
            }
        }
        
        return [previewAction]
    }
    
}
