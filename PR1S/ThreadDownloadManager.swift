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
    
        // We download contents that are in [url]
        var tData:NSData
        do {
            tData = try NSData(contentsOf: URL(string: url)!)
            
            // We read the file's name and we create the destination path
            let urlArray = url.components(separatedBy: "/")
            let fileName = urlArray.last ?? ""
            
            let localStorageUrl = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
            
            // We store downloaded content in local Storage
            try tData.write(to: localStorageUrl, options: .atomic)
           
            // We simulate some data process. We dot it with sleep() function because we want to
            // block this thread.
            sleep(5)
            
            // After this time, we execute two methods in main thread.
            DispatchQueue.main.async(execute: {
                [unowned self] in
                
                self.m_main?.AddLog(msg: "\(url)")
                self.m_main?.IncProgress()
                
            })
        }
        catch {
            print("Unexpected error: \(error).")
        }
         // END-CODE-UOC-4
        
        
        
        // BEGIN-CODE-UOC-8
        
        

        // END-CODE-UOC-8
        
    }
    
    
    
    // BEGIN-CODE-UOC-7
    
    func Play()
    {
        NSLog("Play")
    }
    
    
    func Pause()
    {
        
        NSLog("Pause")

        
        
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
