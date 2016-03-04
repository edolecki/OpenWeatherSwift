//
//  ViewController.swift
//  OpenWeather
//
//  Created by Eric Dolecki on 3/4/16.
//  Copyright © 2016 Eric Dolecki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var weatherFetch: WeatherFetch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherFetch = WeatherFetch(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        weatherFetch.updateTheWeather()
        weatherFetch.beginFetchingWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

