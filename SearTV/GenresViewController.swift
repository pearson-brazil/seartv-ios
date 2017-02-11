//
//  GenresViewController.swift
//  SearTV
//
//  Created by Pearson on 10/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class GenresViewController: UIViewController {
  
  
  
  var content: Content<[Genre.ViewModel]> = .loading {
    didSet {
      updateViews()
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var errorLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    updateViews()
    
    GenresInteractor.shared.getGenres() { content in
      self.content = content
    }
  }
  
  func updateViews() {
    switch content {
    case .success:
      errorView.isHidden = true
      loadingView.isHidden = true
      tableView.isHidden = false
      
      self.tableView.reloadData()
    case .loading:
      errorView.isHidden = true
      loadingView.isHidden = false
      tableView.isHidden = true
    case .error(let error):
      errorView.isHidden = false
      loadingView.isHidden = true
      tableView.isHidden = true

      if case .userMessage(let message) = error {
        errorLabel.text = message
      }
    }
  }
}

extension GenresViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if case .success(let genres) = content {
      return genres.count
    }
    
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableViewCell")!
    
    if case .success(let genres) = content {
      cell.textLabel?.text = genres[indexPath.row].name
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    debugPrint(GenresInteractor.shared.getGenre(byIndex: indexPath.row))
  }
}
