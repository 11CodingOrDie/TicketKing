//
//  ViewController.swift
//  TicketKing
//
//  Created by IMHYEONJEONG on 4/22/24.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    private var movies: [MovieModel] = []
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(.white)
        setupScrollView()
        fetchMovieData()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -40)
        ])
    }
    
    
    
    private func fetchMovieData() {
        Task {
            await GenreManager.shared.loadGenresAsync()
            do {
                let movieData = try await MovieManager.shared.fetchMovies(endpoint: "top_rated", page: 1, language: "ko-KR")
                DispatchQueue.main.async {
                    self.movies = movieData.results
                    self.addMoviesToScrollView()
                }
            } catch {
                DispatchQueue.main.async {
                    print("An error occurred: \(error)")
                    self.showErrorAlert(error: error)
                }
            }
        }
    }

    
    private func addMoviesToScrollView() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        movies.forEach { movie in
            let movieView = createMovieView(for: movie)
            stackView.addArrangedSubview(movieView)
        }
    }
    
    private func createMovieView(for movie: MovieModel) -> UIView {
        let movieView = UIView()
        
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)"), placeholderImage: UIImage(named: "placeholder"))
        
        let titleLabel = UILabel()
        titleLabel.text = movie.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let genreLabel = UILabel()
        let movieGenreIds = movie.genreIDS
        let genreNames = GenreManager.shared.genreNames(from: movieGenreIds)
        genreLabel.text = genreNames
        genreLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        let voteLabel = UILabel()
        voteLabel.text = movie.voteAverage.formattedWithSeparator
        voteLabel.font = UIFont.boldSystemFont(ofSize: 11)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = movie.overview
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, genreLabel, voteLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        movieView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            stack.topAnchor.constraint(equalTo: movieView.topAnchor),
            stack.leftAnchor.constraint(equalTo: movieView.leftAnchor),
            stack.rightAnchor.constraint(equalTo: movieView.rightAnchor),
            stack.bottomAnchor.constraint(equalTo: movieView.bottomAnchor)
        ])
        
        return movieView
    }
    
    func showErrorAlert(error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to load movie data: \(error.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }

}
