//
//  CallWorker.swift
//  CHUM
//
//  Created by Andrey Mikhaylov on 04/04/16.
//  Copyright © 2016 CHUM. All rights reserved.
//

import UIKit


protocol CallWorkerDelegate {
    func callDisconected(callID:String)
    func shouldHideView()
    func callFailedWithReason(reason:String)
    func callStarted()
}

extension CallWorkerDelegate {
    func callDisconected(callID:String) {}
    func shouldHideView() {}
    func callFailedWithReason(reason:String) {}
    func callStarted() {}
}

let CHMVoxUserStoreKey = "CHMVoxUserStoreKey"

class CallWorker: NSObject, VoxImplantDelegate {
    static let sharedInstance = CallWorker()
    
    var delegate:CallWorkerDelegate?
    
    let sdk = VoxImplant.getInstance()
    var currentCallID:String?
    var isConnected:Bool = false
    
    var lastExtendedDate:NSDate?
    
    var voxUser:VoxUser?
    var extendedTimer:NSTimer?
//        let timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(CallWorker.extendedTimerHandler(_:)), userInfo: nil, repeats: true)//NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "countUp", userInfo: nil, repeats: true)
//        
//        return timer
//    }()

    weak var remoteView:UIView?
    weak var localView:UIView?
    
    private override init() {
        super.init()
        sdk.setVoxDelegate(self)
        sdk.setVideoResizeMode(VI_VIDEO_RESIZE_MODE_CLIP)
                
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CallWorker.reachabilityChanged(_:)),
            name: kReachabilityChangedNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(CallWorker.closeSession),
            name: UIApplicationWillTerminateNotification,
            object: nil)
    }
    
    deinit  {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func start() {
        getCurrentUser { (user) in
            if let vu = user {
                self.configureAndLogin(withVoxUser: vu)
            }
        }
    }
    
    func reachabilityChanged(note:NSNotification?)  {
        if let r = note?.object as? Reachability {
            print(r)
            if r.currentReachabilityStatus() != NotReachable {
                print("reachable now")
                start()
            }
        }
    }
    
    func getCurrentUser(completion:(VoxUser?)->Void) {
        CHMServerBase.shared().loadVoxUserWithCompletion { (voxUser, error, status) in
            if let vu = voxUser {
//                print("---> \(vu.voxLogin)")
                self.lastExtendedDate = NSDate()
                self.generateTimer()
//                let _ = self.extendedTimer
                completion(vu)
            } else {
                completion(nil)
            }
        }
    }
    
    func configure(remoteView:UIView, localView:UIView, delegate:CallWorkerDelegate) {
        self.localView = localView
        self.remoteView = remoteView
        self.delegate = delegate
    }
    
    func configure(withVoxUser voxUser:VoxUser) {
        self.voxUser = voxUser
    }
    
    func configureAndLogin(withVoxUser voxUser:VoxUser) {
        if self.voxUser == nil {
            configure(withVoxUser: voxUser)
        }
        print("before connect");
        sdk.connect(false)
    }

    func makeCallToUser(withID userID:String, conversationID:String? = nil) {
        guard let conversationID = conversationID else {
            return
        }
        currentCallID = sdk.createCall(userID, withVideo: true, andCustomData:"")
        sdk.attachAudioTo(currentCallID)
        
        print("converstion id \(conversationID)")
        let headers:[NSObject:AnyObject] = ["X-ConversationID":conversationID, "X-DirectCall":"true"]
        sdk.startCall(currentCallID, withHeaders: headers)
    }
    
    func endCall() {
        if let cc = currentCallID {
            sdk.disconnectCall(cc, withHeaders: nil)
            currentCallID = nil
        }
    }
    
    func answerCall(withCallID callID:String) {
        let customHeaders = ["Custom header for answer":"X-Custom-Header"]
        currentCallID = callID
        sdk.answerCall(callID, withHeaders: customHeaders)
    }
    
    func declineCall(callID:String) {
        let customHeaders = ["Custom header for answer":"X-Custom-Header"]
        sdk.declineCall(callID, withHeaders: customHeaders)
    }
    
    func loginCurrentUser() {
        guard let voxUser = self.voxUser else {
            return
        }
        login(withUsername: voxUser.voxLogin, password: voxUser.voxPassword)
    }
    
    func login(withUsername username:String, password:String) {
        let usernameFullString = "\(username)@\(CHMVoxLogin)"
        sdk.loginWithUsername(usernameFullString, andPassword: password)
    }
    
    func extendAccountLife () {
        if let ti = secondsSinceLastDate() {
            if ti > 10 * 60 {
                start()
                return
            }
            CHMServerBase.shared().extendVoxSession { (err, status) in
                if err == nil {
                    self.lastExtendedDate = NSDate()
                }
            }
        }
    }
    
    func extendedTimerHandler(handler:NSTimer?) {
        if handler != extendedTimer {
            handler?.invalidate()
            return
        }
        if let ti = secondsSinceLastDate() {
            print("\(ti)")
            if ti > 60*5 {
                extendAccountLife()
            }
        }
    }
    
    func closeSession () {
        CHMServerBase.shared().closeVoxSession { (err, status) in
        }
    }
    
    func generateTimer () {
        self.extendedTimer?.invalidate()
        self.extendedTimer = nil
        self.extendedTimer = NSTimer(timeInterval: 15, target: self, selector:#selector(CallWorker.extendedTimerHandler) , userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.extendedTimer!, forMode: NSRunLoopCommonModes)
    }
    
    func secondsSinceLastDate() -> Double? {
        if let extD = lastExtendedDate {
            return NSDate().timeIntervalSinceDate(extD)
        } else {
            return nil
        }
    }
    
    
    //MARK: audio support
    
    func updateAudioOutput () {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
        }
    }
    
    
    //MARK: delegate
    
    //MARK: connection
    func onConnectionSuccessful() {
        print("after connection")
        loginCurrentUser()
    }
    
    func onConnectionClosed() {
        print("closed")
    }
    
    func onConnectionFailedWithError(reason:String!) {
        print(reason)
        
    }
    
    //MARK: login
    func onLoginFailedWithErrorCode(errorCode: NSNumber!) {
        
    }
    
    func onLoginSuccessfulWithDisplayName(displayName: String!) {
        print("vox logged in")
    }
    
    //MARK: call
    
    func onCallConnected(callId: String!, withHeaders headers: [NSObject : AnyObject]!) {
        sdk.attachAudioTo(callId)
        if let rv = remoteView, let lv = localView {
            sdk.setLocalPreview(lv)
            sdk.setRemoteView(rv)
            delegate?.callStarted()
        }
        sdk.setUseLoudspeaker(true)
    }
    
    func onCallFailed(callId: String!, withCode code: Int32, andReason reason: String!, withHeaders headers: [NSObject : AnyObject]!) {
        print(reason)
        if callId == currentCallID {
            delegate?.callFailedWithReason(reason)
            if reason == "Server not connected" {
                start()
            }
        }
    }
    
    func onCallAudioStarted(callId: String!) {
        sdk.attachAudioTo(callId)
    }
    
    func onCallDisconnected(callId: String!, withHeaders headers: [NSObject : AnyObject]!) {
        if callId == currentCallID {
            delegate?.callDisconected(callId)
        }
    }
    
    func onIncomingCall(callId: String!, caller from: String!, named displayName: String!, withVideo videoCall: Bool, withHeaders headers: [NSObject : AnyObject]!) {
        print(headers)
        if currentCallID == nil {
            var conversationID = ""
            if let cid = headers["X-ConversationID"] as? String {
                conversationID = cid
            }
            let nc = CHMNotificationCenter.init()
            nc.incomingCall(callId, conversationID: conversationID)
        } else {
            declineCall(callId)
        }
    }
}

extension NSObject {
    func isHeadphonesInjected() -> Bool{
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if !currentRoute.outputs.isEmpty {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    return true
                }
            }
            return false
        } else {
            return false
        }
    }
}

