//
//  AppController.swift
//  Vinevera-CRM
//
//  Created by Alberto Farías on 10/23/18.
//  Copyright © 2018 2 Geeks one Monkey. All rights reserved.
//

import Foundation

class AppController{
    
    let appNetworkUtils = AppNetworkUtils();
    
    var token = "";
    
    static var disponibilidad:StationStatusList? = nil;
    
    
   
    
    
    public func getAccessTokencompletion(completion: @escaping (AccessToken?,Error?)-> ()){
        let json = [String:Any]();
        
        let endpoint = AppConstantes.API_TOKEN_URL;
        print(endpoint);
        
        
        appNetworkUtils.loadJsonUrl(endpoint: endpoint, jsonBody: json) { (data, res, err) in
            print("Get Access token");
            if(err != nil){
                completion(nil,err);
                return;
            }
            do{
                let res = try JSONDecoder().decode(AccessToken.self, from: data!);
                print("Resultado: ", res.access_token);
                self.token = res.access_token
                completion(res,nil)
            }catch let jsonErr{
                print(jsonErr);
                completion(nil,jsonErr)
            }
        }
    }
    
    
    public func getListaEstaciones(completion: @escaping (StationsList?,Error?)-> ()){
        
        
        getAccessTokencompletion { (res, err) in
            if(err == nil){
                let json = [String:Any]();
                
                let endpoint = AppConstantes.API_URL + AppConstantes.API_STATIONS_URL + self.token;
                print(endpoint);
                
                
                self.appNetworkUtils.loadJsonUrl(endpoint: endpoint, jsonBody: json) { (data, res, err) in
                    print("list estaciones");
                    if(err != nil){
                        completion(nil,err);
                        return;
                    }
                    do{
                        let res = try JSONDecoder().decode(StationsList.self, from: data!);
                        print("Resultado: ", res.stations.count);
                        completion(res,nil)
                    }catch let jsonErr{
                        print(jsonErr);
                        completion(nil,jsonErr)
                    }
                }
            }else{
                print("Error al recuperar el token")
            }
        }
        
        
        
       
    }
    
    
    public func getDisponibilidadEstaciones(refresh:Bool, completion: @escaping (StationStatusList?,Error?)-> ()){
        //Si no requiere recargar
        if(!refresh && AppController.disponibilidad != nil){
            print("No requiere reload")
            completion(AppController.disponibilidad, nil);
            return;
        }
        
        
        getAccessTokencompletion { (res, err) in
            if(err == nil){
                let json = [String:Any]();
                
               
                
                let endpoint = AppConstantes.API_URL + AppConstantes.API_STATIONS_STATUS_URL + self.token;
                print(endpoint);
                
                
                self.appNetworkUtils.loadJsonUrl(endpoint: endpoint, jsonBody: json) { (data, res, err) in
                    print("list estaciones");
                    if(err != nil){
                        completion(nil,err);
                        return;
                    }
                    do{
                        let res = try JSONDecoder().decode(StationStatusList.self, from: data!);
                        print("Resultado: ", res.stationsStatus.count);
                        
                        AppController.disponibilidad = res;
                        completion(res,nil)
                    }catch let jsonErr{
                        print(jsonErr);
                        completion(nil,jsonErr)
                    }
                }
            }
        }
        
        
    }
    
}
