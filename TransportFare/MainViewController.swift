//
//  MainViewController.swift
//  TransportFare
//
//  Created by TheMacUser on 09.07.2020.
//  Copyright © 2020 TheMacUser. All rights reserved.
//

import UIKit
import MessageUI
class MainViewController: UIViewController, TransportType, Buttons, PaymentViewProtocol, CityDropDown, MFMessageComposeViewControllerDelegate {

    
    

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

    static let shared = MainViewController()
    var buttonsModel = ButtonsModel()
    var routeNumber: String?
    var widthOfVerticalStack: Int = 0
    var dropDownMenuOfcitysIsHidden = false
    @IBOutlet weak var transportTypeView: TransportTypeView!
    @IBOutlet weak var routesView: RoutesView!
    
    @IBOutlet weak var informationView: InformationView!
    
    @IBOutlet var cityDropDownView: CityDropDownView!
    @IBOutlet weak var paymentView: PaymentView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet var mainBackButton: UIButton!
    
    @IBAction func backButton(_ sender: UIButton) {
        print("\(sender.title(for: .normal))")
        if paymentView.isHidden == false {
            paymentView.isHidden = true
            routesView.isHidden = false
        } else if paymentView.isHidden == true {
            routesView.isHidden = true
            backButton.isHidden = true
            mainBackButton.isHidden = true
            informationView.isHidden = true
            cityDropDownView.unblur()
            transportTypeView.unblur()
            clearButtonsAndStack()
            transport = nil
            
        }
       if dropDownMenuOfcitysIsHidden == false {
            dropDownMenuOfcitysIsHidden = true
            updateDropDownMenuOfCyties()
        }
    }
    var vinnitsa: City?
    var lviv: City?
    var zhytomyr: City?
    var ivanoFrankivsk: City?
    let defaults = UserDefaults.standard
    var transport: TransportModel?
    var route: String!
    var city: City?
    var cities: [City] = []
    var citiesDropDownMenuButtons: [UIButton] = []
    let vinnitsaTram = TransportModel(transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"])
    let vinnitsaTrolleybus = TransportModel(transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"])
    let vinnitsaAutobus = TransportModel(transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"])
    let lvivTram = TransportModel(transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"])
    let lvivTrolleybus = TransportModel(transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"])
    let lvivAutobus = TransportModel(transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"])
    let zhytomyrTram = TransportModel(transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"])
    let zhytomyrTrolleybus = TransportModel(transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"])
    let zhytomyrAutobus = TransportModel(transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"])
    let ivanoFrankivskTram = TransportModel(transportType: "Трамвай", routeNumbers: ["1", "2", "3", "4", "5", "6"], ticketPrice: 4, transportRoutes: ["Залізничний вокзал - Електромережа", "Барське шосе - Вишенька", "Вишенька - Електромережа", "Барське шосе - Залізничний вокзал", "Барське шосе - Електромережа", "Залізничний вокзал - Вишенька"], routeTextCodes: ["SAC1", "SAC2", "SAC3", "SAC4", "SAC5", "SAC6"])
    let ivanoFrankivskTrolleybus = TransportModel(transportType: "Тролейбус", routeNumbers: ["1", "2", "3", "4", "5", "6", "6A", "7", "8", "9", "10", "11", "12", "13", "14", "15"], ticketPrice: 4, transportRoutes: ["Лугова - ВПЗ", "Меморіал Визволення - Чехова", "Вишенька - ВПЗ", "Вишенька - Лугова", "Залізничний вокзал - Вишенька", "Меморіал Визволення - Залізничний вокзал", "ВПЗ - Залізничний вокзал", "Залізничний вокзал - Лугова", "Вишенька - Меморіал Визволення", "Меморіал Визволення - Князів Коріатовичів", "Вишенька - Чехова", "Залізничний вокзал - Князів Коріатовичів", "Аграрний університет - Чехова", "Меморіал Визволення - Аграрний університет", "Залізничний вокзал - Аграрний університет", "Вишенька - Муніципальний ринок"], routeTextCodes: ["SAB1", "SAB2", "SAB3", "SAB4", "SAB5", "SAB6", "SAB6A", "SAB7", "SAB8", "SAB9", "SAB10", "SAB11", "SAB12", "SAB13", "SAB14", "SAB15"])
    let ivanoFrankivskAutobus = TransportModel(transportType: "Автобус", routeNumbers: ["1", "2", "5", "6", "7", "8", "11", "14", "16", "17", "19", "20", "21", "22", "24", "27", "30"], ticketPrice: 5, transportRoutes: ["Залізничний вокзал - Педучилище", "Вул. Сергія Зулінського - Площа Шкільна", "П'ятничани - Вул. Комарова", "Олієжиркомбінат - Площа Перемоги", "Вул. Якова Шепеля - Пирогово", "Залізничний вокзал - Вул. Бучми (ліс)", "Вул. Ботанічна - Сабарів", "Залізничний вокзал - Будинок відпочинку", "Меморіал Визволення - Барське шосе" + "\n" + " - Аграрний університет", "Залізничний вокзал - Тяжилів \n (Вінниччина-Авто)", "Вишенька - Немирівське шосе", "Меморіал Визволення - Хутір Шевченка", "Барське шосе - Педучилище", "Залізничний вокзал - Мікрорайон \n 'Академічний'", "Вишенька - Вул. Бучми (ліс)", "Залізничний вокзал - Тиврівське шосе", "смт. Десна - Будинок відпочинку"], routeTextCodes: ["SAA1", "SAA2", "SAA5", "SAA6", "SAA7", "SAA8", "SAA11", "SAA14", "SAA16", "SAA17", "SAA19", "SAA20", "SAA21", "SAA22", "SAA24", "SAA27", "SAA30"])
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vinnitsa = City(name: "Вінниця", tram: vinnitsaTram, trolleybus: vinnitsaTrolleybus, autobus: vinnitsaAutobus)
        lviv = City(name: "Львів", tram: lvivTram, trolleybus: lvivTrolleybus, autobus: lvivAutobus)
        zhytomyr = City(name: "Житомир", tram: zhytomyrTram, trolleybus: zhytomyrTrolleybus, autobus: zhytomyrAutobus)
        ivanoFrankivsk = City(name: "Івано-Франківськ", tram: ivanoFrankivskTram, trolleybus: ivanoFrankivskTrolleybus, autobus: ivanoFrankivskAutobus)
        cities = Array(arrayLiteral: vinnitsa!, lviv!, zhytomyr!, ivanoFrankivsk!)

        //transportTypeView.backgroundColor = UIColor.clear
        
        //blurView.isHidden = true
        paymentView.isHidden = true
        routesView.isHidden = true
        informationView.scrollView.layer.cornerRadius = 10
        informationView.scrollView.layer.borderWidth = 1
        informationView.scrollView.layer.borderColor = UIColor.gray.cgColor
        transportTypeView.delegate = self
        buttonsModel.delegate = self
        paymentView.delegate = self
        cityDropDownView.delegate = self
        loadUserDefaults()
        updateCityDropDown()
        dropDownMenuOfcitysIsHidden = true
        updateDropDownMenuOfCyties()
        
        //city = defaults.object(forKey: "CityChoosen") as? City ?? vinnitsa
        
        updateInformationView()
        
        
        
     
        
        
        
        

       

        
        
//        if traitCollection.userInterfaceStyle == .dark {
//            routesView.backgroundColor = UIColor.systemBackground
//        } else {
//            routesView.backgroundColor = UIColor.systemBackground
//        }
//        routesView.backgroundColor = UIColor.systemBackground
        routesView.layer.cornerRadius = 10
        paymentView.layer.cornerRadius = 10
        informationView.layer.cornerRadius = 10
        traitCollectionDidChange(UIScreen.main.traitCollection)
        
        for button in transportTypeView.transportTypeButtons {
            button.layer.cornerRadius = 10
        }
        

        

        // Do any additional setup after loading the view.
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        clearButtonsAndStack()
        transportTypeView.unblur()
        if !informationView.isHidden || dropDownMenuOfcitysIsHidden == false {
            UIView.animate(withDuration: 0.0, animations: {
            }) { (_) in
               self.transportTypeView.blur(2.0)
            }
        }
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            widthOfVerticalStack = 3
            if let transport = transport {
            updateRouteStackView(transport: transport, widthOfVerticalStack: widthOfVerticalStack)
                UIView.animate(withDuration: 0.0, animations: {
                }) { (_) in
                    self.transportTypeView.blur(2.0)
                }
            }
        } else {
            widthOfVerticalStack = 4
            if let transport = transport {
                updateRouteStackView(transport: transport, widthOfVerticalStack: widthOfVerticalStack)
                UIView.animate(withDuration: 0.0, animations: {
                }) { (_) in
                    self.transportTypeView.blur(2.0)
                }
        }
        }


        
    }
    func updateRouteView(sender: UIButton ){
        
        switch  sender.titleLabel?.text {
        case "Тб":
            
            transport = city?.trolleybus
            mainBackButton.isHidden = false
            transportTypeView.blur(2.0)
            cityDropDownView.blur(2.0)
            updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
            routesView.isHidden = false
            animateRouteViewApper(sender: sender)
            

            
        case "Тм":
            transport = city?.tram
            mainBackButton.isHidden = false
            cityDropDownView.blur(2.0)
            transportTypeView.blur(2.0)
            updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
            routesView.isHidden = false
            animateRouteViewApper(sender: sender)

        case "Аб":
            transport = city?.autobus
            mainBackButton.isHidden = false
            transportTypeView.blur(2.0)
            cityDropDownView.blur(2.0)
            updateRouteStackView(transport: transport!, widthOfVerticalStack: widthOfVerticalStack)
            routesView.isHidden = false
            animateRouteViewApper(sender: sender)
        default:
            break
        }
    }
    func delegateWithTransportType(sender: UIButton) {
        //let routeNumber = (sender.titleLabel?.text)!
        updateRouteView(sender: sender)
    }
    func animateRouteViewApper(sender: UIButton){
        UIView.animate(withDuration: 0.0, animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0.0, animations: {

                let globalFrameSender = sender.convert(sender.frame, to: self.view)
                self.routesView.transform = CGAffineTransform(scaleX: sender.frame.size.width/self.routesView.frame.size.width, y: sender.frame.size.height/self.routesView.frame.size.height)
                self.routesView.frame.origin.y = globalFrameSender.origin.y
                self.routesView.frame.origin.x = globalFrameSender.origin.x
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    self.routesView.transform = .identity
                    self.routesView.center = self.view.center
                }, completion: nil)
                
            })
        }
        )
    }
    func butonTapped(sender: UIButton) {
        guard let transport = transport else {print("there is no transport"); return}
        route = sender.titleLabel?.text
        paymentView.updateUI(transport: transport, route: route)
        routesView.isHidden = true
        shadowForView(shadowView: paymentView)
        paymentView.isHidden = false
        


    }
//    func makePayment(textMsg: String){
//        let sms = textMsg
//        let activityController = UIActivityViewController(activityItems: [sms], applicationActivities: nil)
//        present(activityController, animated: true, completion: nil)
//    }
    func sendSms(textMsg: String, quantity: Int) {
        //makePayment(textMsg: textMsg)
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        } else {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            // Configure the fields of the interface.
            composeVC.recipients = ["827"]
            composeVC.body = textMsg
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    func updateRouteStackView(transport: TransportModel, widthOfVerticalStack: Int){
        if routesView.vertikalStack.subviews.count == 0 {
            buttonsModel.arrangedButtons(routes: transport.routeNumbers, numberOfHorizontalCells: widthOfVerticalStack)
        routesView.transportName.text = transport.transportType
            for array in buttonsModel.arrayOfButtons {
            // horizontal Array
                    let horizontalStackView = UIStackView(arrangedSubviews: array)
                        routesView.vertikalStack.addArrangedSubview(horizontalStackView)
                        horizontalStackView.axis = NSLayoutConstraint.Axis.horizontal
                        horizontalStackView.alignment = UIStackView.Alignment.center
                horizontalStackView.distribution = UIStackView.Distribution.equalCentering
                        horizontalStackView.spacing = 20
                
            }
        }

    }
    func clearButtonsAndStack(){
        buttonsModel.arrayOfButtons.removeAll()
        for subview in routesView.vertikalStack.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }
    func shadowForView(shadowView: UIView){
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = .zero
        shadowView.layer.shadowRadius = 10
    }
    func updateInformationView(){
        if !informationView.informationCheckMark.isSelected {
            informationView.isHidden = false
            mainBackButton.isHidden = false
            UIView.animate(withDuration: 0.0, animations: {
                
            }) { _ in
                self.cityDropDownView.blur()
            }
        } else  {
            informationView.isHidden = true
            mainBackButton.isHidden = true
            backButton.isHidden = true
        }

    }

    func informationButtonTapped (){
        transportTypeView.blur()
        cityDropDownView.blur()
        informationView.isHidden = false
        mainBackButton.isHidden = false
    }
    func shareButtonTapped() {
                if let transportFare = URL(string: "https://itunes.apple.com/us/app/myapp/idxxxxxxxx?ls=1&mt=8"), !transportFare.absoluteString.isEmpty {
            let objectsToShare = [transportFare]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

            present(activityVC, animated: true, completion: nil)

        } else {
            print("the URL is not avaolable!")
        }
    }
    
    func updateDropDownMenuOfCyties(){
        if dropDownMenuOfcitysIsHidden == false {
            cityDropDownView.cityStackView.removeBackground()
            cityDropDownView.cityStackView.spacing = 10
            hideCytiesDropDownMenu(isHidden: false)
            // add opacity backGround
            cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 0.5))
            transportTypeView.blur()
            backButton.isHidden = false
        } else {
            cityDropDownView.cityStackView.removeBackground()
            cityDropDownView.cityStackView.spacing = -33
            hideCytiesDropDownMenu(isHidden: dropDownMenuOfcitysIsHidden)
            // adding nonOpacity background
            cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
            transportTypeView.unblur()
            backButton.isHidden = true
        }
    }
    func menuButtonTapped() {
        dropDownMenuOfcitysIsHidden = !dropDownMenuOfcitysIsHidden
        updateDropDownMenuOfCyties()
    }

    @objc func cityDropDownButtonTapped(sender: UIButton) {
        for city in cities {
            //var city = cities[index]
            let index = cities.firstIndex(of: city)
            if city.name == sender.titleLabel?.text {
                let cityChoosen = cities.remove(at: index!)
                cities.insert(cityChoosen, at: 0)
                //saving city choosing
                let jsonEncoder = JSONEncoder()
                if let data = try? jsonEncoder.encode(cityChoosen) {
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(data, forKey: "CityChoosen")
                }
                break
            }
        }
        clearCityStackView()
        updateCityDropDown()
        UIView.animate(withDuration: 0.0, animations: {
        }) { _ in
            self.dropDownMenuOfcitysIsHidden = true
            self.updateDropDownMenuOfCyties()
        }
        
    }
    func loadUserDefaults(){
        informationView.informationCheckMark.isSelected = defaults.object(forKey: "InformationButtoncheckMark") as? Bool ?? false
        if let decodedData = UserDefaults.standard.object(forKey: "CityChoosen") as? Data {
                    print(decodedData)
                    print(":)")
                    let jsonDecoder = JSONDecoder()
                    city = try? jsonDecoder.decode(City.self, from: decodedData)
                } else {city = vinnitsa}
        
            let index = cities.firstIndex(of: city!)
        let savedCity = cities.remove(at: index!)
        cities.insert(savedCity, at: 0)
        
    }
    func clearCityStackView(){
        cityDropDownView.citiesButtonsArray.removeAll()
        for subview in cityDropDownView.cityStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
    }

    func updateCityDropDown(){
        cityDropDownView.cities = cities
        cityDropDownView.updateCityDropDownButtons()
        cityDropDownView.updateCityDropDownMenu()
        updateDropDownMenuOfCyties()
    }
    func hideCytiesDropDownMenu(isHidden: Bool){
        for index in 1...(cityDropDownView.cityStackView.subviews.count-1) {
            cityDropDownView.cityStackView.subviews[index].isHidden = isHidden
        }
       // cityDropDownView.cityStackView.addBackground(color: UIColor(red: (0/255.0), green: (122/255.0), blue: (255/255.0), alpha: 1))
    }


}
