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
        
        // We have to wait until the next download if user has paused the downloads. We evaluate this
        // condition every milisecond.
        while (self.IsPause()) {
            usleep(1000)
        }
        
        /*
         
         == PREGUNTA 8 ==
         
         Si haguéssim optat per crear un Thread per petició sense usar cap tècnica de seqüenciació o
         ordenació de la descàrrega, haguéssim pogut trobar que els fitxers no es baixen en el mateix
         ordre que actualment. També podrien baixar uns quants de cop, o baixar a poc a poc però la informació
         a l'usuari podria arribar de cop.
         
         Depenent de com es gestioni la descàrrega (a baix nivell, amb [NSData(contentsof:)]), podríem trobar
         problemes si ho fa de manera no atòmica. L'accés a l'emmagatzematge local es realitza ja de manera
         atòmica en aquest codi així que per aquesta banda no hi hauria problemes.
         
         Per últim, si les operacions d'anàlisi comptessin amb recursos i variables compartides, podria
         haver-hi errors a l'hora de realitzar aquestes operacions.
         
         */

        // END-CODE-UOC-8
        
    }
    
    
    
    // BEGIN-CODE-UOC-7
    // We set the [m_pause] variable to true or false, or we read it. We use the lock ir order to protect
    // the access to the variable, avoiding a non correct concurrent access.
    
    // We resume the download process
    func Play()
    {
        self.theLock.lock()
        self.m_pause = false
        self.theLock.unlock()
    }
    
    // We pause the download process
    func Pause()
    {
        self.theLock.lock()
        self.m_pause = true
        self.theLock.unlock()
    }
    
    // We check if the download process is paused
    func IsPause()->Bool
    {
        self.theLock.lock()
        let paused = self.m_pause
        self.theLock.unlock()
        
        return paused
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
