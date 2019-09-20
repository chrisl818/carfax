//
//  CarInfo.swift
//  CarfaxList
//
//  Created by Chris Lin on 9/18/19.
//  Copyright © 2019 Chris Lin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import PromiseKit

typealias FetchSuceessClosure = ([CarInfo]) -> Void
typealias FetchFailureClosure = ( _ error: Error) -> Void

class CarInfo: NSObject {
    let photoUrl: String
    let make: String
    let model: String
    let trim: String
    let year: String
    let price: Float
    let city: String
    let state: String
    let mileage: Float
    let dealerNumber: String
    
    required init?(json: JSON) {
        photoUrl = json["images"]["medium"][0].stringValue
        make = json["make"].stringValue
        model = json["model"].stringValue
        trim = json["trim"].stringValue
        year = json["year"].stringValue
        price = json["listPrice"].floatValue
        city = json["dealer"]["city"].stringValue
        state = json["dealer"]["state"].stringValue
        mileage = json["mileage"].floatValue
        dealerNumber = json["dealer"]["phone"].stringValue
    }
    
    func yearMakeModel() -> String {
        if trim != "Unspecified" {
            return String(format: "%@ %@ %@ %@", year, make, model, trim)
        } else {
            return String(format: "%@ %@ %@", year, make, model)
        }
    }
    
    func priceMileageLocation() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        guard let amount = formatter.string(from: NSNumber(value: price)) else { return "" }
        
        let mileageK = Int(floor(mileage / 1000))
        
        return String(format: "%@ | %dK Mi | %@, %@", amount, mileageK, city, state)
    }
    
    func callNumber() -> String {
        var number = dealerNumber
        let end = number.index(number.startIndex, offsetBy: number.count)
        let range = number.startIndex..<end
        number = number.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "($1) $2-$3", options: .regularExpression, range: range)
        return number
    }
    
    static func fetchCarList(success: @escaping FetchSuceessClosure, failure: @escaping FetchFailureClosure) -> Request {
        return Alamofire.request("https://carfax-for-consumers.firebaseio.com/assignment.json", method: .get, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
            guard let data = response.data else {
                failure(CodeError.unknown)
                return
            }
            do {
                var objects = [CarInfo]()
                try JSON(data: data)["listings"].arrayValue.forEach {
                    if let object = CarInfo.init(json: $0) {
                        objects.append(object)
                    }
                }
                
                DispatchQueue.main.async {
                    success(objects)
                }
                
            } catch {
                failure(CodeError.unknown)
            }
        }
    }
    
    static func fetchCarList() -> Promise<[CarInfo]> {
        return Promise { resolver in
            fetchCarList(success: { result in
                resolver.fulfill(result)
            }, failure: { error in
                resolver.reject(error)
            })
        }
    }
}
