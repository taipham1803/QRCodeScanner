//
//  ContentViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {
//    var titleView:String = "default"

    var stringUrl:String = "https://www.google.com.vn"
    @IBOutlet weak var webViewContent: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = titleView

        let url = URL (string: stringUrl)
        let requestObj = URLRequest(url: url!)
        webViewContent.loadRequest(requestObj)
        
//        playInGoogleMap(urlLocation: "https://www.google.com/maps/place/144+Xuân+Thủy,+Dịch+V%E1%BB%8Dng+Hậu,+Cầu+Giấy,+Hà+Nội/@21.036662,105.7789453,17z/data=!4m13!1m7!3m6!1s0x313454b55b011e49:0xe4557d60d7009b61!2zMTQ0IFh1w6JuIFRo4buneSwgROG7i2NoIFbhu41uZyBI4bqtdSwgQ-G6p3UgR2nhuqV5LCBIw6AgTuG7mWk!3b1!8m2!3d21.036662!4d105.781134!3m4!1s0x313454b55b011e49:0xe4557d60d7009b61!8m2!3d21.036662!4d105.781134")
    }
    
    func playInGoogleMap(urlLocation: String){
        UIApplication.shared.openURL(URL(string:urlLocation)!)
    }
    
    func playInYoutube(youtubeId: String) {
        if let youtubeURL = URL(string: "youtube://\(youtubeId)"),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeId)") {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
