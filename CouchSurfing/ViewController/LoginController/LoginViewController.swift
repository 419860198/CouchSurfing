//
//  LoginViewController.swift
//  CouchSurfing
//
//  Created by monstar on 2016/12/7.
//  Copyright © 2016年 monstar. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: NavigationViewController {
    
    fileprivate let appIcon:UIImageView = {
        let image = UIImageView(image: UIImage(named: "appIcon"))
        return image
    }()
    
    fileprivate let accountInputView:UITextField = {
        let field = UITextField()
        field.placeholder = "请输入手机号"
        field.borderStyle = UITextBorderStyle.roundedRect
        field.tintColor = ScreenUI.tinBlackColor
        field.keyboardType = UIKeyboardType.phonePad
        
        return field
    }()
    
    fileprivate let captchaInputView:UITextField = {
        let field = UITextField()
        field.placeholder = "请输入验证码"
        field.borderStyle = UITextBorderStyle.roundedRect
        field.tintColor = ScreenUI.tinBlackColor
        
        return field
    }()
    
    fileprivate let getCaptchaBtn:UIButton = {
        let btn = UIButton()
        btn.setTitle("获取验证码", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = ScreenUI.mainColor
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = 5.0
        
        return btn
    }()
    
    fileprivate let loginBtn:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = ScreenUI.mainColor
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitle("立即登录", for: .normal)
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.automaticallyAdjustsScrollViewInsets = false
        self.extendedLayoutIncludesOpaqueBars = false
        
        initUI()
        setActionForUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - private func
extension LoginViewController{
    func initUI() {
        titleStr = "登录"
        view.backgroundColor = UIColor.white
        //image
        view.addSubview(appIcon)
        appIcon.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(navigationView.snp.bottom).offset(30)
        }
        //account input view
        view.addSubview(accountInputView)
        accountInputView.snp.makeConstraints { (make) in
            make.width.equalTo(290)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(appIcon.snp.bottom).offset(30)
        }
        // captch input view
        view.addSubview(captchaInputView)
        captchaInputView.snp.makeConstraints { (make) in
            make.left.equalTo(accountInputView)
            make.height.equalTo(accountInputView)
            make.top.equalTo(accountInputView.snp.bottom).offset(10)
        }
        // getCaptcha btn
        view.addSubview(getCaptchaBtn)
        getCaptchaBtn.snp.makeConstraints { (make) in
            make.right.equalTo(accountInputView)
            make.left.equalTo(captchaInputView.snp.right).offset(16.0)
            make.height.equalTo(accountInputView)
            make.top.equalTo(captchaInputView)
            make.width.equalTo(captchaInputView)
        }
        //login btn
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.width.equalTo(view)
            make.centerX.equalTo(view)
            make.height.equalTo(49)
        }
        
        
    }
    
    func setActionForUI() {
        getCaptchaBtn.addTarget(self, action: #selector(LoginViewController.captchaBtnDidClicked(_:)), for: .touchUpInside)
        loginBtn.addTarget(self, action: #selector(LoginViewController.loginBtnDidClicked(_:)), for: .touchUpInside)
    }
}

//MARK: - action
extension LoginViewController{
    func captchaBtnDidClicked(_ btn:UIButton) {
    }
    
    func loginBtnDidClicked(_ btn:UIButton) {
        
    }
    
}
