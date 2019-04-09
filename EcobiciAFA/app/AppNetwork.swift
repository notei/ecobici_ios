//
//  AppNetwork.swift
//  latingal
//
//  Created by Alberto Farías on 7/24/18.
//  Copyright © 2018 Latingal boutique. All rights reserved.
//

import Foundation
import SystemConfiguration

public class AppNetworkUtils{
    
    enum SaveNetworkData {
        case none
        case request
        case response
        case requestAndResponse
    }
    
    func loadJsonUrl(endpoint:String,jsonBody:[String:Any],completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
        loadJsonUrl(endpoint:endpoint,jsonBody:jsonBody,saveNetworkData:.none,completion:completion);
    }
    
    func loadJsonUrl(endpoint:String,jsonBody:[String:Any], saveNetworkData:SaveNetworkData, completion: @escaping (Data?,HTTPURLResponse?,Error?) -> ()){
       // print(endpoint);
        
        guard let url = URL(string: endpoint)
            else {
                let err = NSError(domain: "EndpontError", code: -401, userInfo: nil);
                
                if(saveNetworkData == .request || saveNetworkData == .requestAndResponse){
                    //Guarda los datos de la petición
                    let json = request2Json(from: jsonBody);
                    saveRequestData(endpoint: "request", data: json!)
                }
                
                completion(nil,nil,err);
                return;
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            
            var request = URLRequest(url: url);
            request.httpMethod = "GET";
            //request.httpBody = data;
            request.addValue("application/json", forHTTPHeaderField: "Content-Type");
            request.addValue("application/json", forHTTPHeaderField: "Accept");
            
            URLSession.shared.dataTask(with: request) { (data, response, err) in
                guard let data = data else {
                    //Error
                    let err = NSError(domain: "APIResponseError", code: -401, userInfo: nil);
                    completion(nil,nil,err);
                    return
                }
                if let httpResponse = response as? HTTPURLResponse{
                    //Success
                        completion(data,httpResponse,nil);
                    return;
                }
                
                
                
                completion(data, nil ,nil);
                }.resume();
            
        } catch let Err{
            completion(nil,nil, Err);
        }
        
    }
    
    public enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    

    
    // Convierte un arreglo del tipo String:Any a un string
    private func request2Json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //Guarda el request en un archivo
    private func saveRequestData(endpoint:String, data:String){
        let lastIndex = endpoint.lastIndex(of: "/")!
        let file = (String(endpoint[lastIndex...])).replacingOccurrences(of: "/", with: "")
        
        
        let text = data //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let fileURL = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
    }
    
}




