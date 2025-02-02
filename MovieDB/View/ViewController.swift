//
//  ViewController.swift
//  MovieDB
//
//  Created by adminIL on 21.06.2024.
//

import UIKit

class ViewController: UIViewController {

    lazy var movieLabel:UILabel = {
       let label = UILabel()
        label.text = "MovieDB"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var movieTableView:UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.dataSource = self
        table.delegate = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: "movie")
        return table
    }()
    
    var movieData:[Result] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        apiRequest()
    }
    
    func setupUI() {
        view.addSubview(movieLabel)
        view.addSubview(movieTableView)
        NSLayoutConstraint.activate([
            movieLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            movieLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.topAnchor.constraint(equalTo: movieLabel.bottomAnchor),
            movieTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            movieTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            movieTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    func apiRequest() {
        NetworkManager.shared.loadMovie { result in
            self.movieData = result
            self.movieTableView.reloadData()
        }
    }

}
extension ViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "movie", for: indexPath) as! MovieTableViewCell
        let movie = movieData[indexPath.row]
        cell.conf(movie: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDeteailViewController = MovieDetailViewController()
        let movieID = movieData[indexPath.row].id
        movieDeteailViewController.movieID = movieID ?? 0
        navigationController?.pushViewController(movieDeteailViewController, animated: true)
    }
    
}
