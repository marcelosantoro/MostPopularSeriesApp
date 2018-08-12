//
//  MostPopularSeriesAppTests.swift
//  MostPopularSeriesAppTests
//
//  Created by Marcelo Santoro on 11/08/2018.
//  Copyright © 2018 Marcelo Santoro. All rights reserved.
//

import XCTest
@testable import MostPopularSeriesApp

class MostPopularSeriesAppTests: XCTestCase {
    
    //Simple Model Test
    var series = [Serie]()
    
    override func setUp() {
        super.setUp()
        
        let serie = Serie()
        serie.serieName = "Teste"
        serie.tbSerieImage = "http://urlDaImagem/123123123.jpg"
        self.series.append(serie)
        
    }
    
    override func tearDown() {
        
        super.tearDown()
        
        self.series.removeAll()
        
    }
    
    
    
    
    
}
