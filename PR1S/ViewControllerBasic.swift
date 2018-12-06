//
//  ViewControllerBasic.swift
//  PR1S
//
//  Created by Javier Salvador Calvo on 24/9/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import UIKit

class ViewControllerBasic: UIViewController {
    
    
    var m_item:CItemData? = nil

    @IBOutlet weak var m_textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.m_textView?.text = m_item?.m_title;
    }

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
