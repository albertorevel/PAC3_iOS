//
//  CItemProvider.swift
//  PR1S
//
//  Created by Javier Salvador Calvo on 24/9/16.
//  Copyright © 2016 UOC. All rights reserved.
//

import Foundation
import UIKit

class CItemProvider : NSObject, XMLParserDelegate
{

    var m_delegate:ViewController? = nil;
    
    var m_parser:XMLParser? = nil;
 
    var m_last_string:String = "";
    var m_last_item:CItemData? = nil;
    
    
    var m_items:NSMutableArray?=nil;
    var m_loading:Bool = false
    
    
    
    // ---------------------------------
 
    func GetItemAt(position:CLong) -> CItemData
    {
        return self.m_items?[position] as! CItemData
    }
    
    
    func GetCount() -> CLong
    {
        return self.m_items!.count;
    }

     // ---------------------------------
    
    
    
    func LoadAndParse()
    {
        self.m_loading = false;
        
        self.performSelector(inBackground: #selector(LoadAndParseInternal), with:nil)
    
    }
    
    
    func LoadAndParseInternal()
    {
    
      //  self.LoadAndParseHardcoded()
        
        self.LoadAndParseFromWeb();

        
        self.m_loading = true;
        
        
    
        
        self.m_delegate?.performSelector(onMainThread: #selector(ViewController.LoadingEnd), with: nil, waitUntilDone: false)
        
        
     
    }
    
    
    func LoadAndParseHardcoded()
    {
    
    
    self.m_items = NSMutableArray(capacity: 6)
    
    var item:CItemData;
    

        
    item = CItemData(id: "00000001",title: "Item 1",type: 1)
    self.m_items?.add(item)
        
    item = CItemData(id: "00000002",title: "Item 2",type: 2)
    self.m_items?.add(item)
    
    item = CItemData(id:"00000003",title: "Item 3",type: 3)
    self.m_items?.add(item)
    
    item = CItemData(id: "00000004",title: "Item 4",type: 4)
    item.m_data = "[\"http://cdn.shopify.com/s/files/1/0197/4944/products/vh_apples_2_1024x1024.jpg%3Fv%3D1355351841\",\"https://upload.wikimedia.org/wikipedia/commons/b/b0/Chandler_strawberries.jpg\",\"https://pixabay.com/static/uploads/photo/2011/03/24/10/12/banana-5734_960_720.jpg\"]"
    self.m_items?.add(item)

        
    item = CItemData(id: "00000005",title: "Item 5",type: 5)
    self.m_items?.add(item)

    item = CItemData(id: "00000006",title: "Item 6",type: 6)
    self.m_items?.add(item)

        
    item = CItemData(id: "00000007",title: "Item 7",type: 7)
    item.m_data = "{\"y-axis\":{\"min-value\":0.0,\"max-value\":700.0,\"step\":100.0},\"x-axis-labels\":[2013,2014,2015],\"y-values\":[356,560,620]}";
  
    self.m_items?.add(item)
    
        
    }
    
    
    func LoadAndParseFromWeb()
    {
       
        
        self.m_items = NSMutableArray()
        let str_url:String = "http://einfmlinux1.uoc.edu/devios/data3.xml";
        
        var xmlData:NSData
        
        do
        {
            xmlData = try NSData(contentsOf: URL(string: str_url)!)
            self.m_parser = XMLParser(data: xmlData as Data)
            self.m_parser?.delegate = self
            self.m_parser?.parse();

        }
        catch
        {
        
        }
        
    
    
    }

    
    // *****************************************
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {

        if(elementName == "item")
        {
            self.m_last_item = CItemData();
            self.m_last_item?.m_id = attributeDict["id"]!
            
            let str_type:String = attributeDict["type"]!
            
            self.m_last_item?.m_type = CLong(str_type)!
        
        }
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if(elementName == "item")
        {
          self.m_items?.add(self.m_last_item)
        }
        else if(elementName == "title")
        {
        
            self.m_last_item?.m_title = self.m_last_string
        }
        else if(elementName == "description")
        {
            
            self.m_last_item?.m_description = self.m_last_string
        }
        else if(elementName == "data")
        {
            
            self.m_last_item?.m_data = self.m_last_string
        }
        
    

        
        
    }
 
 
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        self.m_last_string = string;
    }
  
    

}



