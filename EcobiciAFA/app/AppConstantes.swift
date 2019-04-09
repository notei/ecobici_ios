//
//  AppConstantes.swift
//  EcobiciAFA
//
//  Created by Alberto Farías on 4/5/19.
//  Copyright © 2019 Alberto Farías. All rights reserved.
//

import Foundation

class AppConstantes{
    
     static let CLIENT_ID              = "";
     static let CLIENT_SECRET          = "";
    
    static let API_TOKEN_URL           = "https://pubsbapi.smartbike.com/oauth/v2/token?client_id=" + CLIENT_ID + "&client_secret=" + CLIENT_SECRET + "&grant_type=client_credentials";
    static let API_URL                 = "https://pubsbapi.smartbike.com/api/v1/stations";
    static let API_STATIONS_URL        = ".json?access_token=";
    static let API_STATIONS_STATUS_URL = "/status.json?access_token="
}


