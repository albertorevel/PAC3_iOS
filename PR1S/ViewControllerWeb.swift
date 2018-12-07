//
//  ViewControllerWeb.swift
//  PR3S
//
//  Created by Javier Salvador Calvo on 12/11/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import UIKit

import WebKit

import Speech

class ViewControllerWeb: UIViewController, UIWebViewDelegate,WKNavigationDelegate, WKUIDelegate, SFSpeechRecognizerDelegate  {

    
    @IBOutlet weak var webView: WKWebView!
    var m_str_json:String = ""
    var m_downloadManager:ThreadDownloadManager = ThreadDownloadManager()
    
    // BEGIN-CODE-UOC-9
    
    // *************** Speech recognizer
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var m_audioAuthorized = false
    
    /*
    
    En el viewDidLoad de ViewControllerWeb dins de BEGIN-CODEUOC-
    9, END-CODE-UOC-9 afegir el necessari per inicialitzar les
    propietats necessàries per a realitzar el reconeixement. Recordar
    indicar en SFSpeechRecognizer que volem reconèixer en anglès fent
    servir locale: Locale (identifier: "a-US")
    
    */
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
         
         En realitzar diferents crides al mètode Download, aquestes s'executen en aquest programa de
         manera seqüencial entre elles; en el moment d'executar però, les crides fetes al mètode
         DownloadInternal, s'estaran fent en un fil diferent, permetent la seva execució de manera
         concurrent i sense produir cap espera al fil principal.
         
         Aquest comportament es deu al fet de que quan es realitza una crida al mètode DownloadInternal
         mitjançant un [perform(#selector(DownloadInternal), on: self.m_thread! ...], estem afegint
         el mètode al fil [self.m_thread] i permetent la seva execució des d'aquest altre fil.
         
         */
        
        // END-CODE-UOC-3
        
        
        // BEGIN-CODE-UOC-10
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.m_audioAuthorized = true
                    try! self.startRecording()
                    
                default:
                    self.m_audioAuthorized = false
                    NSLog("Audio not authorized. AuthStatus = \(authStatus)")
                }
            }
        }
        
        
        /*
         
         Dins de BEGIN-CODE-UOC-10, END-CODE-UOC-10 Cal indicar que el
         delegate de l’ speechRecognizer és el propi ViewControllerWeb i
         sol·licitar permisos per accedir al SFSpeechRecognizer
         
         */
        
        // END-CODE-UOC-10
        
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // BEGIN-CODE-UOC-6
        
        let url:URL = navigationAction.request.url!
        
        if (url.scheme?.lowercased()=="theorganization"){
            
            let function:String = url.host!
            
            switch function {
            case "Play":
                m_downloadManager.Play()
                break;
            case "Pause":
                m_downloadManager.Pause()
                break;
            default:
                NSLog("Html called a function named \(function) that isn't defined.")
            }
            
            decisionHandler(.cancel)
        }
        
        else {
            decisionHandler(.allow)
        }
        
        /*
         
         == PREGUNTA 6 ==
         
         Per començar, hauríem de traure la crida al mètode [self.m_downloadManager.Start()], que ara mateix
         es troba entre els comentaris END-CODE-UOC-2 i BEGIN-CODE-UOC-3 dins del mètode [viewDidLoad()] de
         ViewControllerWeb. També hauríem de traure el codi que ve a continuació, tot el que es troba entre
         BEGIN-UOC-CODE-3 i END-UOC-CODE-3. És a dir, trauríem la crida al mètode Start i als mètodes Download
         del m_downloadManager.
         Així evitaríem que comencés automàticament l'execució al carregar el ViewControllerWeb.
         
         Per permetre l'execució del codi, hauríem d'afegir una funció que es podria dir [startDownloads()]
         dins d'aquest ViewControllerWeb, on hi afegiríem totes les línies de codi que hem tret. Aquest mètode
         es cridaria dins d'aquesta funció [webView()], quan arribi un nom de funció "Start", com es fa ara
         mateix amb els mètodes "Play" i "Pause".
         
         Aquesta funció es cridaria des del web "index.html", afegint una funció [Start()] semblants a les
         funcions [Play()] i [Pause()]:
         
            function Start()
             {
                window.location.href = "theorganization://Start"
             }
         
         Per tal de cridar aquesta funció en el moment que arribi l'Event "OnLoad", podríem afegir a la part
         JavaScript del web la següent línia de codi, que farà la crida a la funció [Start()] que es mostra a
         dalt d'aquestes línies.
         
            window.onload = Start;
         
         Amb aquests canvis, simplement movem un bloc de línies de codi a una funció. En cas que el cost de
         llegir el JSON que conté les URL de descàrrega trigués més temps, o si s'haguessin de fer més
         operacions abans de cridar al mètode [Download()], i no es volgués esperar a l'Event OnLoad del HTML,
         es podrien fer les operacions de lectura del JSON i desar la informació dins d'un array del que
         llegiríem un cop cridada la funció [startDownloads()].
         
         */
         // END-CODE-UOC-6
        
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
    
    func startRecording() throws
    {
        
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSessionCategoryRecord)
        try audioSession.setMode(AVAudioSessionModeMeasurement)
        try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        /*
         guard let inputNode = audioEngine.inputNode else { fatalError("Audio engine has no input node") }
         guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
         */
        
        let inputNode = audioEngine.inputNode
        
        // Configure request so that results are returned before audio recording is finished
        recognitionRequest?.shouldReportPartialResults = true
        
        // A recognition task represents a speech recognition session.
        // We keep a reference to the task so that it can be cancelled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest!) { result, error in
            var isFinal = false
            
            if let result = result {
                let text = result.bestTranscription.segments.last?.substring
                NSLog("Voice recognition: \(text ?? "")")
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode?.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.performSelector(onMainThread: #selector(ViewControllerWeb.startRecording), with: nil, waitUntilDone: false)
            }
        }
        
        let recordingFormat = inputNode?.outputFormat(forBus: 0)
        inputNode?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        try audioEngine.start()

    }
    
/*
    implementem el
    mètode startRecording encarregat de crear la recognitionTask que
    finalment reconeixerà nostres ordres de veu: "Play" i "Stop".
    IMPORTANT: L'única diferència respecte als apunts de la Wiki i al codi
    del repositori és que per accedir a l'última paraula reconeguda s'ha de
    realitzar:
    let text = result.bestTranscription.segments.last?.substring
    
  */
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
