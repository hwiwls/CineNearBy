//
//  Theater.swift
//  CineNearBy
//
//  Created by hwijinjeong on 1/24/24.
//

import Foundation
import MapKit

struct Theater {
    var type: String
    var location: String
    var latitude: Double
    var longitude: Double
}

struct TheaterList {
    var mapAnnotations: [Theater] = [
        Theater(type: "롯데시네마", location: "롯데시네마 서울대입구", latitude: 37.4824761978647, longitude: 126.9521680487202),
        Theater(type: "롯데시네마", location: "롯데시네마 가산디지털", latitude: 37.47947929602294, longitude: 126.88891083192269),
        Theater(type: "메가박스", location: "메가박스 이수", latitude: 37.48581351541419, longitude:  126.98092132899579),
        Theater(type: "메가박스", location: "메가박스 강남", latitude: 37.49948523972615, longitude: 127.02570417165666),
        Theater(type: "CGV", location: "CGV 영등포", latitude: 37.52666023337906, longitude: 126.9258351013706),
        Theater(type: "메가박스", location: "메가박스 창동", latitude: 37.65459867119826, longitude: 127.03865470454544),
        Theater(type: "롯데시네마", location: "롯데시네마 노원", latitude: 37.655165918701705, longitude: 127.06088927045316),
        Theater(type: "CGV", location: "CGV 수유", latitude: 37.64238388881166, longitude: 37.64238388881166),
        Theater(type: "CGV", location: "CGV 강남", latitude: 37.5015817216073, longitude: 127.02633912817626)
    ]
}
