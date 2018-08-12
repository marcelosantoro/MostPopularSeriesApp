//
//  SeriesController.swift
//  MostPopularSeriesApp
//
//  Created by Marcelo Santoro on 11/08/2018.
//  Copyright © 2018 Marcelo Santoro. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class SeriesController: UIViewController {
   
    //PullToRefresh
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            if #available(iOS 10.0, *) {
                collectionView.refreshControl = refreshControl
            } else {
                collectionView.addSubview(refreshControl)
            }
        }
    }

    

    
    //Model do Series
    var series = [Serie]()
    
    //JsonOBJ
    var jSeries: JSON = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadSeriesFromAPI()
        
        self.refreshControl.tintColor = UIColor(rgb: 0xFEB275)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Arraste para Recarregar", attributes: nil)
        self.refreshControl.addTarget(self, action: #selector(refreshSeriesData(_:)), for: .valueChanged)
        
        
        
    }
    
    
    
    //Changing Status Bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @objc func refreshSeriesData(_ sender: Any){
        self.loadSeriesFromAPI()
        self.refreshControl.endRefreshing()
        //self.collectionView.reloadData()
        
    }
    
    func messageStatusBar(msg: String){
        let status2 = MessageView.viewFromNib(layout: .statusLine)
        status2.backgroundView.backgroundColor = UIColor(rgb: 0xFEB275)
        status2.bodyLabel?.textColor = UIColor.red
        status2.configureContent(body: msg)
        
        var status2Config = SwiftMessages.defaultConfig
        status2Config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        status2Config.preferredStatusBarStyle = .lightContent
        
        SwiftMessages.show(config: status2Config, view: status2)
    }

    
    func loadSeriesFromAPI()
    {
        if Reachability.isConnectedToNetwork(){
            
            //print("Internet Connection Available!")
            
            //Show Load
            let sv = UIViewController.displaySpinner(onView: self.view)
            
            let url = URL(string: "https://api.trakt.tv/shows/popular")!
            
            let headers = [
                "Content-Type": "application/json",
                "trakt-api-key": "2659378e0e742dbb9df60a356a82921ec3219f505a01b17fbca7e0146c1d2f3c",
                "trakt-api-version": "2"
            ]
            
            
            let manager = Alamofire.SessionManager.default
            manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON
                { response in
                    let status = response.response?.statusCode
                    if(status! == 200)
                    {
                        self.jSeries = JSON(response.result.value as Any)
                        
                        if(self.jSeries.count > 0)
                        {
                            for (obj) in self.jSeries {
                                let serieName = obj.1["title"]
                                let tmdbID = obj.1["ids"]["tmdb"]
                                self.loadThumbImages(tmdbID: "\(String(describing: tmdbID))", showName: "\(String(describing: serieName))", sv: sv )
                            }
                        }
                        else
                        {
                            self.messageStatusBar(msg: "Erro ao ler dados da API")
                        }
                    }
                    else{
                        self.messageStatusBar(msg: "Erro ao ler dados da API")
                    }
            }
            
            
        }else{
            //print("Internet Connection not Available!")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.messageStatusBar(msg: "Sem conexão a Internet :( !!!")
            })
        }

        
        
        
        
    }
    
    func loadThumbImages(tmdbID: String, showName: String, sv: UIView)
    {
        //Clear Array
        self.series.removeAll()
        
        let url = URL(string: "https://api.themoviedb.org/3/tv/\(tmdbID)?api_key=0927b2c4690cc7c3c62041d3b63b2b5c")!
        
        let manager = Alamofire.SessionManager.default
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON
            { response in
                let status = response.response?.statusCode
                //print("STATUS RETURN: \(String(describing: status!))")
                if(status! == 200)
                {
                    
                    let LocaljImageData = JSON(response.result.value as Any)
                    let poster_path = LocaljImageData["poster_path"]
                    let posterURL = "https://image.tmdb.org/t/p/w185/\(poster_path)"
                    //print("ShowName: \(showName) - PosterURL: \(posterURL)")
                    
                    //Add data to Model Array - ShowName and ImageURL
                    let serie = Serie()
                    serie.serieName = "\(showName)"
                    serie.tbSerieImage = "\(posterURL)"
                    self.series.append(serie)
                    
                    if(self.series.count == self.jSeries.count)
                    {
                        UIViewController.removeSpinner(spinner :sv)
                        //Reload CollectionView
                        self.collectionView.reloadData()
                    }
                    
                }
                else{
                    self.messageStatusBar(msg: "Erro ao ler dados dos Posters")
                }
        }
        
        
    }
    
    
    
}

extension SeriesController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("NumberOfRows: \(series.count)")
        return series.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SerieViewCell.identifier, for: indexPath)
        
        
        if let cell = cell as? SerieViewCell {
            let serie = series[indexPath.item]
            cell.setup(with: serie)
        }
        
        return cell
    }
    

}
