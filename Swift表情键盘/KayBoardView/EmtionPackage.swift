//
//  EmtionPackage.swift
//  Swift表情键盘
//
//  Created by xsy on 16/7/13.
//  Copyright © 2016年 林再飞. All rights reserved.
//

import UIKit

class EmtionPackage: NSObject {

    // 表情路径
    var id : String?
    //组名
    var groupName: String?
    //表情数组
    var emtions :[Emoticon]?
    
    
    init(id: String) {
        self.id = id;
    }
    
    static let packagesList :[EmtionPackage] = EmtionPackage.packages()!;
    
    //获取所有的表情数据
    private class func packages() -> [EmtionPackage]?{
    
        var list = [EmtionPackage]();
        // 0.创建最近组
        let pk = EmtionPackage(id: "")
        pk.groupName = "最近"
        pk.emtions = [Emoticon]()
        pk.appendEmptyEmoticons()
        list.append(pk)
        
        //获取路径
        let path = NSBundle.mainBundle().pathForResource("emoticons.plist", ofType: nil, inDirectory: "Emoticons.bundle");
        
        //2.获取数据
        let dict = NSDictionary(contentsOfFile: path!);
        let packagesArr = dict!["packages"]  as! [[String : AnyObject]];
        
        for packagesDic in packagesArr  {
            // 2.1创建表情包,并初始化对应的路径
            let package = EmtionPackage(id:packagesDic["id"] as! String);
            //2.2 加载表情数组
            package.loadEmoticons();
            // 追加空白模型
            package.appendEmptyEmoticons()
            // 2.3添加表情包
            list.append(package)
        }
        
        
        return list;

    }

    
    //加载表情数组
    private func loadEmoticons(){
    
        let dict = NSDictionary(contentsOfFile: plistPath());

        //组名
        groupName = dict!["group_name_cn"] as? String;
        // 3.获取表情数组
        let array = dict!["emoticons"] as! [[String: String]]
    
        // 实例化表情数组
        emtions = [Emoticon]()
        // 4.遍历加载表情数组
        var index = 0;
        for d in array{
            
            if index == 20 {
                emtions?.append(Emoticon(isRemoveButton: true));
                index = 0
            }
            emtions?.append(Emoticon(diction: d, id: id!));
            index += 1;
        }
    }
    //追加空白按钮，方便界面布局，如果一个界面的图标不足20个，补足，最后添加一个删除按钮
    private func appendEmptyEmoticons(){
    
//        print(emtions?.count)
        let count = emtions!.count % 21
//        print("count = \(count)")
        
        // 追加空白按钮
        for _ in count..<20 {
            
            // 追加空白按钮
            emtions?.append(Emoticon(isRemoveButton: false))
        }
        // 追加一个删除按钮
        emtions?.append(Emoticon(isRemoveButton: true))
    }
    
     func appendEmoticons(emtion:Emoticon){
    
        //判断是不是删除按钮
        if emtion.removeButton {
            return;
        }
        
        // 2.判断当前点击的表情是否已经添加到最近数组中
        let contain = emtions!.contains(emtion)
    
        if !contain {
            //删除删除按钮
            emtions?.removeLast();
            //插入表情
            emtions?.append(emtion);
        }
        
         // 3.对数组进行排序 将表情插入到第一个
       var reslut = emtions?.sort({ (em1, em2) -> Bool in
        return em1.times > em2.times;
        });
        
        if !contain {
        
            reslut?.removeLast()
            // 添加一个删除按钮
            reslut?.append(Emoticon(isRemoveButton: true))
        }
        
        emtions = reslut;
    
    }

    //获取每一个子文件下 info.plist的路径
    private func plistPath()-> String {
        
        // print(EmtionPackage.emtionPath());
        //id 文件名
        return (EmtionPackage.emtionPath().stringByAppendingString("/" + id!) as String).stringByAppendingString("/info.plist");
    }

    //获取bundle路径
    private class func emtionPath()-> String {
    
        return(NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
    }
 

}


class Emoticon : NSObject {
    
    //1.表情路径
    var id : String?
    /// 表情文字，发送给新浪微博服务器的文本内容
    var chs: String?
    /// 表情图片，在 App 中进行图文混排使用的图片
    var png: String?
    /// UNICODE 编码字符串
    var code: String?{
        didSet{
            // 扫描器，可以扫描指定字符串中特定的文字
            let scanper = NSScanner(string: code!);
        // 扫描整数 Unsafe`Mutable`Pointer 可变的指针，要修改参数的内存地址的内容
            var reslut = UInt32();
            scanper.scanHexInt(&reslut);
            
            codeString = "\(Character(UnicodeScalar(reslut)))"
        }
    
    }
    
    //将UNICODE 字符串 emoji 表情字符串
    var codeString : String?
    
    //每一个表情图片的完整路径
    var imagePath: String?{
    
        return png == nil ? png : (EmtionPackage.emtionPath().stringByAppendingString("/" + id!).stringByAppendingString("/" + png!));
    }
    //是否是删除按钮
    var removeButton = false;
    
    //表情被点击的次数
    var times: Int = 0

    
    init(isRemoveButton : Bool) {
        
        self.removeButton = isRemoveButton;
    }
    
    init(diction : NSDictionary ,id : String) {
        super.init();
        
        self.id = id;
        setValuesForKeysWithDictionary(diction as! [String : String]);
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }

}
