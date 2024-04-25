//
//  MovieViewController.swift
//  TicketKing
//
//  Created by 이시안 on 4/25/24.
//

import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var allMovies: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    
    
    
    //상단타이틀
    let title1: UILabel = {
        let allMovies = UILabel()
        allMovies.text = "영화 선택"
        allMovies.font = UIFont.boldSystemFont(ofSize: 16)
        return allMovies
    }()
    
    
    
    //세그먼트컨트롤로 보여줄 정보 화면
    var segMovies: UISegmentedControl = {
        let segment = UISegmentedControl()
        
        //백그라운드 제거, 구분선 제거
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.kBlack, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)], for: .selected)//폰트 설정
        //세그먼트 타이틀
        segment.insertSegment(withTitle: "현재상영작", at: 0, animated: true)
        segment.insertSegment(withTitle: "상영예정작", at: 1, animated: true)
        segment.addTarget(self, action: #selector(changeUnderLinePosition), for: .valueChanged)
        return segment
    }()
    
    var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView()
        view.addSubview(title1)
        autoLayout()
        configureallMoviesConstaint()
        autoLayout()
        
        setSearchBar()
        segMovieAutoLayout()
    }
    
    
    
    
    //테이블뷰 설정
    func tableView() {
        allMovies.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        allMovies.delegate = self
        allMovies.dataSource = self
        view.addSubview(allMovies)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
            fatalError("error")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177
    }
    
    
    
    
    //서치바 만들기
    func setSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.barTintColor = .systemBackground
        searchBar.layer.borderColor = UIColor.kGreen.cgColor // 테두리 색상 설정
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 10
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
        }
    }
    
    
    
    
    //테이블뷰 오토레이아웃
    func configureallMoviesConstaint() {
        allMovies.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            allMovies.topAnchor.constraint(equalTo: view.topAnchor, constant: 242), // 원하는 Y 좌표로 설정
            allMovies.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            allMovies.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            allMovies.heightAnchor.constraint(equalToConstant: 520) // 화면에 보여질 높이 설정
        ])
    }
    
    
    func autoLayout() {
        title1.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title1.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            title1.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func segMovieAutoLayout() {
        self.addSubView(segMovies)
        self.addSubView(underLineView)
        
        segMovies.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segMovies.snp.bottom)
            $0.height.equalTo(2)
            $0.leading.equalTo(segMovies)
            $0.width.equalTo(segMovies.snp.width).dividedBy(segMovies.numberOfSegments)
        }
    }
    
    @objc private func changeUnderLinePosition() {
           let segmentIndex = CGFloat(segMovies.selectedSegmentIndex)
           let segmentWidth = segMovies.frame.width / CGFloat(segMovies.numberOfSegments)
           let leadingDistance = segmentWidth * segmentIndex

   // 아래는 0.3초의 시간 동안 view의 애니메이션을 주면서 밑줄의 constraints를 업데이트 해준다
           UIView.animate(withDuration: 0.3, animations: { [weak self] in
               guard let self = self else {
                   return
               }

               self.underLineView.snp.updateConstraints {
                   $0.leading.equalTo(self.segMovies).inset(leadingDistance)
               }
               self.layoutIfNeeded()
           })
       }
}
