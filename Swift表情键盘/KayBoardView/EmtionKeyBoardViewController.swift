//
//  EmtionKeyBoardViewController.swift
//  Swift表情键盘
//
//  Created by xsy on 16/7/13.
//  Copyright © 2016年 林再飞. All rights reserved.
//

import UIKit

class EmtionKeyBoardViewController: UIViewController {

    /*!
     创建闭包将选中的表情模型弹出去
     */
    let didSelectorEmtionCallBack :(emtion :Emoticon)->();
    
    init(CallBack:(emtion :Emoticon)->()){
    
        self.didSelectorEmtionCallBack = CallBack;
        super.init(nibName: nil, bundle: nil);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI();
    }
    
    private func setupUI() {
        
        view.addSubview(toolBar)
        view.addSubview(keyBoardCollectionView)

        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        keyBoardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var cons = [NSLayoutConstraint]()
        let viewDict = ["keyBoardCollectionView": keyBoardCollectionView, "toolBar": toolBar]
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[keyBoardCollectionView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[toolBar]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[keyBoardCollectionView]-0-[toolBar(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict)
        
        // 添加约束
        view.addConstraints(cons)
        
        // 初始化工具条
        setupToolbar()
        
        // 初始化collectionview
        setupCollectionView()
    }
    
    /**
     准备collectionView
     */
    private func setupCollectionView() {
        
        keyBoardCollectionView.registerClass(EmoticonCell.self, forCellWithReuseIdentifier: XMGEmoticonCellReuseIdentifier)
        keyBoardCollectionView.backgroundColor = UIColor.darkGrayColor();
        keyBoardCollectionView.dataSource = self
        keyBoardCollectionView.delegate = self
    }
    
    /**
     准备toolbar
     */
    private func setupToolbar(){
        
        toolBar.tintColor = UIColor.darkGrayColor()
        
        var items = [UIBarButtonItem]()
        var index = 0
        for s in ["最近", "默认", "emoji", "浪小花"] {
            
            let item = UIBarButtonItem(title: s, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EmtionKeyBoardViewController.itemClick(_:)))
            item.tag = index
            index += 1
            items.append(item)
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        items.removeLast()
        toolBar.items = items
    }
    
    //MARK: - 按钮点击事件
    func itemClick(item: UIBarButtonItem) {
        
        keyBoardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: 0, inSection: item.tag), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false);
        
    }
    
    // MARK - 懒加载
    private lazy var toolBar = UIToolbar()
    private lazy var keyBoardCollectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmoticonLayout())
    
    //模型
    private lazy var packages :[EmtionPackage]  = EmtionPackage.packagesList;
    
}
let XMGEmoticonCellReuseIdentifier = "XMGEmoticonCellReuseIdentifier"
extension EmtionKeyBoardViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (packages.count);
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emtions?.count ?? 0;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(XMGEmoticonCellReuseIdentifier, forIndexPath: indexPath) as! EmoticonCell
        
//        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.greenColor()
        
        cell.emoticon = packages[indexPath.section].emtions![indexPath.item];
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
    
        let emti = packages[indexPath.section].emtions![indexPath.item];
        emti.times = emti.times + 1;
        packages[0].appendEmoticons(emti);

        didSelectorEmtionCallBack(emtion: emti);
    
    }
}


private class EmoticonLayout: UICollectionViewFlowLayout {
    
    // 在 collectionView 的大小设置完成之后，准备布局之前会调用一次
    private override func prepareLayout() {
        super.prepareLayout()
        
        let width = collectionView!.bounds.width / 7
        itemSize = CGSize(width: width, height: width)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = UICollectionViewScrollDirection.Horizontal

        
        // 由于CGFloat不准确, 所以不要写0.5, 可能出现只显示2两(iPhone4)
        let y = (collectionView!.bounds.height - 3 * width) * 0.45
        collectionView?.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
        
        collectionView?.pagingEnabled = true
        collectionView?.bounces = false
        collectionView?.showsHorizontalScrollIndicator = false
    }
}

class EmoticonCell: UICollectionViewCell {
    
    var emoticon :Emoticon? {
        didSet{
        
            if let path = emoticon!.imagePath{
                emoticonBtn.setImage(UIImage(named: path), forState: UIControlState.Normal);
            }else{
                emoticonBtn.setImage(UIImage(named: ""), forState: UIControlState.Normal);
            }
            
            if ((emoticon?.codeString) != nil) {
            
                emoticonBtn.setTitle(emoticon?.codeString, forState: UIControlState.Normal);
            
            }else {
            
                emoticonBtn.setTitle("", forState: UIControlState.Normal);
            }
            
            if emoticon!.removeButton {
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(emoticonBtn)
        emoticonBtn.frame = CGRectInset(bounds, 4, 4)
        emoticonBtn.backgroundColor = UIColor.whiteColor()
        emoticonBtn.userInteractionEnabled = false;
    }
    
    // MARK: - 懒加载
    private lazy var emoticonBtn : UIButton = {
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(32);
        return btn;
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}