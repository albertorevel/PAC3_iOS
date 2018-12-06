//
//  ViewControllerWeb.swift
//  PR3S
//
//  Created by Javier Salvador Calvo on 12/11/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import UIKit

import WebKit

class ViewControllerWeb: UIViewController, UIWebViewDelegate,WKNavigationDelegate, WKUIDelegate  {

    
    @IBOutlet weak var webView: WKWebView!
    var m_str_json:String = ""
    var m_downloadManager:ThreadDownloadManager = ThreadDownloadManager()
    
    // BEGIN-CODE-UOC-9
    
    
    
    
    
    // END-CODE-UOC-9
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // BEGIN-CODE-UOC-2
        // We define this ViewController as the WebView's delegate
        self.webView?.uiDelegate = self
        self.webView?.navigationDelegate = self
        
        // We adapt the WebView in order to make the web's behaviour like a native app.
        self.webView?.scrollView.bounces = false
        self.webView?.scrollView.isScrollEnabled = false
        
        // We load index.html
        let htmlFile:String = Bundle.main.path(forResource: "index",
                                               ofType: "html", inDirectory: "www")!
        let url:URL = URL(fileURLWithPath: htmlFile)
        let request:URLRequest = URLRequest(url: url)
        self.webView?.load(request)
        
        // END-CODE-UOC-2
        
        
        self.m_downloadManager.m_main = self
        self.m_downloadManager.Start()
        
        
        // BEGIN-CODE-UOC-3
        
        
        
        
        
        // END-CODE-UOC-3
        
        
        // BEGIN-CODE-UOC-10
        
        
        
        
        
        // END-CODE-UOC-10
        
    }
    
    
    func webView(_ WebViewNews: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // BEGIN-CODE-UOC-6
        
        
        
        
         // END-CODE-UOC-6
        
        
        
        return true
        
    }

    // BEGIN-CODE-UOC-5
    func IncProgress()
    {
       
        
    }
    
    func AddLog(msg:String)
    {
       
        
    }
    // END-CODE-UOC-5
    
     // BEGIN-CODE-UOC-11
    
    

    
    
    
     // END-CODE-UOC-11
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
