//
//  ViewController.swift
//  RemoteTest2
//
//  Created by 金井英晃 on 2020/05/19.
//  Copyright © 2020 ifrit. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // テーブルビューをアウトレット登録する
    @IBOutlet weak var uiTableView: UITableView!
    
    // ロケーションマネージャ
    var locationManager: CLLocationManager!

    // セルに表示するようの変数
    var strArray = [[String]]()

    // 緯度
    var latitudeNow: String = ""

    // 経度
    var longitudeNow: String = ""

    // 配列の1つ目のインデックスカウンタ用
    var firstIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ロケーションマネージャのセットアップ関数を呼び出す
        setupLocationManager()
    }

    // ロケーションマネージャのセットアップ
    func setupLocationManager() {
        locationManager = CLLocationManager()

        // 位置情報取得許可ダイアログの表示
        guard let locationManager = locationManager else { return }
        locationManager.requestWhenInUseAuthorization()

        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()

        // ステータスごとの処理
        if status == .authorizedWhenInUse {
            locationManager.delegate = self

            // 位置情報取得の開始
            locationManager.startUpdatingLocation()
        }
    }

    // アラート表示
    func showAlert() {
        let alertTitle = "位置情報取得が許可されていません。"
        let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
        let alert: UIAlertController = UIAlertController(
            title: alertTitle,
            message: alertMessage,
            preferredStyle: UIAlertController.Style.alert
        )

        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: nil
        )

        // UIAlertController に Action を追加
        alert.addAction(defaultAction)

        // Alertを表示
        present(alert, animated: true, completion: nil)
    }

    // LocationGetボタンを押下すると配列へ位置情報を格納する
    @IBAction func getLocationInfo(_ sender: Any) {
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            strArray.append([String]())
            strArray[firstIndex].append(latitudeNow)
            strArray[firstIndex].append(longitudeNow)
            firstIndex = firstIndex + 1
        }
        // テーブルビューをリロード
        uiTableView.reloadData()
    }
    // セルの個数を指定するデリゲートメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strArray.count
    }

    // セルに値を設定するデータソースメソッド（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = strArray[indexPath.row][0] + "," + strArray[indexPath.row][1]
        return cell
    }

}

extension ViewController: CLLocationManagerDelegate {
    // 位置情報が更新された際に位置情報を格納する
    // - Parameters:
    //    - manager: ロケーションマネージャ
    //    - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude

        // 位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
    }
}
