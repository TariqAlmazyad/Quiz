//
//  Extension.swift
//  Quiz
//
//  Created by Tariq Almazyad on 10/12/20.
//

import UIKit
import SystemConfiguration
import MapKit
import AudioToolbox
import Photos

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

extension PHAsset {
    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        imageManager.requestImage(for: self, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil, resultHandler: { image, _ in
            guard let image = image else {return}
            thumbnail = image
        })
        return thumbnail
    }
}

extension NSAttributedString {
    /// get the UILabel / UITextView, and UITextField  height
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.height)
    }
    
    /// get the UILabel / UITextView, and UITextField  width
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UIDevice {
    
    /// example UIDevice.vibrate()
    static func vibrate() {
        AudioServicesPlaySystemSound(1519)
    }
}



extension Bundle {
    
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    /// to get the app version   ---> let appVersion = Bundle.mainAppVersion
    
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
}


extension String {
    /// String as AttributedString
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
    
    /// Check for text Validation
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
    
    /// get the UILabel / UITextView, and UITextField  height
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    /// get the UILabel / UITextView, and UITextField  width
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    var trimWhiteSpace: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    mutating func trim(){
        self = self.trimWhiteSpace
    }
    var asURL: URL? {
        URL(string: self)
    }
}

extension Int {
    /// to convert Int value to Double
    func toDouble() -> Double {
        Double(self)
    }
    /// to convert Int value to String
    func toString() -> String {
        "\(self)"
    }
}

extension Double {
    /// to convert Double value to Int
    func toInt() -> Int {
        Int(self)
    }
    /// to convert Double  value to String
    func toString() -> String {
        String(format: "%.02f", self)
    }
    
    /// let dPrice = 16.50  -->  let strPrice = dPrice.toPrice(currency: "€")
    func toPrice(currency: String) -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 2
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}

extension UIColor {
    static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
}

extension UIViewController {
    
    func showAlertMessage( _ title: String? ,_ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    private static let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    func showBlurView(){
        view.addSubview(UIViewController.visualEffectView)
        UIViewController.visualEffectView.fillSuperview()
        UIViewController.visualEffectView.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIViewController.visualEffectView.alpha = 1
        }, completion: nil)
    }
    
    func removeBlurView(){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            UIViewController.visualEffectView.alpha = 0
        }) { _ in
            UIViewController.visualEffectView.removeFromSuperview()
        }
    }
    
    
    // Check new user , if yes ? then do X
    func isAppAlreadyLaunchedOnce() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") {
            print("App already launched")
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            print("App launched first time")
            return false
        }
    }
    
    // to get full controller of the navigationBar , title , color , size
    func configureNavigationBar(withTitle title: String,
                                largeTitleColor: UIColor,
                                tintColor: UIColor,
                                navBarColor: UIColor,
                                titleView: UIView? = nil,
                                smallTitleColorWhenScrolling: UIUserInterfaceStyle,
                                prefersLargeTitles: Bool) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
        appearance.backgroundColor = navBarColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
        navigationItem.title = title
        navigationItem.titleView = titleView
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.overrideUserInterfaceStyle = smallTitleColorWhenScrolling
    }
    
    // to hide keyboard on dismiss
    func hideKeyboardWhenTouchOutsideTextField() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    //
    //    // show a success / warning / failed  banner when an event happens
    //    static let banner = Loaf.self
    //
    //    func showBanner(message: String, state: Loaf.State,
    //                    location: Loaf.Location, presentingDirection: Loaf.Direction,
    //                    dismissingDirection: Loaf.Direction, sender: UIViewController) {
    //        UIViewController.banner.init(message, state: state,
    //                                     location: location, presentingDirection: presentingDirection,
    //                                     dismissingDirection: dismissingDirection, sender: sender).show()
    //    }
    //
    //    // show indicator for an event
    //    static let hud = JGProgressHUD(style: .dark)
    //    func showLoader(_ show: Bool, message: String? = nil) {
    //        view.endEditing(true)
    //
    //        if show {
    //            UIViewController.hud.textLabel.text = message
    //            UIViewController.hud.show(in: view)
    //        } else {
    //            UIViewController.hud.textLabel.text = message
    //            UIViewController.hud.dismiss()
    //        }
    //    }
    
    
    // check if the user is connecting to the internet
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
    // create gradient layer
    func configureGradientLayer(with topColor: UIColor, bottomColor: UIColor,
                                startPoint:NSNumber, endPoint: NSNumber) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [startPoint, endPoint]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.frame
    }
    
}


extension UIStackView{
    func customAddArrangedSubviews(_ views: UIView...){
        views.forEach {addSubview($0)}
    }
}

extension UIView {
    
    func customAddSubViews(_ views: UIView...  ){
        views.forEach{addSubview($0)}
    }
    
    func setGradiantBGColor(colorOne:UIColor, colorTwo:UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 2.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    //    func centerX(inView view: UIView) {
    //        translatesAutoresizingMaskIntoConstraints = false
    //        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //    }
    //
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil,
                 paddingTop: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: constant).isActive = true
        if let top = topAnchor{
            anchor(top: top, paddingTop: paddingTop)
        }
        
    }
    
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    
    
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    @discardableResult
    open func fillSuperview(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        let anchoredConstraints = AnchoredConstraints()
        guard let superviewTopAnchor = superview?.topAnchor,
              let superviewBottomAnchor = superview?.bottomAnchor,
              let superviewLeadingAnchor = superview?.leadingAnchor,
              let superviewTrailingAnchor = superview?.trailingAnchor else {
            return anchoredConstraints
        }
        
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }
    
    @discardableResult
    open func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        let anchoredConstraints = AnchoredConstraints()
        if #available(iOS 11.0, *) {
            guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
                  let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
                  let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
                  let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else {
                return anchoredConstraints
            }
            return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
            
        } else {
            return anchoredConstraints
        }
    }
    
    open func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    open func centerXToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }
    
    open func centerYToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }
    
    @discardableResult
    open func constrainHeight(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.height?.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    open func constrainWidth(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.width?.isActive = true
        return anchoredConstraints
    }
    
    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0,
                          offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    open func setupShadowAndBorder(opacity: Float = 0, radius: CGFloat = 0,
                                   offset: CGSize = .zero, color: UIColor = .black,
                                   borderColor: UIColor, borderWidth: CGFloat) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        clipsToBounds = true
        layer.masksToBounds = false
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
    
    
    //           button.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
    //
    //           button.layer.borderColor = UIColor.green.cgColor
    //           button.layer.borderWidth = 1
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
}



extension UITableView {
    
    
    func setEmptyView(title: String, titleColor: UIColor, message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = titleColor
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
        messageLabel.textColor = UIColor.lightGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}


extension MKPlacemark {
    var address: String? {
        get {
            guard let subThroughFare = subThoroughfare else { return nil }
            guard let thoroughfare = thoroughfare else { return nil }
            guard let locality = locality else { return nil }
            guard let adminArea = administrativeArea else { return nil }
            return "\(subThroughFare) \(thoroughfare) , \(locality), \(adminArea)"
        }
    }
}



extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let twitterBlue = UIColor.rgb(red: 29, green: 161, blue: 242)
}

extension UINavigationController {
    override open var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

extension Date {
    /// To convert a date to specific type
    func convertDate(formattedString: DateFormattedType) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formattedString.rawValue
        return formatter.string(from: self)
    }
    /// To print 1s ago , 4d ago, 1month ago
    func convertToTimeAgo(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = style
        let now = Date()
        return formatter.string(from: self, to: now) ?? ""
    }
    enum DateFormattedType: String, CaseIterable {
        /// Date sample  Sunday, Sep 6, 2020
        case formattedType1 = "EEEE, MMM d, yyyy"
        /// Date sample  09/06/2020
        case formattedType2 = "MM/dd/yyyy"
        /// Date sample  09-06-2020 02:45
        case formattedType3 = "MM-dd-yyyy HH:mm"
        /// Date sample  Sep 6, 2:45 AM
        case formattedType4 = "MMM d, h:mm a"
        /// Date sample  02:45:07.397
        case formattedType5 = "HH:mm:ss.SSS"
        /// Date sample  02:45:07.397
        case formattedType6 = "dd.MM.yy"
        /// Date sample  Sep 6, 2020
        case formattedType7 = "MMM d, yyyy"
        /// Time sample  09:27 PM
        case timeOnly = "h:mm a"
    }
}


