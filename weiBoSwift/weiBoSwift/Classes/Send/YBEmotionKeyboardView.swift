// 底部 44
// page 30

import UIKit

// 点击调用
protocol YBEmotionKeyboardViewDelegate: NSObjectProtocol {

    // 点击调用
    func emotionKeyboardView(keyboardView: YBEmotionKeyboardView, emotionModel: YBEmotionModel)
}

class YBEmotionKeyboardView: UIView {

    // MARK: - 属性
    /// 单利
    static let sharedInstance = YBEmotionKeyboardView()
    
    /// 代理
    var ybDelegate: YBEmotionKeyboardViewDelegate?
    
    /// 数据
    private let dataArr = YBEmotionGroupModel.emotionGroupModels()
    
    // 当前分组
    private var currentSection = 1
    
    // MARK: - 构造函数
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width(), height: UIScreen.width() / 7 * 3 + 74))
        // 准备UI
        prepareUI()
        // 设置数据
        setData()
        
        backgroundColor = UIColor.orangeColor()
        // 初始化page
        pageControl.numberOfPages = dataArr?[1].pageNum ?? 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 准备UI
    private func prepareUI(){
        // 底部表情组
        addSubview(emotionGroupView)
        emotionGroupView.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: self, size: CGSize(width: UIScreen.width(), height: 44))
        // pageControl
        addSubview(pageControl)
        pageControl.ff_AlignVertical(type: ff_AlignType.TopLeft, referView: emotionGroupView, size: CGSize(width: UIScreen.width(), height: 29))
        // 表情
        addSubview(emotionView)
        emotionView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: emotionView, attribute: .Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emotionView, attribute: .Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emotionView, attribute: .Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emotionView, attribute: .Bottom, relatedBy: NSLayoutRelation.Equal, toItem: pageControl, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
    }
    
    // MARK: - 复位
    func reset(){
        // page
        pageControl.currentPage = 0
        pageControl.numberOfPages = dataArr?[0].pageNum ?? 0
        // 组
        emotionGroupView(emotionGroupView, index: 1)
        // 表情
        emotionGroupView.selIndex = 1
    }
    
    // MARK: - 设置数据
    private func setData(){
        emotionGroupView.dataArr = dataArr
        emotionView.dataArr = dataArr
    }
    
    // MARK: - 懒加载
    /// 底部表情zu
    private lazy var emotionGroupView: YBEmotionGroupView = {
        let view = YBEmotionGroupView()
        view.ybDelegate = self
        return view
    }()
    
    /// pageControl
    private lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.backgroundColor = UIColor.whiteColor()
        view.pageIndicatorTintColor = UIColor.grayColor()
        view.currentPageIndicatorTintColor = UIColor.orangeColor()
        view.userInteractionEnabled = false
        return view
    }()
    
    /// 表情
    private lazy var emotionView: YBEmotionView = {
        let view = YBEmotionView()
        view.ybDelegate = self
        return view
    }()
}

extension YBEmotionKeyboardView: YBEmotionGroupViewDelegate, YBEmotionViewDelegate {
    
    /// 底部点击调用
    func emotionGroupView(emotionGroupView: YBEmotionGroupView, index: Int) {
        // 转换表情库
        emotionView.selectItemAtIndexPath(NSIndexPath(forItem: 0, inSection: index), animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        // 设置page
        pageControl.numberOfPages = self.dataArr![index].pageNum
        pageControl.currentPage = 0
        currentSection = index
    }
    
    /// 顶部滑动调用
    func emotionView(emotionView: YBEmotionView, indexPath: NSIndexPath) {
        // 改变page
        pageControl.currentPage = indexPath.item
        // 改变底部
        if indexPath.section != currentSection {
            pageControl.numberOfPages = dataArr![indexPath.section].pageNum
            emotionGroupView.selIndex = indexPath.section
            currentSection = indexPath.section
        }
    }
    
    /// 点击调用
    func emotionView(emotionView: YBEmotionView, emotionModel: YBEmotionModel) {
        // 如果是空直接返回
        if emotionModel.png == nil && emotionModel.code == nil && emotionModel.deleteStr == nil {
            return
        }
        ybDelegate?.emotionKeyboardView(self, emotionModel: emotionModel)
    }
}
