//
//  GlobalDataClass.swift
//  CovidTracker
//
//  Created by ERNEST MURIUKI on 05/11/2021.
//

import Foundation

struct GlobalDataClass: Codable{
    var updated: Double?
    var cases: Double?
    var todayCases: Double?
    var deaths: Double?
    var todayDeaths: Double?
    var recovered: Double?
    var active: Double?
    var critical: Double?
    var casesPerOneMillion: Double?
    var deathsPerOneMillion: Double?
    var tests: Double?
    var testsPerOneMillion: Double?
    var affectedCountries: Double?
}
