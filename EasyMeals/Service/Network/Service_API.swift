
import UIKit
import Alamofire
import AlamofireImage
import SystemConfiguration
import CoreLocation


public enum RequestResult<T> {
    case success(T)
    case error(NSError)
}

typealias CompletionBlock = (RequestResult<Data>) -> Void

class Service_API {
    
    private init() {}
    //    static private var completionBlock: CompletionBlock?
    //    static var isLoaded: Bool = false
    
    // MARK: Master
    
    static func callWebservice(apiPath : APIRoutes.RawValue, method : HTTPMethod, paramsEndcoring: ParameterEncoding = URLEncoding.default, header : [String : String], params : [String : Any], onComplete : CompletionBlock? = nil) {
        
        let API_URL = "\(SERVER_URL)\(apiPath)"
        let webservice = String(format: "%@",API_URL)
        
        if checkInternet(){
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                print("Path : \(webservice)")
                print("Parameter : \(jsonString)")
            } catch let error as NSError {
                print(error)
            }
            
            Alamofire.request(webservice, method: method, parameters: params, encoding: paramsEndcoring, headers: header).validate(contentType: ["application/json"]).responseJSON { (response) in
                print("Response  ::::::: \(response)")
                var errorCode = 0
                var statusCode = response.response?.statusCode
                print("statusCode  ::::::: \(String(describing: statusCode))")
                if let error = response.result.error as? AFError {
                    statusCode = error._code // statusCode private
                    switch error {
                    case .invalidURL(let url):
                        print("Invalid URL: \(url) - \(error.localizedDescription)")
                    case .parameterEncodingFailed(let reason):
                        print("Parameter encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .multipartEncodingFailed(let reason):
                        print("Multipart encoding failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                    case .responseValidationFailed(let reason):
                        print("Response validation failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        
                        switch reason {
                        case .dataFileNil, .dataFileReadFailed:
                            print("Downloaded file could not be read")
                        case .missingContentType(let acceptableContentTypes):
                            print("Content Type Missing: \(acceptableContentTypes)")
                        case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                            print("Response content type: \(responseContentType) was unacceptable: \(acceptableContentTypes)")
                        case .unacceptableStatusCode(let code):
                            print("Response status code was unacceptable: \(code)")
                            statusCode = code
                        }
                    case .responseSerializationFailed(let reason):
                        print("Response serialization failed: \(error.localizedDescription)")
                        print("Failure Reason: \(reason)")
                        // statusCode = 3840 ???? maybe..
                    }
                    print("Underlying error: \(String(describing: error.underlyingError))")
                } else if let error = response.result.error as? URLError {
                    print("URLError occurred: \(error.code)")
                    errorCode = error.code.rawValue
                } else {
                    print("Unknown error: \(String(describing: response.result.error) )")
                }
                
                switch response.result {
                case .success(_):
                    if let responseDict = response.result.value as? [String: AnyObject] {
                        let status = Bool(responseDict["success"] as! Bool)
                        if !status {
                            switch statusCode {
                            case 401:
                                if apiPath != APIRoutes.refreshTokens.rawValue {
                                    TokenHandler.shared.silentlyRefreshTokens(complete: { (result) in
                                        switch result {
                                        case .success(_):
                                            callWebservice(apiPath: apiPath, method: method, paramsEndcoring: paramsEndcoring, header: header, params: params, onComplete: onComplete)
                                        case .error(_):
                                            TokenHandler.shared.showSignInAlert()
                                        }
                                    })
                                } else {
                                    let msg = responseDict["message"] as? String ?? "Error"
                                    let error = ErrorHelper.shared.error(msg, msg)
                                    onComplete?(RequestResult.error(error as NSError))
                                }
                            default:
                                let msg = responseDict["message"] as? String ?? "Error"
//                              Constants.showAlert("Error", message: msg)
                                let error = ErrorHelper.shared.error(msg, msg)
                                onComplete?(RequestResult.error(error as NSError))
                            }
                        } else {
                            onComplete?(RequestResult.success(response.data!))
                        }
                    }
                case .failure(let error):
                    switch errorCode {
                    case -1005, -1001:
                        callWebservice(apiPath: apiPath, method: method, paramsEndcoring: paramsEndcoring, header: header, params: params, onComplete: onComplete)
                    default:
//                        Constants.showAlert("Error", message: error.localizedDescription)
                        onComplete?(RequestResult.error(error as NSError))
                    }
                }
            }
        }
        else {
            let noInternetConnectionMessage = "No internet connection."
            print("Unable to create Reachability")
//            Constants.showAlert("Alert", message: noInternetConnectionMessage)
            let error = ErrorHelper.shared.error(noInternetConnectionMessage, noInternetConnectionMessage)
            onComplete?(RequestResult.error(error as NSError))
            return
        }
        
    }
    
    // Check internet connectivity
    class private func checkInternet() -> Bool {
        
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
    //func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
    
    static fileprivate func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        //==========================================================================================================
        //
        //  Batching is required for escaping due to an internal bug in iOS 8.1 and 8.2. Encoding more than a few
        //  hundred Chinese characters causes various malloc error crashes. To avoid this issue until iOS 8 is no
        //  longer supported, batching MUST be used for encoding. This introduces roughly a 20% overhead. For more
        //  info, please refer to:
        //
        //      - https://github.com/Alamofire/Alamofire/issues/206
        //
        //==========================================================================================================
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    // Single Image upload Webservice Call
    static func callWebserviceMultipartMethodForSingleImage(apiPath : APIRoutes.RawValue, data : UIImage?, nameImageFiled: String, fileName: String, header : [String : String], params : [String : Any], options : NSDictionary?, onComplete : CompletionBlock? = nil) {
        
        let API_URL = "\(SERVER_URL)\(apiPath)"
        let webservice = String(format: "%@",API_URL)
        
        if checkInternet(){
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                print("Path : \(webservice)")
                print("Parameter : \(jsonString)")
            } catch let error as NSError {
                print(error)
            }
            
            let apiURL = try! URLRequest(url: webservice, method: .post, headers: header)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    if let dictionary = value as? [String: Any] {
                        var components: [(String, String)] = []
                        for (nestedKey, value) in dictionary {
                            //components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
                            components.append((self.escape("\(key)[\(nestedKey)]"), self.escape("\(value)")))
                            if let data = (self.escape("\(value)") as String).data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
                                multipartFormData.append(data, withName: (self.escape("\(key)[\(nestedKey)]")))
                            }
                        }
                    }else if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                let img  = resizeImage(data!, longEdge: 1000)
                let imgData = img.jpegData(compressionQuality: 1.0)
                multipartFormData.append(imgData!, withName: nameImageFiled, fileName: fileName, mimeType: "image/jpg")
                multipartFormData.append("\r\r".data(using: String.Encoding.utf8)!, withName: "")
                
            }, with: apiURL, encodingCompletion: { (response) in
                
                switch response {
                case .success(let upload,_ ,_ ):
                    upload.responseJSON  { response in
                        switch response.result {
                        case .success( _):
                            if let responseDict = response.result.value as? [String: AnyObject] {
                                let status = Bool(responseDict["success"] as! Bool)
                                if !status {
                                    let msg = responseDict["message"] as! String?
                                    Constants.showAlert("Error", message: msg!)
                                }
                                onComplete?(RequestResult.success(response.data!))
                            }
                            break
                        case .failure(let error):
                            onComplete?(RequestResult.error(error as NSError))
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    onComplete?(RequestResult.error(encodingError as NSError))
                }
            })
        }
        else {
            Constants.showAlert("Alert", message: "No internet connection.")
            print("Unable to create Reachability")
            return
        }
    }
    
    // Single Image upload Webservice Call
    // data : UIImage?, nameImageFiled: String, fileName: String
    static func callWebserviceMultipartMethodForImageArray(apiPath : APIRoutes.RawValue, arrayAttach:Array<Dictionary<String, Any>>, header : [String : String], params : [String : Any], options : NSDictionary?, onComplete : CompletionBlock? = nil) {
        
        let API_URL = "\(SERVER_URL)\(apiPath)"
        let webservice = String(format: "%@",API_URL)
        
        if checkInternet(){
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)! as String
                print("Path : \(webservice)")
                print("Parameter : \(jsonString)")
            } catch let error as NSError {
                print(error)
            }
            
            let apiURL = try! URLRequest(url: webservice, method: .post, headers: header)
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (key, value) in params {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
                for tempDict in arrayAttach {
                    let img  = resizeImage((tempDict["data"] as! UIImage), longEdge: 1000)
                    let imgData = img.jpegData(compressionQuality: 1.0)
                    multipartFormData.append(imgData!, withName: tempDict["nameImageFiled"] as! String, fileName: tempDict["fileName"] as! String , mimeType: "image/jpg")
                    multipartFormData.append("\r\r".data(using: String.Encoding.utf8)!, withName: "")
                }
                
            }, with: apiURL, encodingCompletion: { (response) in
                
                switch response {
                case .success(let upload,_ ,_ ):
                    upload.responseJSON  { response in
                        switch response.result {
                        case .success( _):
                            if let responseDict = response.result.value as? [String: AnyObject] {
                                let status = Bool(responseDict["success"] as! Bool)
                                if !status {
                                    let msg = responseDict["message"] as! String?
                                    Constants.showAlert("Error", message: msg!)
                                }
                                onComplete?(RequestResult.success(response.data!))
                            }
                            break
                        case .failure(let error):
                            onComplete?(RequestResult.error(error as NSError))
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    onComplete?(RequestResult.error(encodingError as NSError))
                }
            })
        }
        else {
            Constants.showAlert("Alert", message: "No internet connection.")
            print("Unable to create Reachability")
            return
        }
    }
    
    class private func resizeImage(_ image: UIImage, longEdge: CGFloat) -> UIImage {
        
        var newHeight = image.size.height
        var newWidth = image.size.width
        
        if newHeight < 1000 && newWidth < 1000{
            return image
        }
        
        var scale = longEdge / image.size.height
        
        if newHeight > newWidth{
            scale = longEdge / image.size.height
            newWidth = image.size.width * scale
            newHeight = longEdge
        }else{
            scale = longEdge / image.size.width
            newHeight = image.size.height * scale
            newWidth = longEdge
        }
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
