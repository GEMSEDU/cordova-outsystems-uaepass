
import Foundation
import UAEPassClient

extension AppDelegate{
    
    open override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if #available(iOS 13.0, *) {
            print("<><><><> appDelegate URL : \(url.absoluteString)")
            if url.absoluteString.contains(HandleURLScheme.externalURLSchemeSuccess()) {
                if let topViewController = UserInterfaceInfo.topViewController() {
                    if let webViewController = topViewController as? UAEPassWebViewController {
                        webViewController.forceReload()
                    }
                }
                return true
            } else if url.absoluteString.contains(HandleURLScheme.externalURLSchemeFail()) {
                guard let webViewController = UserInterfaceInfo.topViewController() as? UAEPassWebViewController  else { return false}
                webViewController.foreceStop()
                webViewController.dismiss(animated: true)
                return false
            }
            
            var openURLData = [String: Any]()
            openURLData["url"] = url
 
            if let sourceApplication = options[.sourceApplication] {
                openURLData["sourceApplication"] = sourceApplication
            }
 
            if let annotation = options[.annotation] {
                openURLData["annotation"] = annotation
            }
 
            // All plugins will get the notification, and their handlers will be called
            NotificationCenter.default.post(name: NSNotification.Name("CDVPluginHandleOpenURLNotification"), object: url)
            NotificationCenter.default.post(name: NSNotification.Name("CDVPluginHandleOpenURLWithAppSourceAndAnnotationNotification"), object: openURLData)
            return true
        } else {
            return true;
        }
    }
    
}
