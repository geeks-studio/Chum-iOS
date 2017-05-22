//
//  ThemeChooserController.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import PureLayout
import SVPullToRefresh

let countOfThemesPerLoad = 20

class ThemeChooserController: UIViewController {
    
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    let refreshControl = UIRefreshControl()
    
    var themes = [CHMPlace]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureController()
        loadThemes(nil)
        
        self.tableView.addInfiniteScrollingWithActionHandler { [weak self] in
            self?.loadBottom()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func configureController() {
        setCustomNavigationBackButtonWithTransition()
        configureNavigationBar()
        configureTableView()
        configureRefreshControl()
    }
    
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        registrateCells()
        view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        tableView.backgroundColor = .lightBackgroundColor()
        tableView.separatorStyle = .None
    }
    
    func configureRefreshControl () {
        tableView.addSubview(refreshControl)
        refreshControl.tintColor = .whiteColor()
        refreshControl.addTarget(self, action: #selector(loadThemes), forControlEvents: .ValueChanged)
        refreshControl.layer.zPosition -= 1;
    }
    
    func configureNavigationBar() {
        let chumImage = UIImage(named: "chum")
        let titleImageView = UIImageView(image: chumImage)
        self.navigationItem.titleView = titleImageView
    }
    
    func registrateCells() {
        self.tableView .registerNib(ThemeCell.nib(), forCellReuseIdentifier: ThemeCell.identifier())
    }
    
    //MARK: load
    
    func loadThemes (sender:UIRefreshControl? = nil) {
        CHMServerBase.shared().loadAllPlacesType(nil, count: countOfThemesPerLoad, offset: 0) { (places, err, statusCode) in
            sender?.endRefreshing()
            if let themes = places {
                self.themes = themes
                self.tableView.reloadData()
            }
        }
    }
    
    func loadBottom() {
        let offset = themes.count
        CHMServerBase.shared().loadAllPlacesType(nil, count: countOfThemesPerLoad, offset:offset ) { (places, err, statusCode) in
            self.tableView.infiniteScrollingView.stopAnimating()
            if let themes = places {
                self.themes += themes
                self.tableView.reloadData()
            }
        }
    }
     //MARK: test
    

}

extension ThemeChooserController: CHMCanBeReloaded {
    func reloadDataSender(sender: AnyObject!) {
        loadThemes()
    }
}

extension ThemeChooserController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ThemeCell.identifier()) as! ThemeCell
        let place = themes[indexPath.row]
        let themePresenter = ThemeConverter.convertPlace(place)
        cell.configure(themePresenter)
        return cell
    }
}

extension ThemeChooserController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let theme = themes[indexPath.row]
//        acceptTheme(theme)
        let router = Router()
        router.showPlaceFeed(withPlace: theme)
        
    }
}
