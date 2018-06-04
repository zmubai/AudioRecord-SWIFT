//
//  MP3Coder.swift
//  Mp3CodeKit
//
//  Created by zengbailiang on 2018/5/24.
//  Copyright © 2018年 zengbailiang. All rights reserved.
//

import UIKit
import OpenMp3CodeKitEX

open class MP3Coder: NSObject {
    
    private let  mp3Coder:Mp3CodeInstance
    public override init() {
        mp3Coder =  mp3Coder_init()
    }
    public func codeTomp3(srcFile:String,dstFile:String) -> Int{
        
        return Int(OpenMp3CodeKitEX.codeTomp3(mp3Coder, UnsafePointer<Int8>((srcFile as NSString).utf8String), UnsafePointer<Int8>((dstFile as NSString).utf8String)))
    }
}
