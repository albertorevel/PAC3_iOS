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
        // We read data stored in m_str_json in order to start all th downloads.
        let m_data:Data = m_str_json.data(using: String.Encoding.utf8)!
        
        do {
            // We load the list and initializate the variables
            let list: NSMutableArray = try JSONSerialization.jsonObject(with: m_data as Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableArray
            
            // We start each download with the given URL
            for urlString in list {
                self.m_downloadManager.Download(url: urlString as! String)
            }
        }
        catch {
            print("Unexpected error: \(error).")
        }
        
        /*
         
         == PREGUNTA 3 ==
         
         El mètode Download es crida des del fil principal i s'executa en aquest mateix fil.
         En canvi, el mètode DownloadInternal no s'executarà des del fil principal.
         
         Al realitzar diferents crides al mètode Download, aquestes s'executen en aquest programa de
         manera seqüencial entre elles; en el moment d'executar però, les crides fetes al mètode
         DownloadInternal, s'estaran fent en un fil diferent, permetent la seva execució de manera
         concurrent i sense produir cap espera al fil principal.
         
         Aquest comportament es deu a que quan es realitza una crida al mètode DownloadInternal
         mitjançant un [perform(#selector(DownloadInternal), on: self.m_thread! ...], estem afegint
         el mètode al fil [self.m_thread] i permetent la seva execució des d'aquest altre fil.
         
         */
        
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
        // We make a call to the IncProgress() method in the html file loaded in WebView
        let jsCallBack:String = "IncProgress()"
        self.webView.evaluateJavaScript(jsCallBack, completionHandler: nil)
    }
    
    func AddLog(msg:String)
    {
        // We make a call to the AddLog(msg) method in the html file loaded in WebView
        let jsCallBack:String = "AddLog('\(msg)')"
        self.webView.evaluateJavaScript(jsCallBack, completionHandler: nil)
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
