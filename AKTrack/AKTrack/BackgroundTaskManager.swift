//
//  BackgroundTaskManager.swift
//  TrackingDemo
//
//  Created by Amarendra on 11/13/17.
//  Copyright © 2017 Akwa. All rights reserved.
//

import UIKit
import Foundation
class BackgroundTaskManager: NSObject {
    var bgTaskIdList:[UIBackgroundTaskIdentifier]
    var masterTaskId:UIBackgroundTaskIdentifier
    public static let sharedBackgroundTaskManager:BackgroundTaskManager = BackgroundTaskManager()
    override init() {
        bgTaskIdList = [UIBackgroundTaskIdentifier]()
        masterTaskId = UIBackgroundTaskInvalid
        super.init()
    }
    @discardableResult func beginNewBackgroundTask()->UIBackgroundTaskIdentifier{
       let application =  UIApplication.shared
       var bgTaskId =  UIBackgroundTaskInvalid
       if(application.responds(to: #selector(UIApplication.beginBackgroundTask)))
        {
            bgTaskId = application.beginBackgroundTask(expirationHandler: {
                self.bgTaskIdList = self.bgTaskIdList.filter {$0 != bgTaskId}    //.remove(at: self.bgTaskIdList.index(of: bgTaskId)!)
                application.endBackgroundTask(bgTaskId)
                bgTaskId =  UIBackgroundTaskInvalid
            })
            if self.masterTaskId ==  UIBackgroundTaskInvalid{
                self.masterTaskId = bgTaskId
            }
            else{
                self.bgTaskIdList.append(bgTaskId)
                self.endBackgroundTasks()
            }
        }
        return bgTaskId
    }
    func endBackgroundTasks(){
        self.drainBGTaskList(all: false)
    }
    func endAllBackgroundTasks(){
        self.drainBGTaskList(all: true)
    }
    
    func drainBGTaskList(all:Bool){
        let application = UIApplication.shared
        if(application.responds(to: #selector(UIApplication.beginBackgroundTask))){
            let count = all ? self.bgTaskIdList.count : self.bgTaskIdList.count-1
            for _ in 0..<count{
                if let bgTaskId = self.bgTaskIdList.first{
                    application.endBackgroundTask(bgTaskId)
                    self.bgTaskIdList = self.bgTaskIdList.filter {$0 != bgTaskId}//.remove(at: self.bgTaskIdList.index(of: bgTaskId)!)
                }
            }
            if self.bgTaskIdList.count > 0{
                print("kept task id \(self.bgTaskIdList.first ?? 1)")
            }
            if all {
                application.endBackgroundTask(self.masterTaskId)
                self.masterTaskId = UIBackgroundTaskInvalid
            }
            else{
                 print("kept master task id \(self.masterTaskId)")
            }
        }
    }
    
}
