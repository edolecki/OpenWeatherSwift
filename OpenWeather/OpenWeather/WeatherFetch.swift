//
//  WeatherFetch.swift
//  OpenWeather
//
//  Created by Eric Dolecki on 3/4/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import Foundation
import UIKit

class WeatherFetch: UIView {
    
    var myFrame: CGRect!
    var APIKey = "add your key here"
    var weatherFetchTimer: NSTimer!
    var cityName = "boston"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        myFrame = frame
    }
    
    func beginFetchingWeather(){
        if weatherFetchTimer != nil {
            weatherFetchTimer.invalidate()
        }
        
        //We'll check the weather twice an hour.
        
        weatherFetchTimer = NSTimer.scheduledTimerWithTimeInterval(1800, target: self,
            selector: "updateTheWeather", userInfo: nil, repeats: true)
    }
    
    func stopFetchingWeather(){
        if weatherFetchTimer != nil {
            weatherFetchTimer.invalidate()
        }
    }
    
    func updateTheWeather(){
        let baseUrl: String = "http://api.openweathermap.org/data/2.5/weather"
        let url: String = "\(baseUrl)?q=\(cityName)&units=imperial&appid=\(APIKey)"
        let finalUrl: NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(finalUrl, completionHandler: {data, response, error -> Void in
            if error != nil{
                print(error!.localizedDescription)
            }
            
            let qualityOfServiceClass = QOS_CLASS_BACKGROUND
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, {
                
                var err: NSError?
                let reachability:Reachability
                do {
                    reachability = try Reachability.reachabilityForInternetConnection()
                    if reachability.isReachable() == false {
                        return
                    }
                } catch {
                    print("can't create reachability.")
                }
                
                let json = JSON(data: data!, options: NSJSONReadingOptions(), error: &err)
                let weatherCurrent = json["main"]["temp"].stringValue
                let wc = weatherCurrent as NSString
                let floatwc = floor(wc.floatValue)
                let intwc = Int(floatwc)
                
                let weatherHigh = json["main"]["temp_max"].stringValue
                let wh = weatherHigh as NSString
                let floatwh = floor(wh.floatValue)
                let intwh = Int(floatwh)
                
                let weatherLow = json["main"]["temp_min"].stringValue
                let wl = weatherLow as NSString
                let floatwl = floor(wl.floatValue)
                let intwl = Int(floatwl)
                let weatherDescription = json["weather"][0]["description"].stringValue
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //let icon = json["weather"][0]["icon"].stringValue
                    let weatherString = "C: \(intwc)°F, H: \(intwh)°F, L: \(intwl)°F, cond: \(weatherDescription.capitalizedString)"
                    print(weatherString)
                })
            })
        })
        task.resume()
    }
}