//
//  UITextView+Category.swift
//  Swift表情键盘
//
//  Created by xsy on 16/7/14.
//  Copyright © 2016年 林再飞. All rights reserved.
//

import UIKit


extension UITextView {
    
    /**
     获取需要发送给服务器的字符串
     */
    func getEmtionAttributString() -> String {
        
        var TextStr = String();
        attributedText.enumerateAttributesInRange(NSMakeRange(0,attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue:0)) {[unowned self] (emtion, range, _) in
            
            if((emtion["NSAttachment"]) != nil){
                
                // 图片
                let attachment =  emtion["NSAttachment"] as! EmoticonTextAttachment
                
                TextStr += attachment.chs!;
                
            }else if (emtion["NSFont"]) != nil {
                
                TextStr += (self.text as NSString).substringWithRange(range);
            }
        }

        return TextStr;
    }
    

    //插入表情
    func insertEmtion(emtion :Emoticon ) {
    
        if emtion.removeButton {
            //删除
            deleteBackward();
        }
        
        // 1.判断当前点击的是否是emoji表情
        if emtion.codeString != nil {
            replaceRange(self.selectedTextRange!, withText: emtion.codeString!)
            
        }

        // 2.判断当前点击的是否是表情图片
        if emtion.png != nil {
            
            //拿到所有的所有的内容
            let strM = NSMutableAttributedString(attributedString: attributedText);
            // 插入表情到当前光标所在的位置
            let range = selectedRange
            strM.replaceCharactersInRange(range, withAttributedString:EmoticonTextAttachment.addTextAttachment(emtion, font: font!));
            
            // 属性字符串有自己默认的尺寸
            strM.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(range.location, 1))
            
            // 将替换后的字符串赋值给UITextView
            attributedText = strM
            // 恢复光标所在的位置
            // 两个参数: 第一个是指定光标所在的位置, 第二个参数是选中文本的个数
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
        }
    }
}
