//
//  ScanCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit
import AVFoundation

class ScanCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imgViewGallery: UIImageView!
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var lblContentImage: UILabel!
    @IBOutlet weak var btnOpen: UIButton!
    
    var stringContent:String = "default"
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imgView: UIImageView = UIImageView()
    var imagePicker: UIImagePickerController!
    let mailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
    let youtubeRegex = "(http(s)?:\\/\\/)?(www\\.|m\\.)?youtu(be\\.com|\\.be)(\\/watch\\?([&=a-z]{0,})(v=[\\d\\w]{1,}).+|\\/[\\d\\w]{1,})"
    let facebookRegEx = "(http(s)?:\\/\\/)?(www\\.|m\\.)?f(acebook\\.com|b\\.com)"
    var typeLink: String = ""
    
    @IBAction func btnAgain(_ sender: Any) {
        lblContentImage.text = ""
        captureSession.stopRunning()
        captureSession.startRunning()
    }
    
    @IBAction func btnOpenContent(_ sender: Any) {
        print("Press button btnOpenContent")
        if(stringContent != "default"){
            guard let number = URL(string: stringContent) else { return }
            UIApplication.shared.open(number)
//            self.performSegue(withIdentifier: "segueScanToContent", sender: 1)
//            if(typeLink == "facebook"){
//
//            } else if(typeLink == "youtube"){
//
//            } else if(typeLink == "email"){
//
//            } else if(typeLink == "phonenumber"){
//
//            } else if(typeLink == "web"){
//                self.performSegue(withIdentifier: "segueScanToContent", sender: 1)
//            } else {
//
//            }
        }
    }
    
    @IBAction func btnFromLibrary(_ sender: UIButton) {
        self.openGallary()

        print("Press button btnFromLibrary")
//        btnFromLibrary.setTitleColor(UIColor.white, for: .normal)
//        btnFromLibrary.isUserInteractionEnabled = true
        
//        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
        
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallary()
//        }))

//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func btnHistoryScan(_ sender: Any) {
        self.performSegue(withIdentifier: "segueScanToHistory", sender: 1)
//        if let features = self.detectQRCode(UIImage(named: "qrcode")), !features.isEmpty{
//            for case let row as CIQRCodeFeature in features{
//                print(row.messageString ?? "nope")
//                stringContent = row.messageString ?? "Can not scan this code!"
//            }
//        }
        print("Press button btnHistoryScan")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        autoCapture()
//        let content = "Good morning, 627137152 \n Good morning, +34627217154 \n Good morning, 627 11 71 54"
//        let contentPhone = "tel:+84869898203"
//        if(checkContainPhoneNo(content: contentPhone)){
//            print("This string contain phone number")
//        } else {
//            print("This string have no phone number")
//        }

    }
    
    func autoCapture(){
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0.0, y: 0.0, width: 400.0, height: 550)
        previewLayer.backgroundColor = UIColor.red.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
//        videoPreview.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    func checkContentFromCode(content: String){
        print("Check content: ", content)
        
        if(extractPhoneNumber(content: content).count>1){
            typeLink = "phonenumber"
            print("This is a phone number")
            btnOpen.setTitle("Call this number",for: .normal)
        } else if(matchesUrl(for: mailRegEx, in: content).count>0){
            typeLink = "email"
            print("This is a email")
            btnOpen.setTitle("Send a email",for: .normal)
        } else if(matchesUrl(for: youtubeRegex, in: content).count>0){
            typeLink = "youtube"
            print("This is a url youtube")
            btnOpen.setTitle("Open in youtube",for: .normal)
        } else if(matchesUrl(for: facebookRegEx, in: content).count>0){
            typeLink = "facebook"
            print("This is a url facebook")
            btnOpen.setTitle("Open in Facebook",for: .normal)
        } else if(matchesUrl(for: urlRegEx, in: content).count>0){
            typeLink = "web"
            print("This is a url")
            btnOpen.setTitle("Open this url",for: .normal)
        } else {
            print("This is another case!")
        }
        
//        print("Check matchesEmail: ", matchesUrl(for: urlRegEx, in: content))
    }
    
    func extractPhoneNumber(content: String) -> String {
        let tempphone = content.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        if(tempphone.count>4 && tempphone.count < 15){
            print(tempphone)
            return tempphone
        } else {
            return ""
        }
    }
    
    func matchesUrl(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            print("\(results)")
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func playInGoogleMap(urlLocation: String){
        UIApplication.shared.openURL(URL(string:urlLocation)!)
    }
    
    func playInYoutube(youtubeUrl: String) {
        if let youtubeURL = URL(string: youtubeUrl),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: youtubeUrl) {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    func playInFacebook(facebookUrl: String) {
        if let youtubeURL = URL(string: facebookUrl),
            UIApplication.shared.canOpenURL(youtubeURL) {
            // redirect to app
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        } else if let youtubeURL = URL(string: facebookUrl) {
            // redirect through safari
            UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
        }
    }
    
    
    func openInstagram(instagramHandle: String) {
        guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("Run on imagePickerController")
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgViewGallery.image = image
        
        if let features = self.detectQRCode(image), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                print(row.messageString ?? "nope")
                lblContentImage.text = row.messageString ?? "nope"
                stringContent = row.messageString ?? "Can not scan this code!"
            }
        }
        checkContentFromCode(content: stringContent)
        
        picker.dismiss(animated: true, completion: nil)
//        picker.dismiss(animated: true) {
//            self.performSegue(withIdentifier: "segueScanToContent", sender: 1)
//        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated:  true, completion: nil)
    }

    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func detectQRCode(_ image: UIImage?) -> [CIFeature]? {
        if let image = image, let ciImage = CIImage.init(image: image){
            var options: [String: Any]
            let context = CIContext()
            options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let qrDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: options)
            if ciImage.properties.keys.contains((kCGImagePropertyOrientation as String)){
                options = [CIDetectorImageOrientation: ciImage.properties[(kCGImagePropertyOrientation as String)] ?? 1]
            }else {
                options = [CIDetectorImageOrientation: 1]
            }
            let features = qrDetector?.features(in: ciImage, options: options)
            return features
        }
        return nil
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        stringContent = code
        lblContentImage.text = code 
        
//        self.performSegue(withIdentifier: "segueScanToContent", sender: 1)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    @IBAction func backToScanCodeView(segue:UIStoryboardSegue){
        print("press cancel to back scan code view")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "segueScanToContent":
//            print(segue.destination)
            if let vc = segue.destination as? UINavigationController {
                if let vcRoot = vc.viewControllers.first as? ContentViewController {
                    vcRoot.title = stringContent
                    vcRoot.stringUrl = stringContent
                }
            }
        case "segueScanToHistory":
            print(segue.destination)
            if let vc = segue.destination as? UINavigationController {
//                vc.title = stringContent
            }
        default:
            break
        }
    }
}
