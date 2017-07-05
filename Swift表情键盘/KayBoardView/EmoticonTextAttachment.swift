//
//  EmoticonTextAttachment.swift
//  Swift表情键盘
//
//  Created by xsy on 16/7/14.
//  Copyright © 2016年 林再飞. All rights reserved.
//

import UIKit

class EmoticonTextAttachment: NSTextAttachment {
    // 保存对应表情的文字
    var chs :String?
  
    //根据表情模型, 创建表情字符串
    class func addTextAttachment(emtion :Emoticon,font :UIFont)-> NSAttributedString {

        //创建一个附件
        let textAttach = EmoticonTextAttachment();
        textAttach.chs = emtion.chs;
        //给附件添加图片
        textAttach.image = UIImage(named: emtion.imagePath!);
        // 设置了附件的大小
        textAttach.bounds = CGRect(x: 0, y: -4, width:font.lineHeight, height:font.lineHeight);
        
        //添加一个附件
        return NSAttributedString(attachment: textAttach);
    
    }
    
}
