//
//  WebViewController.swift
//  BoilerCode
//
//  Created by Asif Newaz on 11/4/20.
//  Copyright © 2020 Nasim Newaz. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    var otpUrlString : String? = "https://cashbaba.com.bd"
    var isCreditCardVerify : Bool = false
    var progressHUD: ProgressHUDManager?

    deinit {
        print("OS Recalling memory -- No retain cycle/leak!")
    }
    
    override func loadView() {
        webView =  WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = otpUrlString, let otpUrl = URL(string: url) {
            webView.load(URLRequest(url: otpUrl))
            self.progressHUD = ProgressHUDManager(view: (self.view)!)
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.progressHUD?.start()
        self.progressHUD?.isNeedShowSpinnerOnly = true
    }
    
    
    func webView(webView: WKWebView!, didFinishNavigation navigation: WKNavigation!) {
        print("didFinishNavigation: ")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString {
            print("Loaded URL: \(urlString)")
            self.title = webView.title
            if urlString.lowercased().contains("success") {
                self.progressHUD?.isNeedShowSpinnerOnly = false
                self.progressHUD?.isNeedWaitForUserAction = true
                self.progressHUD?.successStatus = "Success"
                self.progressHUD?.successMessage = "ⓘ Successfully done."
                self.progressHUD?.onSucceed({
                    self.navigationController?.popViewController(animated: true)
                })
            } else if urlString.lowercased().contains("fail") {
                self.progressHUD?.isNeedShowSpinnerOnly = false
                self.progressHUD?.isNeedWaitForUserAction = true
                self.progressHUD?.failledStatus = "Failed"
                self.progressHUD?.failledMessage = "ⓘ Response failed."
                self.progressHUD?.onFailled({
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                self.progressHUD?.end()
            }
        }
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.progressHUD?.end()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressHUD?.end()
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
