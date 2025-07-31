//
//  AssignPageViewController.swift
//  ChoresApp
//
//  Created by Shivam Nanda on 10/5/22.
//

import UIKit

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore



class AssignPageViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var nameOfTask: UITextField!
    @IBOutlet weak var setDate: UITextField!
    @IBOutlet weak var assignToText: UIButton!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var repeatNumber: UITextField!
    @IBOutlet weak var choose_area: UITextField!
    @IBOutlet weak var select_time: UITextField!
    
   
    var callback: ((Chores) -> ())?
    var datePicker = UIDatePicker()
    var timePicker = UIDatePicker()
    let db = Firestore.firestore()
    var userCode : String = ""
    var pickerView_interval = UIPickerView()
    var pickerView_area = UIPickerView()
    var arrayNames = [String]()
    var repeatDates : [String] = []
    var numdays = 0
    var valRepeat = 0
    let today = Date()
    var stringImage: [String] = []
    var stringNames: [String] = []
    var docId : String = ""
    
    let intervals = ["Day","Week","Month"]
    let area = ["Living Room","Kitchen","Bathroom","Bedroom"]
    
    @IBAction func onCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // error checking is always a good idea
        //  this properly unwraps the destination controller and confirms it's
        //  an instance of NewItemViewController
        if let vc = segue.destination as? SelectMembersViewController {
            // callback is a property we added to NewItemViewController
            //  we declared it to return a String

            vc.callback = { item in
                self.stringNames = []
                self.stringImage = []
                for i in item{
                    self.stringNames.append(i.name)
                    self.stringImage.append(i.image.toPngString()!)
                    
                }
               
                let seperatedList = self.stringNames.joined(separator: ",")
                self.assignToText.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.left
                self.assignToText.setTitleColor(.black, for: .normal)
                
                self.assignToText.setTitle(seperatedList, for: .normal)
                   
            
               
                
                
//                self.tableView.reloadData()
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
//    func setIntervalDates(startDate,days,interval){
//
//
//    }
    
    @IBAction func createTaskTapped(_ sender: Any) {
        
        // start of section -> Get Date , convert to date and set array
        let startDateChosen = dateTF.text!
        let repeatNumberChosen =  repeatNumber.text!
        let repeatIntervalChosen = setDate.text!
        let remindTime = select_time.text!
        
        let areaChosen = choose_area.text!
        
        func repeatIntervalFunc(startDate:String,repeatNumber:Int, repeateInterval:String)->Array<String>{
            
            
            if repeateInterval == "Month"{
                self.numdays = 30
            }
            if repeateInterval == "Week"{
                self.numdays = 7
            }
            if repeateInterval == "Day"{
                self.numdays = 1
            }
            self.valRepeat = self.numdays / repeatNumber
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            var date_set = dateFormatter.date(from: startDate)!
            let date_set_formatted = date_set.formatted(date: .long , time: .omitted)
            repeatDates.append(date_set_formatted)
            
            for _ in 0...9{
                let modifiedDate = Calendar.current.date(byAdding: .day, value:self.valRepeat, to: date_set)!
                date_set = modifiedDate
               
               repeatDates.append(modifiedDate.formatted(date: .long , time: .omitted))
               
            }
            return repeatDates
            
        }
        
        var dateNew = repeatIntervalFunc(startDate: startDateChosen,repeatNumber: Int(repeatNumberChosen)!, repeateInterval: repeatIntervalChosen)

        
//        repeatDates.append(dateNew.formatted(date: .long , time: .omitted))
//
        

        // end of section
        
        
        if Auth.auth().currentUser != nil {
            let docsRef = db.collection("UserDetails").document(Auth.auth().currentUser!.uid as String)
            docsRef.getDocument { (querySnapshot, error) in
                if let e = error{
                    print(e)
                }
                else{
                    if let snapshot = querySnapshot {
                        self.userCode = snapshot.get("houseCode") as! String
                        
                    }
                    
                    let docRef = self.db.collection("Usergroups").document(self.userCode).collection("Tasks")
                    docRef.getDocuments { snap, error in
                        let creatDoc = docRef.document()
                        self.docId = creatDoc.documentID
                        print(self.docId)
                        
                        
                        
                            print("NOTTTT EMPTYYYYYYY")
                            docRef.document(self.docId).setData([
                                
                                
                                "nameofTask": self.nameOfTask.text!,
                                "startDate" : self.dateTF.text!,
                                "repeatNumber" : self.repeatNumber.text!,
                                "repeateInterval" : self.setDate.text!,
                                "repeatDatesArray" : self.repeatDates,
                                "dueDate": remindTime,
                                "assignedTo": self.stringNames,
                                "isCompleted": false,
                                "assignedToImage": self.stringImage,
                                "areaChosen" : areaChosen,
                                "docId": self.docId
                                
                                
                            ])
                            
                    }
                        
                        let todayFormatted = self.today.formatted(date: .long , time: .omitted)
                        print(self.dateTF.text! ,todayFormatted)
                        if self.dateTF.text! == todayFormatted{
                            let chore = Chores(taskName: self.nameOfTask.text!, dueDate: remindTime, assignedTo: HomeMembers(name: self.stringNames[0], image: self.stringImage[0].toImage()!), done: false, area: areaChosen,docID: self.docId
                            )
                            
                            self.callback?(chore)
                        }
 
                        
                    }
                    
                }
                
            }
            
            self.dismiss(animated: true)
        }
        
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {

        
        
        timePicker.datePickerMode = .time
//        intervals
        timePicker.frame.size = CGSize(width: 150, height: 300)
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.minuteInterval = 15
//        let timeformatter = DateFormatter()
//            timeformatter.dateFormat = "HH:mm"
        timePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        select_time.inputView = timePicker
        
        
        
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange(datePicker:)), for: UIControl.Event.valueChanged)
        datePicker.frame.size = CGSize(width: 0, height: 300)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.minimumDate = Date()
        
        dateTF.inputView = datePicker
        dateTF.text = formatDate(date: Date()) // todays Date
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        pickerView_interval.delegate = self
        pickerView_interval.dataSource = self
        
        
        pickerView_area.delegate = self
        pickerView_area.dataSource = self
        
        setDate.inputView = pickerView_interval
        choose_area.inputView = pickerView_area

        nameOfTask.delegate = self
        setDate.delegate = self
        choose_area.delegate = self
        repeatNumber.delegate = self
    }

    @objc func dateChange(datePicker: UIDatePicker)
    {
        if datePicker == timePicker{
            select_time.text = formatTime(time: timePicker.date)
            timePicker.resignFirstResponder()
        }
        else{
            dateTF.text = formatDate(date: datePicker.date)
            datePicker.resignFirstResponder()
        }
       
        
    }
    @objc func touchedOutsideOverlay(_ sender: UITapGestureRecognizer){
        dateTF.removeFromSuperview()
        dateTF.resignFirstResponder()
    }
    
    
    func formatDate(date: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        return formatter.string(from: date)
    }
    func formatTime(time: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    func donePressed() {
        select_time.resignFirstResponder()
        dateTF.resignFirstResponder()
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

extension AssignPageViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView == pickerView_area{
            return area.count
        }
        else {
            return intervals.count
        }
      
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerView_area{
            return area[row]
        }
        else {
            return intervals[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerView_area{
            choose_area.text = area[row]
            choose_area.resignFirstResponder()
        }
        else {
            setDate.text = intervals[row]
            setDate.resignFirstResponder()
        }

    }

    
    

}
extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}
extension UIImage {
    func toPngString() -> String? {
        let data = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
  
    func toJpegString(compressionQuality cq: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: cq)
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
