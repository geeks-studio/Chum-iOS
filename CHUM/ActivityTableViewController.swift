//
//  ActivityControllerTableViewController.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 06/05/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import SVPullToRefresh

class ActivityTableViewController: UITableViewController {
    
    var activities:[UserActivityProtocol] = [] {
        didSet {
            activityPresenters = activities.map({UserActivityConverter.convert($0)})
        }
    }
    private var activityPresenters = [UserActivityPresenterProtocol]()
    
    private let widthWithoutImage:CGFloat = {
        let width = UIScreen.mainScreen().bounds.size.width - 40 - 8 - 12 - 8 - 15 - 8
        return width
    }()
    
    private let widthWithImage:CGFloat = {
        let width = UIScreen.mainScreen().bounds.size.width - 40 - 8 - 12 - 8 - 44 - 8
        return width
    }()
    
    private var heightHelper:CHMTextHeightHelper = CHMTextHeightHelper(textWidth: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        loadFromServer()
        makeAllReaded()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: configure
    
    private func configureUI() {
        setCustomTitleWithText("Что нового?");
        setCustomNavigationBackButtonWithTransition()
        configureTableView()
        configureRefreshControlls()
    }
    
    private func configureTableView() {
        registrateCells()
        tableView.backgroundColor = UIColor.lightBackgroundColor()
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .None
    }
    
    private func configureRefreshControlls() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self,
                                       action: #selector(ActivityTableViewController.loadFromServer(_:)),
                                       forControlEvents: .ValueChanged)
        
        tableView.addInfiniteScrollingWithActionHandler { [weak self] in
            self?.loadBottom()
            
        }
        self.tableView.infiniteScrollingView.activityIndicatorViewStyle = .White
        
        
        
    }
    
    private func registrateCells()  {
        self.tableView.registerNib(UserActivityCell.nib(),
                                   forCellReuseIdentifier: UserActivityCell.identifier())
    }
    
    //MARK: action
    
    private func showScreen(withActivity activity:UserActivityProtocol) {
        let actRouter = ActivityRouter()
        actRouter.openScreen(withActivity: activity)
    }

    
    // MARK: load
    
    @objc private func loadFromServer(sender:UIRefreshControl? = nil) {
        CHMServerBase.shared().loadActivities(withCount: 20, offset: 0) {[weak self] (activities, err, status) in
            sender?.endRefreshing()
            guard let acts = activities else {
                return
            }
            self?.activities = acts
            self?.tableView.reloadData()
        }
    }
    
    private func loadBottom() {
        let offset = activities.count
        CHMServerBase.shared().loadActivities(withCount: 20, offset: offset) {[weak self] (activities, err, status) in
            self?.tableView.infiniteScrollingView.stopAnimating()
            guard let newActs = activities else {
                return
            }
            
            self?.activities += newActs
            self?.tableView.reloadData()
            
//            if var ac = self?.activities {
//                ac += acts
//                self?.tableView.reloadData()
//            }
        }
    }
    
    private func makeAllReaded() {
        CHMServerBase.shared().makeAllActivitiesViewedWithCompletion { (err, status) in
            UserActivityNotifier.updateActivityBadge(withCount: NSNumber(int: 0))
        }
    }
    
    // MARK: - Table view

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityPresenters.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserActivityCell.identifier()) as! UserActivityCell
//        let activity = activities[indexPath.row];
        let activityPresenter = activityPresenters[indexPath.row]
        cell.configure(withActivityPresenter: activityPresenter)
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let activityPresenter = activityPresenters[indexPath.row]
        // UserActivityConverter.convert(activities[indexPath.row])
//        var width = widthWithoutImage
//        if activityPresenter.postUrl != nil {
//            width = widthWithImage
//        }
//        heightHelper.textWidth = width
//        var height:CGFloat = 0
//        if let text = activityPresenter.activityText {
//            height = heightHelper.heightOfText(text.string)
//        }
//        if height < 50 {
//            height = 50
//        }
        
        let height = activityPresenter.textHeight
        return height + 15 + 16 + 16 + 4
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let activity = activities[indexPath.row]
        showScreen(withActivity: activity)
    }
    
    
}