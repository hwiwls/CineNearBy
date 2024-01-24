//
//  ViewController.swift
//  CineNearBy
//
//  Created by hwijinjeong on 1/24/24.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var theaterList = TheaterList()
    
    // 2. 위치 메니저. 위치 관련 데이터를 관리하고 사용자의 위치에 대한 업데이트를 받음.
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 4. 위치 프로토콜 연결
        locationManager.delegate = self
        
        checkDeviceLocationAuthorization()
        configAnnotation()
    }
    
    @IBAction func findCineBtn(_ sender: UIButton) {
        showActionSheet() { cineType in
            if cineType == "전체보기" {
                self.configAnnotation()
            } else {
                self.addAnnotations(for: cineType)
            }
        }
    }
}

extension ViewController {
    func configAnnotation() {
        for theater in theaterList.mapAnnotations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
            annotation.title = theater.location
            
            mapView.addAnnotation(annotation)
        }
    }
    
    func addAnnotations(for type: String) {
        mapView.removeAnnotations(mapView.annotations)
        
        for theater in theaterList.mapAnnotations {
            if theater.type == type {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: theater.latitude, longitude: theater.longitude)
                annotation.title = theater.location
                
                mapView.addAnnotation(annotation)
            }
        }
    }
}

extension ViewController {
    // 1. 사용자에게 권한을 요청하기 위해, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {  // UI 작업에 영향을 안 주도록 별도의 스레드에서 실행
            if CLLocationManager.locationServicesEnabled() {    // 디바이스의 위치 설정이 활성화 되어있는지 확인
                // 권한 상태 가져오기
                let authorization: CLAuthorizationStatus    // 권한 상태를 담는 변수
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }

                DispatchQueue.main.async {  // UI 작업은 메인 스레드에서 실행
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            } else {
                print("위치 서비스가 꺼져 있어서 위치 권한 요청을 할 수 없어요.")
            }
        }
    }
    
    // 2. 사용자 위치 권한 상태 확인 후, 권한 요청
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:    // 아직 권한 결정을 한 번도 안 해본 상태 => 권한 문구를 띄워야 함
            print("notDetermined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 권한 문구 띄우기
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안의 위치 서비스 권한을 요청
            
        case .denied:   // 허용 안 함
            print("denied")
            // 설정으로 가서 권한을 허용하게끔 유도
            showLocationSettingAlert()
            
        case .authorizedAlways: // 항상 허용. 앱 사용 여부랑 상관 없이 위치 이벤트 수신 가능
            print("authorizedAlways")
            
        case .authorizedWhenInUse:  // 앱을 사용하는 동안 허용
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
            
        default:
            print("error")
        }
    }
    
    // 3. 설정으로 이동 alert
    func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동.", style: .default) { _ in
            // 아이폰 설정으로 이동하는 코드
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세요")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            let center = CLLocationCoordinate2D(latitude: 37.65502693170023, longitude: 127.04987686698631)
            self.setRegionAndAnnotation(center: center)
        }
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        // 지도 중심 기반으로 보여질 범위 설정. 중심을 기준으로 위도와 경도 각각 400미터 정도의 범위
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400, longitudinalMeters: 400)
        
        mapView.setRegion(region, animated: true)
    }
}

// 3. 위치 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    // 5. didUpdateLocations: 사용자의 위치를 성공적으로 가지고 온 경우 실행, 위치 업데이트가 발생할 때마다 시스템에 의해 자동으로 호출. locations는 새로 갱신된 위치 정보가 들어있는 CLLocation 객체의 배열.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)    // 새로 갱신된 모든 위치 정보 출력
        
        if let coordinate = locations.last?.coordinate {    // 가장 최근의 위치 정보를 가져와 coordinate 변수에 할당
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            setRegionAndAnnotation(center: coordinate)  // 중심 좌표 전달
        }
        locationManager.stopUpdatingLocation()  // 위치 업데이트 중단. 호출하지 않으면 계속해서 업데이트 됨.
    }
    
    // 6. didFailWithError: 사용자의 위치를 가지고 오지 못한 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("사용자 위치를 가지고 오지 못했습니다.")
    }
    
    // 4. 사용자 권한 상태가 바뀔 때를 알려줌
    //    거부했다가 설정에서 허용으로 바꾸거나, notDetermined에서 허용을 했거나 허용해서 위치를 갖고오는 도중에 다시 설정에서 거부를 하거나
    //   iOS 14 이상에서 가능
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
    //   iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
}

