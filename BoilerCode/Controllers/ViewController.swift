//
//  ViewController.swift
//  BoilerCode
//
//  Created by Asif Newaz on 10/4/20.
//  Copyright © 2020 Nasim Newaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var progressHUD: ProgressHUDManager?
    var otpTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }


    @IBAction func startAction(_ sender: UIButtonX) {
        self.callLoginAPI()
    }
    
    @IBAction func webAction(_ sender: UIButton) {
        let storyBoad = UIStoryboard(name: "Main", bundle: Bundle.main)
        let fundTransferVC = storyBoad.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
        self.navigationController?.show(fundTransferVC, sender: nil)
    }
    
    func startTimer() {
        otpTimer = Timer.every(5.second) {
            DispatchQueue.main.async {
                self.progressHUD?.end()
                self.otpTimer?.invalidate()
            }
        }
    }
    
    func callLoginAPI() {
        
        let email = "01744721089"
        let password = "a6w5fC/MjRQH8Fl/9CYnBNDGkFhtvQYcSw6RMRdHzr3DEPCKFBiKD44FoiH0shNlID9uzYKrKqA/BhP2y9bUxfV+rZ65v0yhIr9EQTr0P5PEOUSZkYj8F+7S/dQBnP+oBB/pQC5tn4FuUV+EpTtzAyEBwo9ivU4fxZTKdU4O/zPzrnGZ0BhbTDiHUkh2q3Ac3X7sWe78YAxkzb7lLml5RPBWEih754Ku8GzQ8q9b6bRtLgny3gewQtavfSyf/DYfzb0LdfP23v8WieSxNXJJeOpE3/2Tn15jRCgy/IeuagEEx+2UFcznIbOVEU2g2EMaKN9nWj39MlE6JNVmaARmYQ=="
        
        var parameters: [String:Any] = [String: Any]()
        parameters["username"] = email
        parameters["password"] = password
        
        parameters["DeviceName"] = UIDevice.current.name
        parameters["DeviceModel"] = UIDevice.current.model
        
        parameters["grant_type"] = "password"
        parameters["scope"] = "offline_access"
        parameters["client_id"] = "cashbabaios"
        parameters["client_secret"] = "Rcis123$..123"
        parameters["DeviceId"] = UIDevice.current.identifierForVendor!.uuidString
        parameters["DeviceToken"] = "cV9LaYCebqw:APA91bGb75IOv0hCf-BnLJGaIvoTmAw0WaYE-bJy-vrCK-9SEoOMVmH39VfeB9M3w-CkvQFbI3VRFvD63mUQcugTz2k9xwR3bfvipJlA9BgpzqmysN844sXixopodmiQnWLV2Mbubhcb"
        parameters["LoginType"] = "personal"
        
        self.progressHUD = ProgressHUDManager(view: self.view)
        self.progressHUD?.start()
        self.progressHUD?.isNeedShowSpinnerOnly = true
        
        APIManager.login(parameters:parameters,userName: email, password: password) { [weak self] result in
            switch result {
            case .success( let response, let tokenInformation, _):
                if let loginInformation = tokenInformation{
                    if let identifier = loginInformation.statusCode, identifier == 451{
                        UserDefaults.standard.set(email, forKey: "username")
                        UserDefaults.standard.synchronize()
                        self?.progressHUD?.isNeedShowSpinnerOnly = false
                        self?.progressHUD?.isNeedShowImage = true
                        self?.progressHUD?.isNeedWaitForUserAction = true
                        self?.progressHUD?.failledStatus = "Failed"
                        self?.progressHUD?.failledMessage =  "ⓘ Login failed."
                        self?.progressHUD?.onFailled()
                    } else if let identifier = loginInformation.statusCode, identifier == 422{
                        self?.progressHUD?.isNeedShowSpinnerOnly = false
                        self?.progressHUD?.isNeedShowImage = true
                        self?.progressHUD?.isNeedWaitForUserAction = true
                        self?.progressHUD?.failledStatus = "Failed"
                        self?.progressHUD?.failledMessage =  "ⓘ Login failed."
                        self?.progressHUD?.onFailled()
                      
                    }else {
                        if let role = loginInformation.role , role.lowercased() == "personal" {
                            let model = TokenInformationModel()
                            
                            if let accessToken = loginInformation.role, accessToken.isNotEmpty {
                                model.role = accessToken
                            }
                            
                            
                            if let accessToken = loginInformation.access_token, accessToken.isNotEmpty {
                                APITokenManager.saveAccessToken(accessToken: accessToken )
                                model.access_token = accessToken
                            }
                            
                            if let refreshToken = loginInformation.refresh_token, refreshToken.isNotEmpty {
                                APITokenManager.saveRefreshToken(refreshToken: refreshToken )
                                model.refresh_token = refreshToken
                            }
                            
                            if let time = loginInformation.expires_in {
                                model.expires_in = time
                                APITokenManager.saveExpiraryTime(expTime: String(time))
                            }
                            
                            if let tokenType = loginInformation.token_type,  tokenType.isNotEmpty{
                                model.token_type = tokenType
                                APITokenManager.saveTokentype(tokenType: tokenType)
                            }
                            
                            APIManager.tokenInfo = model
                            APIManager.tokenInfo?.tokenGenerationTime = Date().timeIntervalSince1970
                            APITokenManager.saveTokenGenerationTime(time: String(Date().timeIntervalSince1970))
                            
                            UserDefaults.standard.set(email, forKey: "username")
                            
                            self?.progressHUD?.isNeedShowSpinnerOnly = false
                            self?.progressHUD?.isNeedShowImage = true
                            self?.progressHUD?.isNeedWaitForUserAction = true
                            self?.progressHUD?.successStatus = "Success"
                            self?.progressHUD?.successMessage =  "ⓘ Yea."
                            self?.progressHUD?.onSucceed()
                        } else {
                            self?.progressHUD?.isNeedShowSpinnerOnly = false
                            self?.progressHUD?.isNeedShowImage = true
                            self?.progressHUD?.isNeedWaitForUserAction = true
                            self?.progressHUD?.failledStatus = "Failed"
                            self?.progressHUD?.failledMessage =  "ⓘ Login failed."
                            self?.progressHUD?.onFailled()
                        }
                        
                    }
                } else {
                    self?.progressHUD?.isNeedShowSpinnerOnly = false
                    self?.progressHUD?.isNeedShowImage = true
                    self?.progressHUD?.isNeedWaitForUserAction = true
                    self?.progressHUD?.failledStatus = "Failed"
                    self?.progressHUD?.failledMessage =  response.result.value?.message ?? "ⓘ Login failed."
                    self?.progressHUD?.onFailled()
                }
            case .failure(let response, let error):
                self?.progressHUD?.isNeedShowSpinnerOnly = false
                self?.progressHUD?.isNeedShowImage = true
                self?.progressHUD?.isNeedWaitForUserAction = true
                self?.progressHUD?.failledStatus = "Failed"
                self?.progressHUD?.failledMessage =  response?.result.value?.message ?? "ⓘ Login failed."
                self?.progressHUD?.onFailled()
                
            }
        }
        
        
    }
}

