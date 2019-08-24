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
import CoreData
import AudioToolbox

extension UIDevice {
    static var isHapticsSupported : Int {
        let feedback = UIImpactFeedbackGenerator(style: .heavy)
        feedback.prepare()
        var string = feedback.debugDescription
        string.removeLast()
        let number = string.suffix(1)
        if number == "1" {
            return 1
        } else if number == "2" {
            return 2
        } else {
            return 0
        }
    }
}

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
    
//    @IBOutlet weak var imgViewSafari: UIImageView!
//    @IBOutlet weak var imgViewChrome: UIImageView!
    @IBOutlet var btnActions: [UIButton]!
    @IBOutlet var modalView: UIView!
    @IBOutlet weak var viewGroupTop: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblShowContentCode: UILabel!
    @IBOutlet weak var lblTypeDetected: UILabel!
    @IBOutlet weak var showContentQRCode: UIView!
    
    
    private var boundingBox = CAShapeLayer()
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
    let message = "This is the message section of the popup dialog default view"
    let image = UIImage(named: "pexels-photo-103290")
    var isOpenFlash: Bool = false
    var actions: [ScanManager.Action] = []
    let pasteboard = UIPasteboard.general
    
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
    
    @IBAction func btnSwitchCamera(_ sender: Any) {
        switchCamera()
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
    
    
    @IBAction func btnCopy(_ sender: Any) {
        ScanManager.shared.displayToastMessage("Copied to clipboard")
        pasteboard.string = stringContent
    }
    
    @IBAction func btnSafari(_ sender: Any) {
        guard let url = URL(string: stringContent) else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func btnChrome(_ sender: Any) {
//        openOnChrome(urlSource: "https://emddi.com")
        guard let messageAppURL = NSURL(string: stringContent)
            else { return }
        if UIApplication.shared.canOpenURL(messageAppURL as URL) {
            UIApplication.shared.openURL(messageAppURL as URL)
        }
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
    
    var controller: DetectedViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        captureSession = AVCaptureSession()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        buildViewGroupTop()
        createDetectedView()
        autoCapture()
        setupBoundingBox()
    }
    
    private func createDetectedView(){
        if (controller == nil){
            let detectView = self.storyboard?.instantiateViewController(withIdentifier: "DetectedViewController") as! DetectedViewController
            controller = detectView
            
            let heightSubView = CGFloat(integerLiteral: 240)
            
            //        let viewModal = DetectedViewController()
            
            
            let theHeight = UIScreen.main.bounds.size.height
            let theWidth = UIScreen.main.bounds.size.width
            controller?.view.frame = CGRect(x: 20, y: theHeight - heightSubView - 140 , width: theWidth - 40, height: heightSubView)
            controller?.willMove(toParentViewController: self)
            self.view.addSubview(controller!.view)
            
            self.addChildViewController(controller!)
            controller!.didMove(toParentViewController: self)
            
            controller.btnClose.addTarget(self, action: #selector(btnCloseDidTap), for: .touchUpInside)
        }
        
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
//        let theHeight = view.frame.size.height

//        modalView.frame = CGRect(x: 20, y: theHeight - heightSubView - 140 , width: self.view.frame.width - 40, height: heightSubView)
//        modalView.layer.cornerRadius = 12
    
//        let size = 260
//        let screenWidth = self.view.frame.size.width
//
//        let frame = CGRectMake((screenWidth / 2) - CGFloat((size / 2)), 30, size, size)
//        let draggableView = DraggableView(frame: frame)
//
//        self.view.addSubview(draggableView)
//        
//        modalView.center.x = view.center.x
//        self.view.addSubview(viewModal)
        let transition = CATransition()
        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        transition.type = .moveIn
//        transition.subtype = .fromTop
        
//        modalView?.layer.add(transition, forKey: kCATransition)
//        modalView.alpha = 0
        let heightSubView = CGFloat(integerLiteral: 240)
        
        //        let viewModal = DetectedViewController()
        
        
        let theHeight = UIScreen.main.bounds.size.height
        let theWidth = UIScreen.main.bounds.size.width
        controller!.view.frame = CGRect(x: 20, y: theHeight - heightSubView - 140 , width: theWidth - 40, height: heightSubView)
        controller.scanCode()
//        controller.lblContentCode.text = ScanManager.shared.originText
//        controller.lblTypeCode.text = ScanManager.shared.typeContentScan

        
        view.bringSubview(toFront: controller.view)
//
        UIView.animate(withDuration: 0.4){
            self.controller!.view.alpha = 1
            self.controller!.view.transform = CGAffineTransform.identity
        }
        

    }
    
    @objc func btnCloseDidTap() {
        hideTableOptionOpen()
    }
    
    func hideTableOptionOpen(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.controller!.view.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height)
            self.controller.view.alpha = 0
        }){ (success:Bool) in
//            self.controller!.view.removeFromSuperview()
            self.controller.view.alpha = 0
        }
    }
    
    func loadModalOpen() {
        let modalVC = ModalViewController()
        let rect = CGRect(x: view.frame.origin.x, y: view.frame.maxY - modalVC.view.frame.maxY, width: view.frame.maxX, height: 380)
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
    
//        let yPos = (view.subviews.map { $0.frame.height }).reduce(0, +)
        let yPos = UIApplication.shared.statusBarFrame.height
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0.0, y: yPos, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (tabBarController?.tabBar.frame.size.height)! - yPos - 20)
        previewLayer.cornerRadius = 16
//        previewLayer.layer.cornerRadius = 25
        previewLayer.backgroundColor = UIColor.red.cgColor
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        view.addSubview(viewGroupTop)
        captureSession.startRunning()
        
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
    
    
    private func setupBoundingBox() {
         let yPos = (view.subviews.map { $0.frame.height }).reduce(0, +)
        boundingBox.frame = view.layer.bounds
        boundingBox.frame =  CGRect(x: 0 , y: yPos, width: self.view.frame.width, height: self.view.frame.height)
        boundingBox.strokeColor = UIColor.red.cgColor
        boundingBox.lineWidth = 4.0
        boundingBox.fillColor = UIColor.clear.cgColor
        
        view.layer.addSublayer(boundingBox)
    }
    
    fileprivate func updateBoundingBox(_ points: [CGPoint]) {
        guard let firstPoint = points.first else {
            return
        }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        var newPoints = points
        newPoints.removeFirst()
//        firstPoint.x = firstPoint.x + 100
        newPoints.append(firstPoint)
        newPoints.forEach { path.addLine(to: $0) }
        boundingBox.path = path.cgPath
        boundingBox.isHidden = false
    }
    
    private var resetTimer: Timer?
    fileprivate func hideBoundingBox(after: Double) {
        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + after,
                                          repeats: false) {
                                            [weak self] (timer) in
                                            self?.resetViews() }
    }
    
    private func resetViews() {
        boundingBox.isHidden = true
        

    }

    func checkContentFromCode(content: String){
        let contentUse = content.lowercased()
        
        ScanManager.shared.setOriginText(originText: contentUse)

        
//        lblShowContentCode.text = contentUse
//        lblTypeDetected.text = ScanManager.shared.typeContentScan
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
    

    
    func playInGoogleMap(urlLocation: String){
//        UIApplication.shared.openURL(URL(string:urlLocation)!)
        
        if let urlValidate = URL(string: urlLocation),
            UIApplication.shared.canOpenURL(urlValidate) {
            UIApplication.shared.open(urlValidate, options: [:], completionHandler: nil)
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
        let newScan = Scan.init(id: ScanManager.shared.historyScan.count, content: stringContent, type: ScanManager.shared.typeContentScan)
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
    
    func switchCamera() {
        print("switchCamera")
        if let session = captureSession {
            //Indicate that some changes will be made to the session
            session.beginConfiguration()
            //Remove existing input
            guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
                return
            }
            session.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera: AVCaptureDevice! = nil
            if let input = currentCameraInput as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    newCamera = cameraWithPosition(position: .front)
                } else {
                    newCamera = cameraWithPosition(position: .back)
                }
            }
            
            //Add input to session
            var err: NSError?
            var newVideoInput: AVCaptureDeviceInput!
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            } catch let err1 as NSError {
                err = err1
                newVideoInput = nil
            }
            
            if newVideoInput == nil || err != nil {
                print("Error creating capture device input: \(String(describing: err?.localizedDescription))")
            } else {
                session.addInput(newVideoInput)
            }
            
            //Commit all the configuration changes at once
            session.commitConfiguration()
        }
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
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
    
    func createFeelbackHaptic(){
        let isSupportHaptic:Int = UIDevice.current.value(forKey: "_feedbackSupportLevel") as! Int
        if (isSupportHaptic == 0) {
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        } else if (isSupportHaptic == 1){
            AudioServicesPlaySystemSound(1520)
        } else {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
//        captureSession.stopRunning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            if(stringValue != stringContent){
                createFeelbackHaptic()
                found(code: stringValue)
            }
            
            guard let transformedObject = previewLayer.transformedMetadataObject(for: metadataObject) as? AVMetadataMachineReadableCodeObject else {
                return
            }
            updateBoundingBox(transformedObject.corners)
            hideBoundingBox(after: 0.25)
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
