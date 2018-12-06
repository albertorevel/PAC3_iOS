//
//  ThreadDownloadManager.swift
//  PR3S
//
//  Created by Javier Salvador Calvo on 12/11/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import UIKit

class ThreadDownloadManager: NSObject {

    
    var m_thread:Thread? = nil
    var theLock:NSLock = NSLock();
    var m_main:ViewControllerWeb? = nil
    var m_pause:Bool = false
    
    
    func Start()
    {
    
        self.m_thread = Thread(target: self, selector: #selector(ThreadDownloadManager.ThreadMainLoop(_:)), object: nil)
        self.m_thread?.start()
    }
    
    
    
    func Download(url:String)
    {
        self.perform(#selector(DownloadInternal), on: self.m_thread!, with: url, waitUntilDone: false)
    }
    
    func DownloadInternal(url:String)
    {
         // BEGIN-CODE-UOC-4
     
        
        
        
         // END-CODE-UOC-4
        
        
        
        // BEGIN-CODE-UOC-8
        
        

        // END-CODE-UOC-8
        
    }
    
    
    
    // BEGIN-CODE-UOC-7
    
    func Play()
    {

    }
    
    
    func Pause()
    {
        

        
        
    }
    
    func IsPause()->Bool
    {

        return false;
    }
    
    
    // END-CODE-UOC-7
    
    
    func Message(msg:String)
    {
        
        
    }

    
    func ThreadMainLoop(_:Any)
    {
        self.perform(#selector(Message), on: self.m_thread!, with: "Start", waitUntilDone: false)
        CFRunLoopRun();
    }

}
