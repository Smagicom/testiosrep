//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by adminIL on 02.07.2024.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    private lazy var scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()

    private lazy var movieImage:UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var movieTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        return label
    }()
    
    private lazy var realiseStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stack  = UIStackView()
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var realiseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    private lazy var genreCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: "genre")
        return collection
    
    }()
    
    private lazy var starStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    private lazy var ratingLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    var movieID = 0
    var genre:[Genre] = []
    var movieData:MovieDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        NetworkManager.shared.loadMovieDetail(movieID: movieID) { movie in
            self.movieData = movie
            self.content()
        }
       
    }
    
    func content() {
        guard let movieData else {return}
        genre = movieData.genres
        genreCollectionView.reloadData()
        movieTitle.text = movieData.title
        realiseLabel.text = "Release date \(movieData.releaseDate ?? "comming soon")"
        NetworkManager.shared.loadImage(posterPath: movieData.posterPath) { data in
            self.movieImage.image = UIImage(data: data)
        }
        setStar(rating: movieData.voteAverage ?? 0)
        ratingLabel.text = String(format: "%.1f/10", movieData.voteAverage ?? 0.0)
        ratingLabel.text! += "\n \(movieData.voteCount)"
    }
    
    
    func setupUI() {
        view.addSubview(scrollView)
        
        [movieImage,movieTitle,realiseStackView,ratingStackView].forEach {
            scrollView.addSubview($0)
        }
        
        [realiseLabel,genreCollectionView].forEach {
            realiseStackView.addArrangedSubview($0)
        }
        [starStackView,ratingLabel].forEach {
            ratingStackView.addArrangedSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        movieImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.height.equalTo(424)
            make.width.equalTo(309)
            
        }
        
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(movieImage.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        realiseStackView.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(-10)
            make.leading.bottom.equalToSuperview()
        }
        ratingStackView.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom).offset(15)
            make.leading.equalTo(realiseStackView.snp.trailing).offset(15)
            make.bottom.equalToSuperview()
        }
        genreCollectionView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview()
        }
        realiseLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(20)
        }
        ratingLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
        }
        
    }
    
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }
    
    private func setStar(rating: Double) {
        let fillStar:Int = Int(rating / 2)
        let halfStar: Bool = Int(rating) % 2 == 1
        
        for _ in 1...fillStar {
            let fillStarImageView = UIImageView(image: UIImage(named: "fill"))
            fillStarImageView.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            starStackView.addArrangedSubview(fillStarImageView)
        }
        if halfStar {
            let halfStarImageView = UIImageView(image: UIImage(named: "half_fill"))
            halfStarImageView.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            starStackView.addArrangedSubview(halfStarImageView)
        }
        let emptyStar = 5 - fillStar - (halfStar ? 1:0)
        for _ in 1...emptyStar {
            let emptyStarImageView = UIImageView(image: UIImage(named: "not_fill"))
            emptyStarImageView.snp.makeConstraints { make in
                make.height.equalTo(20)
                make.width.equalTo(20)
            }
            starStackView.addArrangedSubview(emptyStarImageView)
        }
    }
    
}
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = genreCollectionView.dequeueReusableCell(withReuseIdentifier: "genre", for: indexPath) as! GenreCollectionViewCell
        let genre = genre[indexPath.row].name
        cell.label.text = genre
        return cell
    }
    
    
}
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        let genre = genre[indexPath.row].name
        label.text = genre
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 30)
    }
}
