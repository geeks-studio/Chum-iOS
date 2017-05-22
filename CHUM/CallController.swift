//
//  CallController.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit
import PureLayout

let kCallControllerIdentifier = "CallControllerID"

class CallController: UIViewController {
    var opponentID:String?
    var callID:String?
    var avatarProvider: CHMAvatarProvider?
    var conversationID: String?
    var activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .White)
    
//    var 
    
    var isIncoming = false
    
    @IBOutlet weak var endCallButton: UIButton!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var localView:UIView!
    @IBOutlet weak var headphonesInfoView: UIVisualEffectView!
    let avatarView:CHMAvatarView = {
        let r = CGRect(x: 0, y: 0, width: 30, height: 30)
        let av = CHMAvatarView(frame: r)
        return av
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addTargets()
        CallWorker.sharedInstance.configure(callView, localView: localView, delegate: self)
        callAction()
        view.bringSubviewToFront(localView)
        headphonesInfoView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CHMNotificationCenter.shared().canShow = false
//        NSNotificationCenter.defaultCenter().addObserver(
//            self,
//            selector: #selector(CallController.updateAudioOutput),
//            name: AVAudioSessionRouteChangeNotification,
//            object: nil)
//        updateAudioOutput()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        CHMNotificationCenter.shared().canShow = true
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        CallWorker.sharedInstance.endCall()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: configure
    
    func configure(withOpponetID opponentID:String, conversationID:String) {
        self.opponentID = opponentID
        self.conversationID = conversationID
        self.isIncoming = false
        loadConversation()
    }
    
    func configure(withCallID callID:String, conversationID:String? = nil) {
        self.callID = callID
        self.isIncoming = true
        if let cID = conversationID {
            self.conversationID = cID
            self.loadConversation()
        }
    }
    
    func configure(withConversation conversation:PAAConversation) {
        if let ap = conversation.avatar {
            self.avatarProvider = ap
        }
        if let opid = conversation.opponentID {
            self.opponentID = opid
        }
    }

    //MARK: call
    
    private func callAction() {
        if let opID = opponentID {
            makeCall(opID, conversationID: conversationID)
        } else if let cID = callID {
            answerCall(cID, conversationID: conversationID)
        } else {
            dismisVC()
        }
    }
    
    private func makeCall (opponentID:String, conversationID:String! = nil){
        CallWorker.sharedInstance.makeCallToUser(withID: opponentID, conversationID: conversationID)
    }
    
    private func answerCall(callID:String, conversationID:String? = nil) {
        CallWorker.sharedInstance.answerCall(withCallID: callID)
    }
    
    private func loadConversation() {
        guard let cID = conversationID else {
            return
        }
        PAAMessageManager.sharedInstance().loadConversationWithID(cID) { (conv, err, status) in
            guard let c = conv else {
                return
            }
            self.avatarProvider = c.avatar
            self.configureAvatar()
        }
    }
    
    //MARK: targets
    
    func addTargets() {
        endCallButton.addTarget(self, action: #selector(CallController.dismisVC), forControlEvents:.TouchUpInside)
    }
    
    //MARK: ui
    
    func configureUI() {
        view.backgroundColor = .blackColor()
        callView.backgroundColor = .blackColor()
        localView.backgroundColor = .blackColor()
        configureUserAvatarView()
        configureAvatar()
        addCustomCloseButton()
        configureActivityIndicator()
    }
    
    func configureActivityIndicator() {
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.autoCenterInSuperview()
    }
    
    func setActivityIndcatorVisisble(activityIndicatorVisisble:Bool) {
        activityIndicator.hidden = !activityIndicatorVisisble
    }
    
    private func configureUserAvatarView() {
        navigationItem.titleView = self.avatarView;
        navigationItem.titleView?.backgroundColor = UIColor.clearColor()
    }
    
    private func configureAvatar() {
        if let ap = avatarProvider {
            avatarView.configureWithAvatarProvider(ap)
        }
    }
    
    @objc private func updateAudioOutput() {
        self.headphonesInfoView.hidden = isHeadphonesInjected()
    }
}

extension CallController: CallWorkerDelegate {
    func callFailedWithReason(reason: String) {
        var text = reason
        switch reason {
        case "Temporarily Unavailable":
            text = "Пользователь оффлайн"
        case "Busy Here":
            text = "Пользователь занят"
        case "Server not connected":
            text = "Ожидание подключение к серверу"
        default:
            text = "Что-то пошло не так"
        }
        showWarningWithText(text)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func callStarted() {
        setActivityIndcatorVisisble(false)
        if !isHeadphonesInjected() {
            headphonesInfoView.hidden = false
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.headphonesInfoView.hidden = true
            }
        }
    }
    
    func callDisconected(callID: String) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}


