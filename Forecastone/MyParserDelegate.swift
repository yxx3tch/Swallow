//
//  MyParserDelegate.swift
//  Forecastone
//
//  Created by Satoru Hosaka on 2015/07/07.
//  Copyright (c) 2015年 Satoru Hosaka. All rights reserved.
//

import Foundation

class MyParserDelegate: NSObject, NSXMLParserDelegate {
    var isPrecip = false
    var precip = 0
    var precipArray:[Int] = []
    var num = 0
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict:[String : String]) {
        if elementName == "period" {
            isPrecip = true
            num++
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "period" {
                    isPrecip = false
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters preString: String){
        if isPrecip {
            if num > 44 {
                if num < 54 {
                    precip = Int(preString)!
                    precipArray.append(precip)
                }
            }
        }
    }
    
    func send(i: Int) -> Int {
        return precipArray[i]
    }
}