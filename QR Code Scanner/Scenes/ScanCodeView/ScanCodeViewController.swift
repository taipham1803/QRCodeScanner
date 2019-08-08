//
//  ScanCodeViewController.swift
//  QR Code Scanner
//
//  Created by Tai Pham on 7/19/19.
//  Copyright © 2019 Tai Pham. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import PopupDialog

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChildViewController(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    func remove() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

class ScanCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    enum CameraType {
        case Front
        case Back
    }
    

    @IBOutlet weak var modalBottomContent: UIView!
    //    var cameraCheck = CameraType.Back
//    
//    func addVideoInput() {
//        if cameraCheck ==  CameraType.Front  {
//            cameraCheck = CameraType.Back
//            let device: AVCaptureDevice = self.deviceWithMediaTypeWithPosition(AVMediaTypeVideo, position: AVCaptureDevice.Position.Front)
//            do {
//                let input = try AVCaptureDeviceInput(device: device)
//                if self.captureSession.canAddInput(input) {
//                    self.captureSession.addInput(input)
//                }
//            } catch {
//                print(error)
//            }
//        }else{
//            cameraCheck = CameraType.Front
//            let device: AVCaptureDevice = self.deviceWithMediaTypeWithPosition(AVMediaTypeVideo, position: AVCaptureDevice.Position.Back)
//            do {
//                let input = try AVCaptureDeviceInput(device: device)
//                if self.captureSession.canAddInput(input) {
//                    self.captureSession.addInput(input)
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }

    @IBOutlet var modalView: UIView!
    @IBOutlet weak var viewGroupTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblShowContentCode: UILabel!
    @IBOutlet weak var lblTypeDetected: UILabel!
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var imgView: UIImageView = UIImageView()
    var imagePicker: UIImagePickerController!
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var typeContentDetected:String = ""
    var stringContent:String = "default"
    var typeLink: String = ""
    let titleModal = "THIS IS THE DIALOG TITLE"
    let message = "This is the message section of the popup dialog default view"
    let image = UIImage(named: "pexels-photo-103290")
    let arrayOptionOpen = ["Open in Youtube", "Open in Safari", "Copy this link"]
    var isOpenFlash: Bool = false
    
    let buttonOne = CancelButton(title: "CANCEL") {
        print("You canceled the car dialog.")
    }
    
    let buttonTwo = DefaultButton(title: "ADMIRE CAR", dismissOnTap: false) {
        print("What a beauty!")
    }
    
    let buttonThree = DefaultButton(title: "BUY CAR", height: 60) {
        print("Ah, maybe next time :)")
    }
    
    @IBAction func btnCloseBottomModal(_ sender: Any) {
        hideTableOptionOpen()
    }
    
    @IBAction func btnAgain(_ sender: Any) {
        captureSession.stopRunning()
        captureSession.startRunning()
    }
    
    @IBAction func btnOpenContent(_ sender: Any) {
        print("Press button btnOpenContent")
        if(stringContent != "default"){
            guard let content = URL(string: stringContent) else {
                return
            }
            UIApplication.shared.open(content)

        }
    }
    
    @IBAction func btnSwitchCamera(_ sender: Any) {
//        self.camera = nil
//
//        self.initializeCamera()
//        self.establishVideoPreviewArea()
//
//        if isBackCamera == true {
//            isBackCamera = false
//            self.camera?.cameraCheck = CameraType.Front
//        }else{
//            isBackCamera = true
//            self.camera?.cameraCheck = CameraType.Back
//        }
    }
    
    @IBAction func btnFlash(_ sender: Any) {
        if(isOpenFlash){
            isOpenFlash = false
        } else {
            isOpenFlash = true
        }
        ScanManager.shared.toggleTorch(on: isOpenFlash)
    }
    
    @IBAction func btnFromLibrary(_ sender: UIButton) {
        self.openGallary()
    }
    
    let pasteboard = UIPasteboard.general
    @IBAction func btnCopy(_ sender: Any) {
        ScanManager.shared.displayToastMessage("Copied to clipboard")
        pasteboard.string = stringContent
    }
    
    @IBAction func btnSafari(_ sender: Any) {
        guard let url = URL(string: stringContent) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnChrome(_ sender: Any) {
//        guard let url = URL(string: stringContent) else { return }
//        UIApplication.shared.open(url)
        
//        openFacebook(facebookUrl: "https://www.facebook.com/cu0ngkimgiang")
//        openInstagram(instagramUrl: "https://www.instagram.com/quynhanhyoonaa/")
//        playInYoutube(youtubeUrl: "https://www.youtube.com/watch?v=r0cUKpE-Nnc")
//        let sUrl = "googlechrome://www.google.com"
//        UIApplication.shared.openURL(NSURL(string: sUrl) as! URL)
        openOnChrome(urlSource: "https://emddi.com")
    }
    
    func openOnChrome(urlSource: String){
        var urlChrome = ""
        if(urlSource.prefix(7).contains("http")){
            urlChrome = urlSource.replacingOccurrences(of: "http://", with: "googlechrome://")
        } else if (urlSource.prefix(7).contains("https")){
            urlChrome = urlSource.replacingOccurrences(of: "https://", with: "googlechrome://")
        } else {
            urlChrome = "googlechrome://" + urlSource
        }
        guard let url = URL(string: urlChrome) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        let text = stringContent
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        buildModalView()
        buildViewGroupTop()
        autoCapture()
//        let popup = PopupDialog(title: titleModal, message: message, image: image)
//        popup.addButtons([buttonOne, buttonTwo, buttonThree])
//        self.present(popup, animated: true, completion: nil)
        
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().backgroundColor = UIColor.white
//
//        let tabbar = UITabBar.appearance()
//        tabbar.shadowImage = UIImage()
//        tabbar.isTranslucent = false
//        tabbar.backgroundImage = UIImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func buildViewGroupTop(){
        viewGroupTop.layer.cornerRadius = 25
    }
    
    func buildModalView(){
        modalView.layer.cornerRadius = 5
        modalView.backgroundColor = .white
        modalView.layer.shadowColor = UIColor.gray.cgColor
        modalView.layer.shadowOpacity = 1
        modalView.layer.shadowOffset = CGSize.zero
        modalView.layer.shadowRadius = 5
    }
    
    func animateIn(){
        let theHeight = view.frame.size.height
        let heightSubView = CGFloat(integerLiteral: 240)
        modalView.frame = CGRect(x: 20, y: theHeight - heightSubView - 100 , width: self.view.frame.width - 40, height: heightSubView)
        modalView.layer.cornerRadius = 12
    
//        let size = 260
//        let screenWidth = self.view.frame.size.width
//
//        let frame = CGRectMake((screenWidth / 2) - CGFloat((size / 2)), 30, size, size)
//        let draggableView = DraggableView(frame: frame)
//
//        self.view.addSubview(draggableView)
//        
//        modalView.center.x = view.center.x
        self.view.addSubview(modalView)
        let transition = CATransition()
        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        transition.type = .moveIn
//        transition.subtype = .fromTop
        modalView?.layer.add(transition, forKey: kCATransition)
        modalView.alpha = 0
        
        UIView.animate(withDuration: 0.4){
            self.modalView.alpha = 1
            self.modalView.transform = CGAffineTransform.identity
        }
    }
    
    func hideTableOptionOpen(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.modalView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
        }){ (success:Bool) in
            self.modalView.removeFromSuperview()
        }
    }
    
    func loadModalOpen() {
        let modalVC = ModalViewController()
        let rect = CGRect(x: view.frame.origin.x, y: view.frame.maxY - modalVC.view.frame.maxY, width: view.frame.maxX, height: 400)
        add(modalVC, frame: rect)
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
        previewLayer.frame = CGRect(x: 0.0, y: 25, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (tabBarController?.tabBar.frame.size.height)! - 35)
        previewLayer.cornerRadius = 16
//        previewLayer.layer.cornerRadius = 25
        previewLayer.backgroundColor = UIColor.red.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.addSubview(viewGroupTop)
        captureSession.startRunning()
    }
   
    
    func checkContentFromCode(content: String){
        let contentUse = content.lowercased()
//        if(extractPhoneNumber(content: content).count>1){
//            typeContentDetected = "Phone Number"
//        }
        if(contentUse.prefix(6).contains("tel:")){
            typeContentDetected = "Phone Number"
        }else if(contentUse.prefix(6).contains("wifi")){
            typeContentDetected = "WIFI"
        } else if(contentUse.prefix(6).contains("smsto:")){
            typeContentDetected = "SMS"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.mailRegEx.rawValue, in: contentUse).count>0){
            typeContentDetected = "Email"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.youtubeRegex.rawValue, in: contentUse).count>0){
            typeContentDetected = "Youtube"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.facebookRegEx.rawValue, in: contentUse).count>0){
            typeContentDetected = "Facebook"
        } else if(contentUse.prefix(40).contains("maps.google.com") || contentUse.prefix(40).contains("www.google.com/maps")){
            typeContentDetected = "Google Map"
        } else if(checkTypeContent(for: ConstantManager.RegexValidate.urlRegEx.rawValue, in: contentUse).count>0){
            typeContentDetected = "URL"
        } else {
            typeContentDetected = "Text"
            print("This is another case!")
        }
        lblShowContentCode.text = content
        lblTypeDetected.text = typeContentDetected
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
    
    func checkTypeContent(for regex: String, in text: String) -> [String] {
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
//        UIApplication.shared.openURL(URL(string:urlLocation)!)
        
        if let urlValidate = URL(string: urlLocation),
            UIApplication.shared.canOpenURL(urlValidate) {
            UIApplication.shared.open(urlValidate, options: [:], completionHandler: nil)
        }
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
    
    func openFacebook(facebookUrl: String) {
        guard let url = URL(string: facebookUrl)  else { return }
        if UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    func openInstagram(instagramUrl: String) {
//        guard let url = URL(string: "https://instagram.com/\(instagramHandle)")  else { return }
        guard let url = URL(string: instagramUrl)  else { return }
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

        if let features = self.detectQRCode(image), !features.isEmpty{
            for case let row as CIQRCodeFeature in features{
                print(row.messageString ?? "nope")
                stringContent = row.messageString ?? "Can not scan this code!"
            }
        }
        picker.dismiss(animated: true, completion: nil)
        checkContentFromCode(content: stringContent)
        animateIn()
        let newScan = Scan.init(id: ScanManager.shared.historyScan.count, content: stringContent, type: typeContentDetected)
        ScanManager.shared.saveNewScanResult(scan: newScan)
        
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
//        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            if(stringValue != stringContent){
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                found(code: stringValue)
            }
        }
        
        dismiss(animated: true)
    }
    
    func found(code: String) {
        print(code)
        checkContentFromCode(content: code)
        stringContent = code
        animateIn()
        let newScan = Scan.init(id: ScanManager.shared.historyScan.count, content: stringContent, type: typeContentDetected)
        ScanManager.shared.saveNewScanResult(scan: newScan)
        
//        self.performSegue(withIdentifier: "segueScanToContent", sender: 1)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
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
        default:
            break
        }
    }
}
