//
//  PersonInfoCell.swift
//  TicketKing
//
//  Created by David Jang on 4/26/24.
//

import UIKit
import SnapKit
import SDWebImage

class PersonInfoCell: UIView {
    
    enum ViewMode {
        case director  // Displays director info
        case actor     // Displays actor info
    }
    
    private let profileImageView = UIImageView()
    private let firstNameLabel = UILabel()
    private let lastNameLabel = UILabel()
    
    var viewMode: ViewMode
    var movieId: Int
    
    init(frame: CGRect, movieId: Int, viewMode: ViewMode) {
        self.movieId = movieId
        self.viewMode = viewMode
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(firstNameLabel)
        addSubview(lastNameLabel)
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 16
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOpacity = 0.5
        profileImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        profileImageView.clipsToBounds = true
        
        firstNameLabel.textColor = .black
        firstNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        firstNameLabel.numberOfLines = 2
        firstNameLabel.textAlignment = .center
        
        lastNameLabel.textColor = .darkGray
        lastNameLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        lastNameLabel.numberOfLines = 2
        lastNameLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.8)
        }
        
        firstNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()  // centerX를 사용하여 중앙 정렬
            make.left.right.equalToSuperview().inset(4)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()  // centerX를 사용하여 중앙 정렬
            make.left.right.equalToSuperview().inset(4)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    
    func loadData() {
        switch viewMode {
        case .director:
            loadDirectorData()
        case .actor:
            loadActorData()
        }
    }
    
    private func loadDirectorData() {
        Task {
            do {
                let credits = try await MovieManager.shared.fetchCredits(for: movieId)
                if let director = credits.crew.first(where: { $0.job.lowercased() == "director" }) {
                    DispatchQueue.main.async {
                        self.configureWithPerson(name: director.name, profilePath: director.profilePath)
                    }
                }
            } catch {
                print("Error fetching director details: \(error)")
            }
        }
    }
    
    private func loadActorData() {
        Task {
            do {
                let credits = try await MovieManager.shared.fetchCredits(for: movieId)
                if let firstActor = credits.cast.first {
                    DispatchQueue.main.async {
                        self.configureWithPerson(name: firstActor.name, profilePath: firstActor.profilePath)
                    }
                }
            } catch {
                print("Error fetching actor details: \(error)")
            }
        }
    }
    
    private func configureWithPerson(name: String, profilePath: String?) {
        let components = name.components(separatedBy: " ")
        if components.count > 1 {
            firstNameLabel.text = components.first
            lastNameLabel.text = components.dropFirst().joined(separator: " ")
        } else {
            firstNameLabel.text = name
            lastNameLabel.text = ""
        }
        
        if let imagePath = profilePath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)") {
            profileImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}

