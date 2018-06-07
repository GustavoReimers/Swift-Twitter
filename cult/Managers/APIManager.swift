//
//  APIManager.swift
//  Cult
//
//  Created by Han on 5/24/18.
//  Copyright © 2018 Han. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class APIManager: NSObject {
    
    let baseURL = "http://api.cultplatform.com/api/"
    static let shared = APIManager()
    
    //sign up
    
    func singUp(params: [String: Any], completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "register"
        
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    //profile upload
    
    func profilePhotoUpload(params: [String: String], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "profile/update/photo"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    //log in
    
    func logIn(params: [String: String], completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "login"
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    // Find friends when sign up
    
    func findFriends(params: [String: Any], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "find_friend"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    //Fetch cults
    
    func fetchCults(params: [String: String], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "cult/all"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    // Add New Cult
    
    func addNewCult(params: [String: String], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "cult/new"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    // Send Friend Reqeust
    
    func sendFriendRequest(params: [String: Int], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "friend/request"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    // Cancel friend reqeust
    
    func cancelFriendRequest(params: [String: Int], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "friend/request/delete"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
    // Posting photo
    
    func postPhoto(params: [String: Any], token: String, completion: @escaping (Error?, JSON)->()){
        
        let urlString = baseURL + "profile/update/photo"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json",
            "Content-Type": "application/json",
            ]
        
        Alamofire.request(urlString, method: .post, parameters: params,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                completion(nil, JSON(value))
                break
            case .failure(let error):
                completion(error, JSON.null)
            }
        }
        
    }
    
}
