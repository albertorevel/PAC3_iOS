//
//  CItemData.swift
//  PR1S
//
//  Created by Javier Salvador Calvo on 24/9/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import Foundation
class CItemData : NSObject
{
    
    
    var m_id:String = ""
    var m_type:CLong = CLong(0)
    var m_title:String = ""
    var m_description:String = ""
    var m_data:String = ""
    
    override init()
    {
        super.init();
        
    }
    
    init(id: String, title:String, type:CLong) {
        self.m_id = id;
        self.m_title = title;
        self.m_type = type;
        
    }
    
    
}
