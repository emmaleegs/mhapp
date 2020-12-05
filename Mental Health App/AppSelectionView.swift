//
//  AppSelectionView.swift
//  Mental Health App
//
//  Created by Federico Brandt on 3/11/20.
//  Updated by Belen Carrasco on 28/11/20.
//  Copyright © 2020 Federico Brandt. All rights reserved.
//


//Most Used Apps Screen
import UIKit

class AppSelectionView: UIViewController, UITextFieldDelegate {
    
    //UI View and finishing button
    @IBOutlet weak var selectionAppView: UIView!
    @IBOutlet weak var finButton: UIButton!
    
    //App 1 Text Fields
    @IBOutlet weak var App1Name: UITextField!
    @IBOutlet weak var App1Hr: UITextField!
    @IBOutlet weak var App1Min: UITextField!
    
    //App2 Text Fields
    @IBOutlet weak var App2Name: UITextField!
    @IBOutlet weak var App2Hr: UITextField!
    @IBOutlet weak var App2Min: UITextField!
    
    //App3 Text Fields
    @IBOutlet weak var App3Name: UITextField!
    @IBOutlet weak var App3Hr: UITextField!
    @IBOutlet weak var App3Min: UITextField!
    
    //App4 Text Fields
    @IBOutlet weak var App4Name: UITextField!
    @IBOutlet weak var App4Hr: UITextField!
    @IBOutlet weak var App4Min: UITextField!
    
    //App5 Text Fields
    @IBOutlet weak var App5Name: UITextField!
    @IBOutlet weak var App5Hr: UITextField!
    @IBOutlet weak var App5Min: UITextField!
    
    //App6 Text Fields
    @IBOutlet weak var App6Name: UITextField!
    @IBOutlet weak var App6Hr: UITextField!
    @IBOutlet weak var App6Min: UITextField!
    
    //App7 Text Fields
    @IBOutlet weak var App7Name: UITextField!
    @IBOutlet weak var App7Hr: UITextField!
    @IBOutlet weak var App7Min: UITextField!
    
    //App8 Text Fields
    @IBOutlet weak var App8Name: UITextField!
    @IBOutlet weak var App8Hr: UITextField!
    @IBOutlet weak var App8Min: UITextField!
    
    //App9 Text Fields
    @IBOutlet weak var App9Name: UITextField!
    @IBOutlet weak var App9Hr: UITextField!
    @IBOutlet weak var App9Min: UITextField!
    
    //App10 Text Fields
    @IBOutlet weak var App10Name: UITextField!
    @IBOutlet weak var App10Hr: UITextField!
    @IBOutlet weak var App10Min: UITextField!
    
    
    @IBAction func finishButton(_ sender: Any) {
            writeToFile() //Create Local File
            dismiss(animated: true, completion: nil) //Dismiss current view
    }
    
    func writeToFile(){
        let fileName = "AppUsage" //For this View we are writing to AppUsage.txt locally
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        
        print("File Path: \(fileURL.path)") //Comment this if you want
        
        //Obtain date and format it accordingly
        let formatter : DateFormatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yy"
        let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        
        //Formatting the string to be written
        let writeString =  "\(myStr):com.\(App1Name.text!).apple:\(App1Hr.text!).\(App1Min.text!).0 com.\(App2Name.text!).apple:\(App2Hr.text!).\(App2Min.text!).0 com.\(App3Name.text!).apple:\(App3Hr.text!).\(App3Min.text!).0 com.\(App4Name.text!).apple:\(App4Hr.text!).\(App4Min.text!).0 com.\(App5Name.text!).apple:\(App5Hr.text!).\(App5Min.text!).0 com.\(App6Name.text!).apple:\(App6Hr.text!).\(App6Min.text!).0 com.\(App7Name.text!).apple:\(App7Hr.text!).\(App7Min.text!).0 com.\(App8Name.text!).apple:\(App8Hr.text!).\(App8Min.text!).0 com.\(App9Name.text!).apple:\(App9Hr.text!).\(App9Min.text!).0 com.\(App10Name.text!).apple:\(App10Hr.text!).\(App10Min.text!).0"
        
        //Write to file
        do{
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("Failed to write to URL ")
            print(error)
        }
        
        //Read file content. Comment this out if needed
        var ReadString = ""
        do{
            ReadString = try String(contentsOf: fileURL)
        }catch let error as NSError{
            print("Failed to read")
            print(error)
        }
        
        //Print file content. Comment this out if needed
        print("Content: \(ReadString)")
        
        // ----- UPDATES ------ //
        //Upload fileURL to local MAMP server
        func uploadData(_ sender: Any){
            let url = URL(string: "http://localhost:8888/mental_health_app/receive_appusage.php") // locahost MAMP - change to point to your database server
            
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            var dataURL = ""
            do{
                dataURL = try String(contentsOf: fileURL)
            }catch let error as NSError{
                print("Failed to read")
                print(error)
            }
            
            let candidateID = "\(ID.shared.CandidateID.text!)"
            
            var dataString = ""
            dataString = "&id=" + candidateID
            dataString = "&appusage=" + dataURL
            
            let dataD = dataString.data(using: .utf8) // convert to utf8 string
            
            do
            {
                // the upload task, uploadJob, is defined here
                let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
                {
                    data, response, error in
                    
                    if error != nil{
                        // display an alert if there is an error inside the DispatchQueue.main.async
                        
                        DispatchQueue.main.async
                        {
                            let alert = UIAlertController(title: "Upload Didn't Work?", message: "Looks like the connection to the server didn't work.  Do you have Internet access?", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    else
                    {
                        if let unwrappedData = data {
                            
                            let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                            
                            if returnedData == "1" // insert into database worked
                            {
                                
                                // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async
                                
                                DispatchQueue.main.async
                                {
                                    let alert = UIAlertController(title: "Upload OK?", message: "Looks like the upload and insert into the database worked.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                            else
                            {
                                // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async
                                
                                DispatchQueue.main.async
                                {
                                    let alert = UIAlertController(title: "Upload Didn't Work", message: "Looks like the insert into the database did not worked.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                uploadJob.resume()
            }
        }
        
    }
    // ----- END UPDATES ------ //
    
    //Allows keyboard to be hidden if touching anything outside of keyboard area
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectionAppView.layer.cornerRadius = 3 //Set up each corner radius
        self.hideKeyboardWhenTappedAround() //Set up keyboard hiding
        setupFields() //Set up finishing button functionality
       
        // Do any additional setup after loading the view.
    }
    

    //Disable finish button until all text fields are populated
    func setupFields(){
        finButton.isEnabled = false
        
        //Create Listener for App 1 Text Fields
        App1Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App1Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App1Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 2 Text Fields
        App2Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App2Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App2Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 3 Text Fields
        App3Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App3Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App3Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 4 Text Fields
        App4Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App4Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App4Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 5 Text Fields
        App5Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App5Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App5Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 6 Text Fields
        App6Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App6Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App6Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 7 Text Fields
        App7Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App7Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App7Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 8 Text Fields
        App8Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App8Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App8Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 9 Text Fields
        App9Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App9Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App9Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
        //Create Listener for App 10 Text Fields
        App10Name.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App10Hr.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        App10Min.addTarget(self, action: #selector(textFilled), for: .editingChanged)
        
    }
    
    //Function that uses listeners to detect whether text fields are populated
    @objc func textFilled(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        //Setup listeners and wait until textfields are filled
        guard
            let app1name = App1Name.text, !app1name.isEmpty,
            let app1hr = App1Hr.text, !app1hr.isEmpty,
            let app1min = App1Min.text, !app1min.isEmpty,
            
            let app2name = App2Name.text, !app2name.isEmpty,
            let app2hr = App2Hr.text, !app2hr.isEmpty,
            let app2min = App2Min.text, !app2min.isEmpty,
            
            let app3name = App3Name.text, !app3name.isEmpty,
            let app3hr = App3Hr.text, !app3hr.isEmpty,
            let app3min = App3Min.text, !app3min.isEmpty,
            
            let app4name = App4Name.text, !app4name.isEmpty,
            let app4hr = App4Hr.text, !app4hr.isEmpty,
            let app4min = App4Min.text, !app4min.isEmpty,
            
            let app5name = App5Name.text, !app5name.isEmpty,
            let app5hr = App5Hr.text, !app5hr.isEmpty,
            let app5min = App5Min.text, !app5min.isEmpty,
            
            let app6name = App6Name.text, !app6name.isEmpty,
            let app6hr = App6Hr.text, !app6hr.isEmpty,
            let app6min = App6Min.text, !app6min.isEmpty,
            
            let app7name = App7Name.text, !app7name.isEmpty,
            let app7hr = App7Hr.text, !app7hr.isEmpty,
            let app7min = App7Min.text, !app7min.isEmpty,
            
            let app8name = App8Name.text, !app8name.isEmpty,
            let app8hr = App8Hr.text, !app8hr.isEmpty,
            let app8min = App8Min.text, !app8min.isEmpty,
            
            let app9name = App9Name.text, !app9name.isEmpty,
            let app9hr = App9Hr.text, !app9hr.isEmpty,
            let app9min = App9Min.text, !app9min.isEmpty,
            
            let app10name = App10Name.text, !app10name.isEmpty,
            let app10hr = App10Hr.text, !app10hr.isEmpty,
            let app10min = App10Min.text, !app10min.isEmpty
        else
        {
            self.finButton.isEnabled = false
            return
        }
        //Enable is all text fields are true
        finButton.isEnabled = true
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
