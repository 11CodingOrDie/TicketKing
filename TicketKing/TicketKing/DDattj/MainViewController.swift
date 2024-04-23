//
//  MainViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/23/24.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //사용할 컬렉션뷰, 테이블뷰 이름 지정
    let releasedMovie: UICollectionView
    let comingUpMovie: UITableView
    
    //클래스 초기화 시 기본적으로 유지할 데이터를 남기기 위해 작성
    init() {
        self.releasedMovie = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        self.comingUpMovie = UITableView(frame: .zero, style: .plain)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //브랜드로고 넣기
        let appTitle = UIImage(named: "title")
        let imageView = UIImageView(image: appTitle!)
        imageView.frame = CGRect(x: 25, y: 80, width: 138, height: 29.58)
        self.view.addSubview(imageView)
        self.view.bringSubviewToFront(imageView)
        
        //프로필 이미지칸 만들기
        let myimage = UIView()
        myimage.backgroundColor = UIColor(named: <#T##String#>)
        
    }
    
    
    
    
    //컬렉션뷰 한 줄에 몇개
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    //컬렉션뷰 cell은 어떤 모양으로
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as? MainCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    //컬렉션뷰의 사이즈
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 393, height: 354)
    }
    //컬렉션뷰 cell의 간격과 사이즈 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 35 //상하간격
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24.05 //좌우간격
    }
    
    
    
    
    //위에서 설정해준 컬렉션뷰 기본설정 적용
    func releasedMoviePoster() {
        releasedMovie.register(MainViewController.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        releasedMovie.delegate = self
        releasedMovie.dataSource = self
    }
}
