//
//  TopGamesViewController.swift
//  Practice
//
//  Created by André Assis on 13/12/17.
//  Copyright © 2017 André Assis. All rights reserved.
//

import UIKit
import RxSwift

class TopGamesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var loadingCover: LoadingCover!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var searchBar: UISearchBar!
    
    var client: APIClient!
    var coreDataManager: CoreDataManager!
    
    private var subTopGames: Disposable?
    private var currentOffset: Int = 0
    private let limit: Int = 10
    private var hasMore: Bool = false
    
    private var topGames = [TwitchTopGameModel]()
    private var filteredResults = [TwitchTopGameModel]()
    
    private var isSetup: Bool = true
    private var isSearchBarDeployed = false
    private var isFiltering: Bool = false
    private var searchDisplayed: Bool = false
    
    private var cellSize: CGSize!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateCollection), name: NSNotification.Name.init(Config.kNotUpdateGamesState), object: nil)
        
        self.title = "TopGames"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        
        self.navigationController?.navigationBar.addSubview(viewSearch)
        
        searchBar.delegate = self
        searchBar.setTextColor(color: UIColor.white)
        viewSearch.backgroundColor = UIColor.paPurple()
        
        loadingCover.setAction { [weak self] in
            if let s = self {
                s.loadTopGames(firstLoad: true)
            }
        }
        
        self.view.bringSubview(toFront: loadingCover)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        loadTopGames(firstLoad: true)
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: collectionView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_search"), style: .plain, target: self, action: #selector(toggleSearch))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.resignFirstResponder()
        if isSearchBarDeployed {
            toggleSearch()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isSetup {
            isSetup = false
            
            self.navigationController?.navigationBar.bringSubview(toFront: viewSearch)
            viewSearch.frame = CGRect.init(x: 0.0, y: -viewSearch.bounds.size.height, width: UIScreen.main.bounds.size.width, height: viewSearch.bounds.size.height)
        }
    }
    
    private func loadTopGames(firstLoad: Bool = false) {
        if firstLoad {
            loadingCover.show(true)
        }
        
        subTopGames = client.twitchProvider.request(.getTopGames(offset: currentOffset, limit: self.limit), type: TwitchTopGamesResponse.self).subscribe(onNext: { [weak self] (response) in
            if let s = self {
                s.topGames.append(contentsOf: response.topGames)
                s.currentOffset += response.topGames.count
                
                s.sortGames()
                
                if response.topGames.count == s.limit {
                    s.hasMore = true
                } else {
                    s.hasMore = false
                }
                
                s.collectionView.reloadData()
                
                if firstLoad {
                    s.loadingCover.show(false)
                }
            }
        }, onError: { [weak self] (error) in
            if let s = self {
                s.loadingCover.displayErrorWith(error.localizedDescription)
            }
        })
    }
    
    @objc private func toggleSearch() {
        isSearchBarDeployed = !isSearchBarDeployed
        
        if isFiltering {
            isFiltering = false
            filteredResults = []
            searchBar.text = ""
            searchBar.resignFirstResponder()
            collectionView.reloadData()
        }
        
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            if let s = self {
                s.viewSearch.alpha = s.searchDisplayed ? 0.0 : 1.0
                s.viewSearch.frame = CGRect.init(x: 0, y: s.searchDisplayed ? -s.searchBar.bounds.size.height : 0, width: s.searchBar.bounds.size.width, height: s.searchBar.bounds.size.height)
                
                s.view.layoutIfNeeded()
            }
            }, completion: { [weak self] (c:Bool) in
                if c, let s = self {
                    s.searchDisplayed = !s.searchDisplayed
                    if s.searchDisplayed {
                        s.searchBar.becomeFirstResponder()
                    }
                }
        })
    }
    
    private func filterResultsWith(_ text: String) {
        filteredResults = []
        if text.count > 0 {
            var tempArray = [TwitchTopGameModel]()
            for gameEntry in topGames {
                if gameEntry.game.name.diacriticString().contains(text.diacriticString()) {
                    tempArray.append(gameEntry)
                }
            }
            filteredResults = tempArray
            isFiltering = true
        } else {
            isFiltering = false
        }
        collectionView.reloadData()
    }
    
    @objc private func updateCollection() {
        sortGames()
        collectionView.reloadData()
    }
    
    private func sortGames() {
        topGames.sort(by: { [weak self] (gameEntry1, gameEntry2) -> Bool in
            if let s = self {
                let game1Favorite = s.coreDataManager.isGameFavorite(gameEntry1.game.id)
                let game2Favorite = s.coreDataManager.isGameFavorite(gameEntry2.game.id)
                
                if game1Favorite && game2Favorite {
                    return gameEntry1.game.name < gameEntry2.game.name
                } else {
                    return game1Favorite
                }
            }
            return false
        })
    }
    
    // MARK: - PreviewingDelegate
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let sourceArray = isFiltering ? filteredResults : topGames
        
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath),
            let gameEntry = sourceArray.itemFor(index: indexPath) else {
                return nil
        }
        
        let detailVc = PreviewGameDetailViewController.instantiateWith(gameEntry)
        detailVc.preferredContentSize = CGSize(width: 0.0, height: 400.0)
        
        previewingContext.sourceRect = cell.frame
        
        
        return detailVc
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let vc = viewControllerToCommit as? PreviewGameDetailViewController,
            let gameEntry = vc.vcGameEntry() {
            let vc = GameDetailViewController.instantiateWith(gameEntry)
            show(vc, sender: self)
        } else {
            show(viewControllerToCommit, sender: self)
        }
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        if isSearchBarDeployed {
           toggleSearch()
        }
    }
    
    // MARK: - SearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterResultsWith(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        toggleSearch()
    }
    
    // MARK: - CollectionViewDelegate
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if !isFiltering && hasMore {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !isFiltering && hasMore && section == 1 {
            return 1
        } else {
            return isFiltering ? filteredResults.count : topGames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            if cellSize == nil {
                let cellWidth = (collectionView.bounds.size.width-10)/2
                let cellHeight = cellWidth*1.7
                
                cellSize = CGSize(width: cellWidth, height: cellHeight)
            }
            return cellSize
        } else {
            return CGSize(width: collectionView.bounds.size.width-10, height: 40.0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sourceArray = isFiltering ? filteredResults : topGames
        
        if indexPath.section == 0, let gameEntry = sourceArray.itemFor(index: indexPath) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as! TopGameCollectionViewCell
            
            let isFavorite = coreDataManager.isGameFavorite(gameEntry.game.id)
            
            cell.setupWith(gameEntry, isFavorite: isFavorite)
            
            return cell
        }
        
        if !isFiltering && hasMore {
            loadTopGames()
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sourceArray = isFiltering ? filteredResults : topGames
        
        if indexPath.section == 0, let gameEntry = sourceArray.itemFor(index: indexPath) {
            self.performSegue(withIdentifier: "gameDetail", sender: gameEntry)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        subTopGames?.dispose()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GameDetailViewController,
            let gameEntry = sender as? TwitchTopGameModel {
            vc.setGame(gameEntry)
        }
    }

}

