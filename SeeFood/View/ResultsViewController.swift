//
//  ResultsViewController.swift
//  SeeFood
//
//  Created by Joseph Toronto on 1/14/21.
//

import UIKit


class ResultsViewController: UIViewController, UIImagePickerControllerDelegate,
                      UINavigationControllerDelegate, UITableViewDataSource, ImageProcessorDelegate {
   
   
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var resultsTableView: UITableView!
    
    var imageToProcess: UIImage?
    
    
    private let imageProcessor = ImageProcessor()
    private var classificationResults: [String] = []
    private var activityView: UIView?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsTableView.dataSource = self
        
        imageProcessor.delegate = self
       
        if let image = imageToProcess{
            imageView.image = image
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let ciImage = CIImage(image: imageToProcess!) else{
            fatalError("Unable to convert to CIImage")
        }
        imageProcessor.detectAndClassifyImage(image: ciImage)
        showActivityMonitor()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    func showActivityMonitor(){
        activityView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        let activityMonitor = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        activityMonitor.style = .large
        let blurView = UIVisualEffectView(frame: activityView!.frame)
        blurView.effect = UIBlurEffect(style: .regular)
        activityView?.addSubview(blurView)
        activityMonitor.center = activityView!.center
        activityView!.addSubview(activityMonitor)
            
        self.view.addSubview(activityView!)
        activityMonitor.startAnimating()
        
        
    }
    
    //MARK: - Tableview Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        classificationResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsCell")
        cell?.textLabel?.text = classificationResults[indexPath.row]
        return cell!
    }
    
    
    //MARK: - Image Processor delegate method
    
    func imageProcessorDidReturnResults(results: [String]) {
        classificationResults = results
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
            self.activityView?.removeFromSuperview()
        }
        
       
        
    }
    
    
    
}

