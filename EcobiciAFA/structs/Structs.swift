//
//  Structs.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import Foundation

//Token para acceder a los servicios de la ecobico
struct TokenEcobici:Decodable{
    let access_token:String
}


struct StationsList:Decodable{
    let stations:[Station]
    
    
    func getEstacionById(id: Int)->Station?{
        for item in stations{
            if(item.id == id){
                return item
            }
        }
        return nil
    }
    
    //Funcion que filtra las estaciones
    func filterDataList(filter:String)->[Station]{
        var stationsFiltered:[Station] = []
        
        
        for m in (stations)  {
            
            //Filtrado por el textto filter
            if(!filter.isEmpty){
                if m.name.lowercased().range(of:filter.lowercased()) == nil {
                    continue
                }
            }
            //Si el filtro funciona lo agrega a la lista
            stationsFiltered.append(m)
        }
        
        return stationsFiltered
    }
}


struct Station:Decodable{
    let id:Int
    let name:String
    let address:String
    let addressNumber:String
    let zipCode:String!
    let districtCode:String!
    let districtName:String!
    let altitude:String!
    let location:Location
}

struct Location:Decodable{
    let lat:Double
    let lon:Double
}


//Status

struct StationStatusList:Decodable{
    let stationsStatus:[StationsStatus]
    
    func getStatus(id:Int)->StationsStatus!{
        for item in stationsStatus {
            if(item.id == id){
                return item
            }
        }
        
        return nil
    }
}

struct StationsStatus:Decodable{
    let id:Int
    let status:String
    let availability:StationAvailability
    
    func getStatus()->String{
        if(status == "OPN"){
            return "Abierto";
        }else{
            return "Cerrado";
        }
    }
}

struct StationAvailability:Decodable{
    let bikes:Int
    let slots:Int
}



//---------------


struct AccessToken:Decodable{
    let access_token:String
    let expires_in:Int
    let refresh_token:String
}
