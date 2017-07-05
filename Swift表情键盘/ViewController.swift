//
//  ViewController.swift
//  Swift表情键盘
//
//  Created by xsy on 16/7/12.
//  Copyright © 2016年 林再飞. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var KeyTextView: UITextView!

    
    @IBAction func ItemClick(sender: UIBarButtonItem) {
      
        print(self.KeyTextView.getEmtionAttributString())
    
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChildViewController(emoticonVC)
        KeyTextView.inputView = emoticonVC.view
        self.KeyTextView.font = UIFont.systemFontOfSize(20)
        
    }

    // MARK: - 懒加载
    // weak 相当于OC中的 __weak , 特点对象释放之后会将变量设置为nil
    // unowned 相当于OC中的 unsafe_unretained, 特点对象释放之后不会将变量设置为nil
      private lazy var emoticonVC: EmtionKeyBoardViewController = EmtionKeyBoardViewController {[unowned self] (emtion) in
    
       self.KeyTextView.insertEmtion(emtion)
    
    }
    
    deinit {
    
       
       

    }
    
}

