//
//  MHSurveyViewController.swift
//  Mental Health App
//
//  Created by Federico Brandt on 3/12/20.
//  Updated by Belen Carrasco on 28/11/20.
//  Copyright © 2020 Federico Brandt. All rights reserved.
//
//Mental Health PHQ-8 Screen

import UIKit

class MHSurveyViewController: UIViewController {
    
    //Not At All Button Setup
    var notAtAllSelected = false //Boolean to track whether button is pressed or not
    @IBOutlet weak var notAtAll: UIButton!
    @IBAction func NotAtAllButton(_ sender: Any) {
        if !notAtAllSelected{
            disableButtons() //Disable all buttons when selected
            notAtAll.layer.borderWidth = 1.5
            notAtAll.layer.borderColor = UIColor.green.cgColor
            notAtAllSelected = true //Set selected to true
            Answers[questionIndex] = 0 //Set Answer array for current index to selected answer
        }
        else{
            //Return all values to default
            notAtAll.layer.borderWidth = 0
            notAtAll.layer.borderColor = nil
            notAtAllSelected = false
            Answers[questionIndex] = -1
        }
    }
    
    //Several Days Button Setup
    var severalDaysSelected = false //Boolean to track whether button is pressed or not
    @IBOutlet weak var SeveralDays: UIButton!
    @IBAction func SeveralDaysButton(_ sender: Any) {
        if !severalDaysSelected{
            disableButtons() //Disable all buttons when selected
            SeveralDays.layer.borderWidth = 1.5
            SeveralDays.layer.borderColor = UIColor.green.cgColor
            severalDaysSelected = true //Set selected to true
            Answers[questionIndex] = 1 //Set Answer array for current index to selected answer

        }
        else{
            //Return all values to default
            SeveralDays.layer.borderWidth = 0
            SeveralDays.layer.borderColor = nil
            severalDaysSelected = false
            Answers[questionIndex] = -1
        }
    }
    
    var MoreThanHalfSelected = false
    @IBOutlet weak var MoreThanHalf: UIButton! //Boolean to track whether button is pressed or not
    @IBAction func MoreThanHalfButton(_ sender: Any) {
        if !MoreThanHalfSelected{
            disableButtons() //Disable all buttons when selected
            MoreThanHalf.layer.borderWidth = 1.5
            MoreThanHalf.layer.borderColor = UIColor.green.cgColor
            MoreThanHalfSelected = true //Set selected to true
            Answers[questionIndex] = 2 //Set Answer array for current index to selected answer

        }
        else{
            //Return all values to default
            MoreThanHalf.layer.borderWidth = 0
            MoreThanHalf.layer.borderColor = nil
            MoreThanHalfSelected = false
            Answers[questionIndex] = -1
        }
    }
    
    var NearlyEverySelected = false
    @IBOutlet weak var NearlyEvery: UIButton!
    @IBAction func NearlyEveryButton(_ sender: Any) {
        if !NearlyEverySelected{
            disableButtons() //Disable all buttons when selected
            NearlyEvery.layer.borderWidth = 1.5
            NearlyEvery.layer.borderColor = UIColor.green.cgColor
            NearlyEverySelected = true //Set selected to true
            Answers[questionIndex] = 3 //Set Answer array for current index to selected answer

        }
        else{
            //Return all values to default
            NearlyEvery.layer.borderWidth = 0
            NearlyEvery.layer.borderColor = nil
            NearlyEverySelected = false
            Answers[questionIndex] = -1
        }
    }
    
    //Back button setup
    @IBAction func BackButton(_ sender: Any) {
        //If screen is on the first question, then dismiss the screen
        if questionIndex == 0{
            dismiss(animated: true, completion: nil)
        }
        else{
            //Go back on the previous question
            questionIndex -= 1
            QuestionText.text = Questions[questionIndex] //Change question
            disableButtons() //Return all buttons to default state
        }
    }
    
    var perform = false //Boolean to control whether segue is performed or not
    @IBAction func NextButton(_ sender: Any) {
        //If not in the last question then iterate through the questions
        if questionIndex < 7{
            questionIndex += 1
            QuestionText.text = Questions[questionIndex] //Update question text
            disableButtons() //Return all buttons to default state
            perform = false //Dont perform segue
        }
        else{
            questionIndex = 7
            perform = true //perform segue true
            writeResponses() //Create and write to file
            performSegue(withIdentifier: "PHQComplete", sender: self) //Perform segue with name
        }
    }
    
    //Function to create and write answers of survey to local file
    func writeResponses(){
        let fileName = "Survey" //Local file name:Survey.txt
        
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt") //add extension
        
        print("File Path: \(fileURL.path)") //Comment this out if needed
        
        //Collect date data
        let formatter : DateFormatter = DateFormatter()
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        formatter.dateFormat = "dd-MM-yy" //write date data in this format
        let myStr : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        
        //Format string to be written
        let writeString = "\(myStr) \(hour):\(minutes):\(seconds): 0,\(Answers[0]) 1,\(Answers[1]) 2,\(Answers[2]) 3,\(Answers[3]) 4,\(Answers[4]) 5,\(Answers[5]) 6,\(Answers[6]) 7,\(Answers[7])"
        
        //Write string to file
        do{
            try writeString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        }catch let error as NSError{
            print("Failed to write to URL ")
            print(error)
        }
        
        //Read string from file. You can comment this out
        var ReadString = ""
        do{
            ReadString = try String(contentsOf: fileURL)
        }catch let error as NSError{
            print("Failed to read")
            print(error)
        }
        
        print("Content: \(ReadString)") //Comment this out if needed
        
        // ----- UPDATES ------ //
        //Upload fileURL to local MAMP server
        func uploadData(_ sender: Any){
            let url = URL(string: "http://localhost:8888/mental_health_app/receive_survey.php") // locahost MAMP - change to point to your database server
            
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
            dataString = "&survey=" + dataURL
            
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
    
    //Function that controls whether segue is to be performed or not
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if perform{
            return true
        }
        return false
    }
    
    //Returns all buttons to default state
    func disableButtons(){
        notAtAll.layer.borderWidth = 0
        notAtAll.layer.borderColor = nil
        notAtAllSelected = false
        NearlyEvery.layer.borderWidth = 0
        NearlyEvery.layer.borderColor = nil
        NearlyEverySelected = false
        MoreThanHalf.layer.borderWidth = 0
        MoreThanHalf.layer.borderColor = nil
        MoreThanHalfSelected = false
        SeveralDays.layer.borderWidth = 0
        SeveralDays.layer.borderColor = nil
        severalDaysSelected = false
    }
    
    var questionIndex = 0 //Index that controls which question is being shown on screen
    
    var Answers = [-1,-1,-1,-1,-1,-1,-1,-1] //Answer array. Can vary from 1-4 depending on the button selected
    
    //Question array. Holds all 8 different questions in string format
    var Questions = ["little interest or pleasure in doing things.",
                     "Feeling down, depressed, or hopeless.",
                     "Trouble falling or staying asleep, or sleeping too much.",
                     "Feeling tired or having little energy.",
                     "Poor appetite or overeating.",
                     "Feeling bad about yourself, or that you are a failure, or have let yourself or your family down",
                     "Trouble concentrating on things, such as reading the newspaper or watching television",
                    "Moving or speaking so slowly that other people could have noticed. Or the opposite – being so fidgety or restless that you havebeen moving around a lot more than usual"]
    
    //Question text field
    @IBOutlet weak var QuestionText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionText.text = Questions[questionIndex] //Initialize question text
        
        // Do any additional setup after loading the view.
    }
}

