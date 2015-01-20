//
//  PrivateKeys.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 14/01/15.
//  Copyright (c) 2015 Emilio Fernandez. All rights reserved.
//

import Foundation

class PrivateKeys {
    
    class var wwoApiKey: String {
        get {
            return self.stringForKey("WWOAPIKey")
        }
    }
    
    private class func stringForKey(key: String) -> String {
        if let privateKeysFileUrl = NSBundle.mainBundle().URLForResource("PrivateKeys.plist", withExtension: nil) {
            let privateKeys = NSDictionary(contentsOfURL: privateKeysFileUrl)
            if let wwoApiKey = privateKeys?.objectForKey("WWOAPIKey") as? String {
                return wwoApiKey
            }
        }
        
        assertionFailure("Could not find PrivateKeys.plist file or wrong format - copy it from PrivateKeys_TEMPLATE.plist, rename it and put your own WWO API key. Do NOT put this file under version control.")
    }
}
