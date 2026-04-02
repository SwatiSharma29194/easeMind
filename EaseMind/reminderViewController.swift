//
//  reminderViewController.swift
//  EaseMind
//
//  Created by Rahul Sharma on 2026-01-21.
//

import UIKit

class reminderViewController: UIViewController {
    var userDefault = UserDefaults()
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var saveBtn: UIButton!
    var saveString = String()
    @IBOutlet weak var timePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
        //timePicker.layer.borderColor = UIColor.white.cgColor
        timePicker.layer.cornerRadius = 20
        timePicker.layer.borderWidth = 5
        timePicker.clipsToBounds = true
//        saveBtn.layer.borderWidth = 5
//        saveBtn.layer.borderColor = UIColor.black.cgColor
//        saveBtn.layer.cornerRadius = 10
       
    //    timePicker.backgroundColor = UIColor.darkGray
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if let userBtn = userDefault.value(forKey: "onReminder")
        {
            if(userBtn as! String == "1")
            {
                switchBtn.isOn = true
                self.userDefault.set("1", forKey: "onReminder")
               
            }
            else
            {
                switchBtn.isOn = false
                self.userDefault.set("0", forKey: "onReminder")
                
            }
        }
        else
        {
            switchBtn.isOn = false
            self.userDefault.set("0", forKey: "onReminder")
        }
    }
    @IBAction func switchBtnTap(_ sender: Any) {
    
        if(switchBtn.isOn)
            {
            if let userBtn = userDefault.value(forKey: "onReminder")
            {
                if(userBtn as! String == "0")
                {
                    switchBtn.isOn = false
                    let alert  = UIAlertController(title: "Add Reminder", message: "Please save some time to continue", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
     
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm a"
            dateFormatter.timeStyle = DateFormatter.Style.short
            dateFormatter.timeZone = TimeZone.current
            print("timePicker.date", timePicker.date)
            let time = dateFormatter.string(from: timePicker.date)
            print("\(time)")
            saveString = time
            self.userDefault.set("1", forKey: "onReminder")
            }
            else
            {
                
                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                self.userDefault.set("0", forKey: "onReminder")
            
        }
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func timePickerTap(_ sender: Any) {
    }
    func dateComponents(from timeString: String) -> DateComponents? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"   // "HH:mm" for 24-hour format
        formatter.locale = Locale.current

        guard let date = formatter.date(from: timeString) else {
            return nil
        }

        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
    func scheduleNotification() {
        if let components = dateComponents(from: saveString) {

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: components,
                repeats: true
            )
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

            let content = UNMutableNotificationContent()
            content.title = "Ready for next ?"
            content.body = "Your new task is here. So, please try to do it."
            content.sound = .default

            let identifier = UUID().uuidString
            let request = UNNotificationRequest(
                identifier: identifier,
                content: content,
                trigger: trigger
            )

            UNUserNotificationCenter.current().add(request)
        }
        let alert  = UIAlertController(title: "Your reminder is set", message: "You’ll receive a notification every day at the same time.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    @IBAction func saveBtnTap(_ sender: Any) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        print("timePicker.date", timePicker.date)
        let time = dateFormatter.string(from: timePicker.date)
        print("\(time)")
        saveString = time
        switchBtn.isOn = true
        self.userDefault.set("1", forKey: "onReminder")
        scheduleNotification()
        
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
