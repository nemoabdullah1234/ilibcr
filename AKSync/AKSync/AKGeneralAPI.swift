



import UIKit
enum STRApiType2: Int{
    case strApiSync = 0 //example
    case strApiConfig
    case strApiStatus
    case strApiSyncNew
}
enum textMessage: String {
    case warning="there is an error"
}




@objc public class AKGeneralAPI: NSObject ,URLSessionDelegate,URLSessionDataDelegate,URLSessionTaskDelegate{
    
    
     var successCallBack: ((Dictionary<String,AnyObject>)->())?
    var errorCallBack: ((NSError)->())?
    
    var schemeString : String = ""
    
    open var role : String = ""
  
    
    public func setUrlScheme(_ scheme : String)
    {
        schemeString = scheme
    }
    
    
    
    
    func hitApiwith(_ parameters: Dictionary<String,AnyObject> ,serviceType:STRApiType2,success: (@escaping(Dictionary<String,AnyObject>)->()),failure:(@escaping(NSError)->())){
        successCallBack = success
        errorCallBack = failure
        
        switch serviceType {
        case .strApiSync:
            //example
            self.hitPOSTApiNSURL(parameters, path: "\(AKUtility.getBaseUrl()!)/reader/beaconLocation")
            break
        case .strApiConfig:
            self.hitGETApiNSURL(["":"" as AnyObject], path: "\(AKUtility.getBaseUrl()!)/reader/getTrackingConfigurations" )
            break
        case .strApiStatus:
            let stage =  AKUtility.getAPIStage()
            self.hitPuTApiWithAlaomfire(parameters, path: "\(AKUtility.getBaseUrl()!)/things/" + stage! + "/deviceStatus")
            print("\(AKUtility.getBaseUrl()!)/things/" + stage! + "/deviceStatus")
            break
        case .strApiSyncNew:
            //example
        self.hitPOSTApiNSURL(parameters, path: "https://lbz5kkmqdb.execute-api.us-east-1.amazonaws.com/dev/trackLocation")
        
            break
        }
        
    }
    
    fileprivate func hitPuTApiWithAlaomfire(_ params: Dictionary<String,AnyObject>,path:String)->Void{
        var generateToken = AKUtility.getIdToken() + "::" + AKUtility.getAccessToken()
        if(generateToken == "::")
        {
            generateToken = ""
        }
        let request = NSMutableURLRequest(url: URL(string:path)!)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(generateToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("salesRep", forHTTPHeaderField:"Appname")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: []);
        
        let task = Foundation.URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental
                return
            }
            
            let test = response as? HTTPURLResponse
            print(test!.statusCode)
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode > 299 {           // check for http errors
                
            }
            else
            {
                
                let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableLeaves);
                print(dict);
            }
            
        })
        task.resume()
    }
    
    //MARK:  specific to posting beacon data
    fileprivate func hitPOSTApiNSURL(_ params: Dictionary<String,AnyObject>,path:String)->Void{
       var useertoken = AKUtility.getUserToken()
        if(useertoken == nil)
        {
            useertoken = " "
        }
        var devToken = AKUtility.getDevice()
        if(devToken == nil)
        {
            devToken = " "
        }
        
        
        let request = NSMutableURLRequest(url: URL(string:path)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(devToken!, forHTTPHeaderField: "deviceId")
        request.setValue(useertoken!, forHTTPHeaderField: "sid")
        request.setValue(AKUtility.getUserRole(), forHTTPHeaderField:"role")

        
        request.httpBody = try! JSONSerialization.data(withJSONObject: params["beacons"]!, options: []);
        let task = Foundation.URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                
                self.errorCallBack!(error! as NSError)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                // print("statusCode should be 200, but is \(httpStatus.statusCode)")
                // print("response = \(response)")
            }
            
            let dict :Dictionary<String,AnyObject> = try! JSONSerialization.jsonObject(with: data!, options: [.mutableContainers]) as! Dictionary<String,AnyObject>;
             
            self.successCallBack!(dict)//dict as! Dictionary<String, AnyObject>
            
        }) 
        
        task.resume()
        
    }
    
    fileprivate func hitGETApiNSURL(_ params: Dictionary<String,AnyObject>,path:String)->Void{
        var useertoken = AKUtility.getUserToken()
        if(useertoken == nil)
        {
            useertoken = " "
        }
        var devToken = AKUtility.getDevice()
        if(devToken == nil)
        {
            devToken = " "
        }

        let request = NSMutableURLRequest(url: URL(string: path)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(devToken!, forHTTPHeaderField: "deviceId")
        request.setValue(useertoken!, forHTTPHeaderField: "sid")
        request.setValue(role, forHTTPHeaderField:"role")

        let task = Foundation.URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental
                
                self.errorCallBack!(error as! NSError)
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                
                
            }
            print(response)
            let dict = try! JSONSerialization.jsonObject(with: data!, options: []);
            self.successCallBack!(dict as! Dictionary<String, AnyObject>)
            
        }) 
        task.resume()
        
    }
   
    
    fileprivate func hitPOSTApiWithAlaomfire(_ params: Dictionary<String,AnyObject>,path:String)->Void{
        var useertoken = AKUtility.getUserToken()
        if(useertoken == nil)
        {
            useertoken = " "
        }
        
        var devToken = AKUtility.getDevice()
        if(devToken == nil)
        {
            devToken = " "
        }
        
        let request = NSMutableURLRequest(url: URL(string:path)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(devToken!, forHTTPHeaderField: "deviceId")
        request.setValue(useertoken!, forHTTPHeaderField: "sid")
        request.setValue("traquer", forHTTPHeaderField:"AppType")
        request.setValue(role, forHTTPHeaderField:"role")

        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: []);
        
        let task = Foundation.URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
        guard error == nil && data != nil else {                                                          // check for fundamental
            return
        }
        
        let test = response as? HTTPURLResponse
        print(test!.statusCode)
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode > 299 {           // check for http errors

        }
        else
        {
            
            let dict = try! JSONSerialization.jsonObject(with: data!, options: .mutableLeaves);
            print(dict);
        }
        
    }) 
    task.resume()
   }


    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?){
         print("got it")
    }
}
