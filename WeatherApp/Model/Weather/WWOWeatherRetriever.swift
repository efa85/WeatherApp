//
//  WWOWeatherRetriever.swift
//  WeatherApp
//
//  Created by Emilio Fernandez on 25/11/14.
//  Copyright (c) 2014 Emilio Fernandez. All rights reserved.
//

import Foundation

let WWOWeatherRetrieverDomain = "WWOWeatherRetrieverDomain"

enum WWOWeatherRetrieverErrorCode : Int {
    case UnexpectedJson
}

class WWOWeatherRetriever: WeatherRetriever {
    
    struct Configuration {
        let baseUrl: NSURL
        let apiV2Key: String
    }
    
    private let configuration: Configuration
    
    private let responseDataParser: WWOResponseDataParser
    
    private let urlSession: NSURLSession
    
    init(configuration: Configuration, responseDataParser: WWOResponseDataParser, urlSession: NSURLSession = NSURLSession.sharedSession()) {
        self.configuration = configuration
        self.responseDataParser = responseDataParser
        self.urlSession = urlSession
    }
    
    func retrieveWeatherWithLatitude(latitude: String, longitude: String, completionHandler: (WeatherResult) -> ()) {
        let request = NSURLRequest(URL:weatherURLWithLatitude(latitude, longitude: longitude))
        
        let task = urlSession.dataTaskWithRequest(request) { [unowned self] (data, response, error) in
            let result = self.weatherResultWithData(data, response: response, connectionError: error)
            completionHandler(result)
        }
        
        task.resume()
    }
    
}

private extension WWOWeatherRetriever {
    
    private func weatherURLWithLatitude(latitude: String, longitude: String) -> NSURL {
        let urlComponents = NSURLComponents(string: self.configuration.baseUrl.absoluteString!)!
        let urlEncodedLocation = (latitude + "," + longitude).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        urlComponents.queryItems = [
            NSURLQueryItem(name: "q", value: urlEncodedLocation),
            NSURLQueryItem(name: "format", value: "json"),
            NSURLQueryItem(name: "key", value: self.configuration.apiV2Key)
        ]
        return urlComponents.URL!
    }
    
    private func weatherResultWithData(
        data: NSData!,
        response: NSURLResponse!,
        connectionError: NSError!) -> WeatherResult {
        
        if let connectionError = connectionError {
            return .Failure(connectionError)
        }
            
        switch self.responseDataParser.parse(data) {
        case let .ContainsWeather(weather):
            return .Success(weather)
        case let .ErrorMessage(errorMessage):
            let error = NSError(domain: WWOWeatherRetrieverDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])
            return .Failure(error)
        case let .ParsingError(error):
            return .Failure(error)
        }
    }
    
}

// TODO make it accept AnyObject instead of NSData?

class WWOResponseDataParser {
    
    enum Result {
        case ContainsWeather(WeatherResponse)
        case ErrorMessage(String)
        case ParsingError(NSError)
    }
    
    func parse(data: NSData) -> Result {
        var error : NSError?
        let responseJsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error)
        
        if responseJsonObject == nil {
            return .ParsingError(error!)
        }
        
        if let responseJsonDict = responseJsonObject as? NSDictionary {
            if let dataPart = responseJsonDict["data"] as? NSDictionary {
                if let errors = dataPart["error"] as? NSArray {
                    if let error = errors[0] as? NSDictionary {
                        if let errorMessage = error["msg"] as? String {
                            return .ErrorMessage(errorMessage)
                        }
                    }
                }
                
                if let currentConditions = dataPart["current_condition"] as? NSArray {
                    if let currentCondition = currentConditions[0] as? NSDictionary {
                        if let temperature = currentCondition["temp_C"] as? String {
                            if let weatherDescs = currentCondition["weatherDesc"] as? NSArray {
                                if let weatherDesc = weatherDescs[0].objectForKey("value") as? String {
                                    let iconURLs = currentCondition["weatherIconUrl"] as NSArray
                                    let iconURL = iconURLs[0].objectForKey("value") as String
                                    
                                    let currentWeather = Weather(temperature: temperature, description: weatherDesc, iconURL: iconURL)
                                    
                                    let weatherArray = dataPart["weather"] as NSArray
                                    let firstWeather = weatherArray[0] as NSDictionary
                                    let astronomyArray = firstWeather["astronomy"] as NSArray
                                    let astronomyJsonObject = astronomyArray[0] as NSDictionary
                                    let sunrise = astronomyJsonObject["sunrise"] as String
                                    let sunset = astronomyJsonObject["sunset"] as String
                                    
                                    let astronomy = Astronomy(sunrise: sunrise, sunset: sunset)
                                    
                                    let weartherResponse = WeatherResponse(currentWeather: currentWeather, astronomy: astronomy)
                                    return .ContainsWeather(weartherResponse)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        error = NSError(domain: WWOWeatherRetrieverDomain, code: WWOWeatherRetrieverErrorCode.UnexpectedJson.rawValue, userInfo: nil)
        return .ParsingError(error!)
    }
    
}
