//
//  YBSendViewController.swift
//  weiBoSwift
//
//  Created by MAC on 15/12/9.
//  Copyright © 2015年 MAC. All rights reserved.
//

import UIKit
import SVProgressHUD

class YBSendViewController: UIViewController {

    // MARK: - 属性
    /// toolBar底边约束
    var toolBarConstant: NSLayoutConstraint?
    
    /// 点击图片的索引（如果是直接添加图片索引为100）
    private var imageIndex = 100
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // 准备UI
        prepareUI()
        // 通知
        setterNotification()
    }
    
    // MARK: - 通知
    private func setterNotification(){
        
        
//        weak var weakSelf = self
//        // textView文字改变通知
//        NSNotificationCenter.defaultCenter().addObserverForName(UITextViewTextDidChangeNotification, object: nil, queue: nil) {[unowned self] (_) -> Void in
//            weakSelf?.navigationItem.rightBarButtonItem?.enabled = self.textView.text.characters.count != 0
//        }
//        
//        // 监听键盘代理
//        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillChangeFrameNotification, object: nil, queue: nil) {[unowned self] (notification) -> Void in
//            // 获取时间
//            let time = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
//            // 获取变化后的位置
//            let kayboardY = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue.origin.y
//            
//            weakSelf?.toolBarConstant?.constant = -(UIScreen.height() - kayboardY)
//            // 动画
//            UIView.animateWithDuration(time, animations: {[unowned self] () -> Void in
//                self.toolBar.layoutIfNeeded()
//            })
//        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textViewTextDidChangeNotification", name: UITextViewTextDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrameNotification:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 相册展现通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "popImageLib:", name: "YBSendImageViewPresentNotification", object: nil)
    }
    
    func textViewTextDidChangeNotification (){
        navigationItem.rightBarButtonItem?.enabled = self.textView.text.characters.count != 0
    }
    
    func keyboardWillChangeFrameNotification (notification: NSNotification){
         // 获取时间
        let time = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        // 获取变化后的位置
        let kayboardY = notification.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue.origin.y
        self.toolBarConstant?.constant = -(UIScreen.height() - kayboardY)
        // 动画
        UIView.animateWithDuration(time, animations: {[unowned self] () -> Void in
            self.toolBar.layoutIfNeeded()
        })
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 设置导航栏
        setNavBar()
        // textView
        view.addSubview(textView);
        textView.ff_Fill(view)
        // toolBar
        view.addSubview(toolBar)
        let cons = toolBar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.width(), height: 44), offset: CGPoint(x: 0, y: 0))
        // 获取底边约束
        toolBarConstant = toolBar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
    }
    
    /// 设置导航栏
    private func setNavBar(){
        // 设置左边按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Plain, target: self, action: "leftBarButtonItemClick")
        // 设置右边导航栏
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "rightBarButtonItemClick")
        navigationItem.rightBarButtonItem?.enabled = false
        // 设置中间
        navigationItem.titleView = navCenterView
    }
    
    // MARK: - 按钮点击事件
    /// 导航栏左边按钮点击
    @objc private func leftBarButtonItemClick(){
        textView.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// 导航栏右边按钮点击
    @objc private func rightBarButtonItemClick(){
        var text: String = ""
        textView.attributedText.enumerateAttributesInRange(NSRange(location: 0, length: textView.attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) {[unowned self] (dic, range, _) -> Void in
            if dic["NSAttachment"] != nil { // 附件
                text += (dic["NSAttachment"] as! YBTextAttachment).emotionName!
            } else { // 普通通文字或者emoji
                // 获取属性字符串
                text += (self.textView.attributedText.string as NSString).substringWithRange(range)
            }
        }
        // 发微薄(判断是否有图片)
        if textView.imageCollectionView.dataArr.count > 1 { // 有图片
            YBNetworking.sharedInstance.sendWeiBo(text, image: textView.imageCollectionView.dataArr[0], finish: { (isSeccess) -> () in
                if isSeccess {
                    SVProgressHUD.showSuccessWithStatus("发送成功")
                } else{
                    SVProgressHUD.showErrorWithStatus("发送失败")
                }
            })
        } else { // 没有图片
            YBNetworking.sharedInstance.sendWeiBo(text) { (isSeccess) -> () in
                if isSeccess {
                    SVProgressHUD.showSuccessWithStatus("发送成功")
                } else{
                    SVProgressHUD.showErrorWithStatus("发送失败")
                }
            }
        }
    }
    
    // MARK: - 弹出图片库
    @objc private func popImageLib(notification: NSNotification){
        // 判断是否有数据
        if notification.userInfo != nil {
            imageIndex = Int(notification.userInfo!["index"] as! NSNumber)
        }else{
            imageIndex = 100
        }
        
        // 判断图片相册是否可用
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            SVProgressHUD.showErrorWithStatus("相册不可用")
            return
        }
        // 创建图片控制器
        let imagePicker = UIImagePickerController()
        // 设置代理
        imagePicker.delegate = self
        // 展现
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - 懒加载
    /// 导航栏中间
    private lazy var navCenterView: UILabel = {
        let lable = UILabel()
        let text = "xxx"
        let attStr = NSMutableAttributedString(string: text)
        attStr.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor.orangeColor()], range: NSRange(location: 0, length:3))
        attStr.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(12), NSForegroundColorAttributeName:UIColor.grayColor()], range: NSRange(location: 3, length: text.characters.count - 3))
        lable.attributedText = attStr
        lable.numberOfLines = 0
        lable.textAlignment = .Center
        lable.sizeToFit()
        return lable
    }()
    
    /// textView
    private lazy var textView: YBSendTextView = {
        let textView = YBSendTextView()
        return textView;
    }()
    
    /// 工具条
    private lazy var toolBar: YBSendToolBar = {
        let toolBar = YBSendToolBar()
        toolBar.ybDelegate = self
        return toolBar
    }()
    
    /// 对象销毁
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

/// 代理
extension YBSendViewController: YBSendToolBarDelegate, YBEmotionKeyboardViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// 工具条点击代理
    func sendToolBar(toolBar: YBSendToolBar, clickStatus: YBSendToolBarStatus) {
        // 判断当前状态
        if clickStatus == YBSendToolBarStatus.Emotion { // 表情
            textView.resignFirstResponder()
            let inputView = YBEmotionKeyboardView.sharedInstance
            inputView.ybDelegate = self
            textView.inputView = inputView
            // 通知textView复位
            inputView.reset()
            textView.becomeFirstResponder()
        } else if clickStatus == .Keyboard { // 键盘
            textView.resignFirstResponder()
            textView.inputView = nil
            textView.becomeFirstResponder()
        } else if clickStatus == .Picture { // 图片
            // 图片点击通知
            NSNotificationCenter.defaultCenter().postNotificationName("YBSendToolBarImageClickNotification", object: nil)
        }
    }
    
    /// 点击表情调用
    func emotionKeyboardView(keyboardView: YBEmotionKeyboardView, emotionModel: YBEmotionModel) {
        // 判断删除按钮
        if emotionModel.deleteStr != nil {
            textView.deleteBackward()
            return
        }
        // emoji 表情
        if emotionModel.code != nil {
            textView.insertText(emotionModel.code!)
            return
        }
        //------- 普通表情 ---------//
        // 创建附件
        let textAttachment = YBTextAttachment()
        // 设置文字
        textAttachment.emotionName = emotionModel.chs
        // 添加图片
        textAttachment.image = UIImage(named: emotionModel.png!)
        // 获取字体高度
        let textHeight = textView.font!.lineHeight
        // 设置附件大小
        textAttachment.bounds = CGRect(x: 0, y: -5, width: textHeight, height: textHeight)
        // 创建属性字符串
        let newAttStr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: textAttachment))
        // 设置属性字符串大小
        newAttStr.addAttribute(NSFontAttributeName, value: textView.font!, range: NSRange(location: 0, length: 1))
        // 获取文本属性字符串
        let oldAttStr = NSMutableAttributedString(attributedString: textView.attributedText)
        // 插入数据
        oldAttStr.replaceCharactersInRange(textView.selectedRange, withAttributedString: newAttStr)
        // 赋值
        textView.attributedText = oldAttStr
        // 手动发送通知（占位符）
        textView.textViewDidChange(textView)
        NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: nil)
    }
    
    // MARK: - 图片展现代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // 宽度
        let minImage = image.image(300, maxHeight: 300)
        // 通知讲图片发送过去
        NSNotificationCenter.defaultCenter().postNotificationName("UIImagePickerControllerGetImageNotification", object: nil, userInfo: ["image" : minImage, "index": imageIndex])
        // 退出
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
