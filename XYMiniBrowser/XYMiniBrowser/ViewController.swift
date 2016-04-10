
//迷你浏览器
import UIKit
import WebKit
class ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{
    //获取设备宽高
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var webView = WKWebView()
    //下部菜单
    var downToolbar = UIToolbar()
    //网址输入框
    var textField = UITextField()
    //上部菜单
    var upBar = UIView()
    //wk配置
    let configuration = WKWebViewConfiguration()
    //全局点击按钮
    var button5 = UIButton()
    //进度条控件
    var progBar = UIProgressView()
    //设置弹出菜单的view
    var menuView = UIView()
    //创建后退按钮
    var btnBack = UIBarButtonItem()
    //创建前进按钮
    var btnForward = UIBarButtonItem()
    //设置判断旗帜
    var buttonFlag = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
        setDownToolbar()
        setUpBar()
        setProgressView()
        loadUrl("http://www.baidu.com")
        menuInit()
    }

    //设置webView
    func setWebView()
    {
        webView = WKWebView(frame: CGRectMake(0, 64, screenWidth, screenHeight-108))
        self.webView.navigationDelegate = self
        self.webView.UIDelegate = self
        self.view.addSubview(webView)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    //设置下方工具条
    func setDownToolbar()
    {
        //创建Toolbar
        downToolbar =  UIToolbar(frame:CGRectMake(0, screenHeight-44, screenWidth, 44))
        downToolbar.barTintColor = UIColor.blackColor()
        downToolbar.tintColor = UIColor.whiteColor()
        //创建后退按钮
        btnBack = UIBarButtonItem(image:UIImage(named:"back.png"),
            style:UIBarButtonItemStyle.Plain, target:self, action:#selector(ViewController.back(_:)))
        btnBack.enabled = false
        //创建分隔符1
        let btnGap1 =  UIBarButtonItem(barButtonSystemItem:.FlexibleSpace,
            target:nil,
            action:nil)
        //创建前进按钮
        btnForward = UIBarButtonItem(image:UIImage(named:"forward.png"),
            style:.Plain, target:self, action:#selector(ViewController.forward(_:)))
        btnForward.enabled = false
        //创建分隔符2
        let btnGap2 =  UIBarButtonItem(barButtonSystemItem:.FlexibleSpace,
            target:nil,
            action:nil)
        //创建菜单按钮
        let btnMenu = UIBarButtonItem(image:UIImage(named:"menu.png"),
            style:.Plain, target:self, action:#selector(ViewController.showMenu))
        //创建分隔符3
        let btnGap3 =  UIBarButtonItem(barButtonSystemItem:.FlexibleSpace,
            target:nil,
            action:nil)
        //创建主页
        let btnHome = UIBarButtonItem(image:UIImage(named:"home.png"),
            style:.Plain, target:self, action:#selector(ViewController.toHome))
        //创建分隔符4
        let btnGap4 =  UIBarButtonItem(barButtonSystemItem:.FlexibleSpace,
            target:nil,
            action:nil)
        //创建刷新按钮
        let btnRefresh = UIBarButtonItem(image:UIImage(named:"refresh.png"),
            style:.Plain, target:self, action:#selector(ViewController.Refresh))
        //添加按钮
        downToolbar.setItems( [btnBack,btnGap1, btnForward,btnGap2,btnMenu,btnGap3,btnHome,btnGap4,btnRefresh], animated:true)
        self.view.addSubview(downToolbar)
    }
    
    //设置上方区域
    func setUpBar()
    {
        //创建顶部区域
        upBar = UIView(frame:CGRectMake(0, 0, screenWidth, 64))
        upBar.backgroundColor = UIColor.blackColor()
        //创建输入框
        textField = UITextField(frame:CGRectMake(20, 20, (screenWidth*3)/4, 30))
        textField.backgroundColor = UIColor.whiteColor()
        //自动清除
        textField.clearsOnBeginEditing = true
        //创建Go按钮
        let btnGo = UIButton(frame:CGRectMake(30+(screenWidth*3)/4, 15, 30, 40))
        btnGo.setImage(UIImage(named:"go.png"), forState: UIControlState.Normal)
        btnGo.addTarget(self, action: #selector(ViewController.goToWeb), forControlEvents: UIControlEvents.TouchUpInside)
        //添加视图
        upBar.addSubview(textField)
        upBar.addSubview(btnGo)
        self.view.addSubview(upBar)
    }
    
    //设置进度条
    func setProgressView()
    {
        //创建进度工具条
        progBar = UIProgressView(progressViewStyle:UIProgressViewStyle.Bar)
        // 设置UIProgressView的大小
        progBar.frame = CGRectMake(0 , 0 , screenWidth, 30)
        progBar.progressTintColor = UIColor.greenColor()
        // 设置该进度条的初始进度为0
        progBar.progress = 0
        self.webView.addSubview(progBar)
    }
    
    //初始化弹出菜单
    func menuInit()
    {
        //创建按钮
        let button1 = addButton("添加书签", x: 0,y: 0,width: screenWidth/4,height: 75)
        let button2 = addButton("书签", x: screenWidth/4, y: 0, width: screenWidth/4, height: 75)
        let button3 = addButton("下载", x: screenWidth/2, y: 0, width: screenWidth/4, height: 75)
        let button4 = addButton("文件管理", x: 3*screenWidth/4, y: 0, width: screenWidth/4, height: 75)
        button5 = addButton("隐身模式", x: 0, y: 75, width: screenWidth/4, height: 75)
        let button6 = addButton("分享", x: screenWidth/4, y: 75, width: screenWidth/4, height: 75)
        let button7 = addButton("设置", x: screenWidth/2, y: 75, width: screenWidth/4, height: 75)
        let button8 = addButton("关于", x: 3*screenWidth/4, y: 75, width: screenWidth/4, height: 75)

        //添加视图,以webview为参照系,加载谁上面就以谁为参照系
        menuView = UIView(frame: CGRectMake(0,screenHeight-108, screenWidth, 150))
        menuView.backgroundColor = UIColor.grayColor()
        menuView.addSubview(button1)
        menuView.addSubview(button2)
        menuView.addSubview(button3)
        menuView.addSubview(button4)
        menuView.addSubview(button5)
        menuView.addSubview(button6)
        menuView.addSubview(button7)
        menuView.addSubview(button8)
        //注意添加到webView上
        self.webView.addSubview(menuView)
        //添加事件,其他按钮类似
        button5.addTarget(self, action: #selector(ViewController.privateMode), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //显示弹出菜单
    func showMenu()
    {
        if buttonFlag == 1
        {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.menuView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, -150))
            }, completion: nil)
            buttonFlag = 0
        }
        else
        {
            hideMenu()
        }
    }
    
    //隐藏按钮
    func hideMenu()
    {
        buttonFlag = 1
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.menuView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 150))
            }, completion: nil)
    }
    
    //封装添加按钮方法
    func addButton(title:String?,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat) -> UIButton
    {
        let button = UIButton(frame: CGRectMake(x, y, width, height))
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        return button
    }
    
    //网页返回
    func back(sender:UIBarButtonItem)
    {
        if self.webView.canGoBack {
            webView.goBack()
        }
    }

    //网页前进
    func forward(sender:UIBarButtonItem)
    {
        if self.webView.canGoForward {
            webView.goForward()
        }
    }
    
    //跳转指定网页
    func goToWeb()
    {
        let url = textField.text
        //判断网址是否合法
        if (url?.rangeOfString("http://")?.isEmpty != nil) ||
            (url?.rangeOfString("https://")?.isEmpty != nil) {
            loadUrl(url!)
        }
        else {
            //显示错误页面
            let url = NSBundle.mainBundle().URLForResource("404", withExtension: "html")
            self.webView.loadRequest(NSURLRequest(URL: url!))
        }
    }

    //加载指定网址
    func loadUrl(url:String?)
    {
        let nsurl = NSURL(string: url!)
        let request = NSURLRequest(URL: nsurl!)
        self.webView.loadRequest(request)
    }
    
    //主页按钮事件
    func toHome() {
        let url = NSBundle.mainBundle().URLForResource("MyHome", withExtension: "html")
        self.webView.loadRequest(NSURLRequest(URL: url!))
    }

    //监听
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if(self.webView.estimatedProgress >= 1.0) {
                UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    self.progBar.alpha = 0.0
                    }, completion: { (finished:Bool) -> Void in
                        self.progBar.progress = 0
                })
            }
        }
    }
    
    //重新加载网页
    func Refresh() {
        self.webView.reload()
    }
    
    //隐身模式
    func privateMode() {
        if configuration.websiteDataStore.persistent {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistentDataStore()
            button5.setTitleColor(UIColor(red: 0, green: 255, blue: 255, alpha: 1.0), forState: UIControlState.Normal)
        }
        else {
            configuration.websiteDataStore = WKWebsiteDataStore.defaultDataStore()
            button5.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        showMenu()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        //收起键盘
        textField.resignFirstResponder()
    }
    
    //js提示框
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "好", style: .Default, handler: { (_) -> Void in
            completionHandler()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //js确认框
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确认", style: .Default, handler: { (_) -> Void in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: { (_) -> Void in
            completionHandler(false)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //js文本输入框
    func webView(webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.textColor = UIColor.redColor()
        }
        alert.addAction(UIAlertAction(title: "好", style: .Default, handler: { (_) -> Void in
            completionHandler(alert.textFields![0].text!)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //允许点击
    func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if !(navigationAction.targetFrame?.mainFrame != nil) {
            self.webView.loadRequest(navigationAction.request)
        }
        return nil
    }

    //处理网页完成事件
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        //判断是否可以前进和后退
        if self.webView.canGoForward {
            btnForward.enabled = true
        }
        else {
            btnForward.enabled = false
        }
        
        if self.webView.canGoBack {
            btnBack.enabled = true
        }
        else {
            btnBack.enabled = false
        }
        textField.text = self.webView.title
    
}

    //KVO一定要销毁!
    override func viewWillDisappear(animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}