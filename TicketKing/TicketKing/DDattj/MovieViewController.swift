//
//  MovieViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/25/24.
//

import Foundation
import UIKit

class MovieViewController: UIViewController {
    
    var searchMovies: [MovieModel] = [] // 검색 시 나타나는 영화 정보 배열
    
    let searchBar = UISearchBar()
    
    var thirdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 16
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        setupThirdCollectionView()
        addMoviesToCollectionView()
        fetchAllMovies()
        setSearchBar()
        autoLayout()
    }

    
    //전체데이터 가지고 오기
    private func fetchAllMovies(language: String = "ko-KR", page: Int = 1) {
        Task {
            do {
                let moviesList = try await MovieManager.shared.fetchPopularMovies(page: page, language: language)
                self.searchMovies = moviesList
                DispatchQueue.main.async {
                    self.thirdCollectionView.reloadData()
                }
            } catch {
                print("Error fetching all movies: \(error)")
            }
        }
    }
    
    private func addMoviesToCollectionView() {
//        firstCollectionView.reloadData()
//        secondCollectionView.reloadData()
        thirdCollectionView.reloadData()
    }
    

    // 세 번째 CollectionView 설정
    private func setupThirdCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        thirdCollectionView.register(thirdCollectionViewCell.self, forCellWithReuseIdentifier: thirdCollectionViewCell.identifier)
        thirdCollectionView.dataSource = self
        thirdCollectionView.delegate = self
        view.addSubview(thirdCollectionView)
    }
    
    
    
    
    private func autoLayout() {
        //서치창 콜렉션뷰 오토레이아웃
        thirdCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thirdCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200), // 원하는 Y 좌표로 설정
            thirdCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 18),
            thirdCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -18),
            thirdCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10)
        ])
    }
    
    //서치바 만들기
    func setSearchBar() {
        searchBar.placeholder = "Search"
        searchBar.barTintColor = .systemBackground
        searchBar.layer.borderColor = UIColor.kGreen.cgColor // 테두리 색상 설정
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 20
        searchBar.backgroundImage = UIImage() //구분선 제거
        //돋보기 아이콘 넣기
        searchBar.setImage(UIImage(named: "icSearch"), for: UISearchBar.Icon.search, state: .normal)
        //삭제 아이콘 넣기
        searchBar.setImage(UIImage(named: "iCancel"), for: .clear, state: .normal)
        // 서치바의 프레임 설정
        searchBar.frame = CGRect(x: 25, y: 116, width: 342, height: 53)
        self.view.addSubview(searchBar)
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            //서치바 및 작성 전 안내 글씨색과 서치바 입력시 색 정하기
            textfield.backgroundColor = UIColor.systemBackground
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.kGray])
            textfield.textColor = UIColor.kBlack
            
            //왼쪽 돋보기 아이콘 넣기
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.kGreen
            }
            //오른쪽 x버튼 넣기
            if let rightView = textfield.rightView as? UIImageView {
                rightView.image = rightView.image?.withRenderingMode(.alwaysTemplate)
                //이미지 틴트 정하기
                rightView.tintColor = UIColor.kBlack
            }
            // 키보의 외의 공간 터치시 키보드창 내림
            closeKeyboard()
        }
    }
    func closeKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        // 서치바에서 포커스를 해제하여 키보드를 내림
        searchBar.resignFirstResponder()
    }
  
}

extension MovieViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //각 뷰에 보여질 정보 연결
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return searchMovies.count
    }
    
    //각 콜렉션뷰와 콜렉션셀 연결해주기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thirdCollectionViewCell", for: indexPath) as? thirdCollectionViewCell else {
            fatalError("Unable to dequeue thirdCollectionViewCell")
        }
        cell.configure(with: searchMovies[indexPath.item])
        return cell
    }
    
    // 콜렉션뷰 셀 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 111, height: 200)
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedMovie = searchMovies[indexPath.row]
           let detailViewController = MovieDetailView()
           detailViewController.movie = selectedMovie  // 영화 정보 전달

           let navigationController = UINavigationController(rootViewController: detailViewController)

           // 모달 뷰 전체 화면으로 설정
           navigationController.modalPresentationStyle = .fullScreen

           // 현재 뷰 컨트롤러에서 모달 방식으로 네비게이션 컨트롤러 표시
           present(navigationController, animated: true)
       }
}




extension MovieViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // 검색어가 비어있으면 전체 영화 목록을 표시
            fetchAllMovies()
        } else {
            // 검색어가 포함된 영화들만 필터링하여 업데이트
            let filteredMovies = searchMovies.filter { $0.title.range(of: searchText, options: .caseInsensitive) != nil }
            self.searchMovies = filteredMovies
            for movie in searchMovies {
                print("movie.title: \(movie.title)")
            }
            
            thirdCollectionView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 검색 버튼을 눌렀을 때 키보드를 닫음
        print("검색")
        searchBar.resignFirstResponder()
    }
}

