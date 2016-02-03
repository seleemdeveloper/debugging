/*
Copyright (C) 2015 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
The detail view controller navigated to from our main and results table.
*/

import UIKit

class DetailViewController: UIViewController {
    // MARK: Types

    // Constants for Storyboard/ViewControllers.
    static let storyboardName = "MainStoryboard"
    static let viewControllerIdentifier = "DetailViewController"
    
    // Constants for state restoration.
    static let restoreProduct = "restoreProductKey"
    
    // MARK: Properties
    
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var couponView: UIView!
    
    
    
    
    var product: Product!
    
    // MARK: Initialization
    
    class func detailViewControllerForProduct(product: Product) -> DetailViewController {
        let storyboard = UIStoryboard(name: DetailViewController.storyboardName, bundle: nil)

        let viewController = storyboard.instantiateViewControllerWithIdentifier(DetailViewController.viewControllerIdentifier) as! DetailViewController
        
        viewController.product = product
        
        return viewController
    }
    
    // MARK: View Life Cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        title = product.title
        
        yearLabel.text = "\(product.yearIntroduced)"
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.formatterBehavior = .BehaviorDefault
        let priceString = numberFormatter.stringFromNumber(product.introPrice)
        priceLabel.text = priceString
        
        stockOrPricePending(product)
        
        
    }
    
    // MARK: UIStateRestoration

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        super.encodeRestorableStateWithCoder(coder)
        
        // Encode the product.
        coder.encodeObject(product, forKey: DetailViewController.restoreProduct)
    }
    
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
        
        // Restore the product.
        if let decodedProduct = coder.decodeObjectForKey(DetailViewController.restoreProduct) as? Product {
            product = decodedProduct
        }
        else {
            fatalError("A product did not exist. In your app, handle this gracefully.")
        }
    }
    
    //Check for product with low stock or variable pricing
    func stockOrPricePending (product : Product) {
        
        //Plug for version 1.0 release, for 2.0, ping the inventory API
        
        //Below products have low inventory
        
        if product.title == Product.Hardware.iMac.rawValue {
            priceLabel.hidden = true
            //priceLabel.text = "Please Contact Us For Pricing"
        }
        
        if product.title == Product.Hardware.iPod.rawValue {
            //priceLabel.hidden = true
            priceLabel.text = "Please Contact Us For Pricing"
        }
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake {
            checkAllProductsForCoupons()
        }
    }
    
    func checkAllProductsForCoupons(){
        
        for var i = products.count - 1; i >= 0; i-- {
            let product = products[i]
            checkCurrentCoupon(product)
        }
    }
    
    func checkCurrentCoupon(product : Product){
        
        switch product.title{
        case "iPad":
            showCouponView()
            break
        default:
            //No coupon, do Nothing
            break
        }
    }
    
    func showCouponView(){

        self.couponView.hidden = false
        self.view.bringSubviewToFront(self.couponView)
    }
    
    @IBAction func actionSheetButtonPressed(sender: UIButton) {
        let alert = UIAlertController(title: "Ooops", message: "You better try redeeming from a REAL iPhone :)", preferredStyle: .Alert) // 1
        
        presentViewController(alert, animated: true, completion:nil) // 6
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                alert.dismissViewControllerAnimated(true, completion: nil)
            })
    }
    }
}
