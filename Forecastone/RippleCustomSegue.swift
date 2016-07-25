//
//  RippleCustomSegue.swift
//  Forecastone
//
//  Created by yxx3tch on 2016/07/21.
//  Copyright © 2016年 Satoru Hosaka. All rights reserved.
//

import UIKit

class RippleCustomSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = self.sourceViewController as UIViewController!
        let destination = self.destinationViewController as UIViewController!
        
        source?.navigationController?.pushViewController(destination!, animated: true)
    }
    
}