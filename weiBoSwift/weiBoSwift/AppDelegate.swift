// MARK: - 属性
// MARK: - 构造函数
// MARK: - 准备UI
// MARK: - 懒加载

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 设置全局属性
        setGlobalProperty()
        
        // 创建window
        window = UIWindow(frame: UIScreen.bounds())
        // 界面跳转
        viewSwitch()
        // 显示
        window?.makeKeyAndVisible()
        // 设置window背景
        window?.backgroundColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application isYBUserModel.sharedInstance = YBUserModel() about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - 界面跳转
    private func viewSwitch(){
        // 判断是否登录
        if YBUserModel.userModel()?.isLogin ?? false { // 登录
            // 判断是否是新版本
            if YBIsNewVersion.isNewVersion() { // 是新版本
                window?.rootViewController = YBNewFeatureViewController()
            }else{ // 不是新版本
                window?.rootViewController = YBWelcomeViewController()
            }
        }else{ // 没有登录
            // 跳到主控制器
            window?.rootViewController = YBTabBarController()
        }
    }

    // MARK: - 设置全局属性
    private func setGlobalProperty(){
        // 设置UIBarButtonItem
        let barButtonItem = UIBarButtonItem.appearance()
        barButtonItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: UIControlState.Normal)
        // 设置barBut颜色
        barButtonItem.tintColor = UIColor.orangeColor()
    }

}

