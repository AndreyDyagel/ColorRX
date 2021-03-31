//
//  ViewController.swift
//  ColorRX
//
//  Created by Андрей on 16.03.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var colorOutlet: UIView!
    @IBOutlet weak var mixColorOutlet: UIView!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    
    @IBOutlet weak var redSliderOutlet: UISlider!
    @IBOutlet weak var greenSliderOutlet: UISlider!
    @IBOutlet weak var blueSliderOutlet: UISlider!
    
    @IBOutlet weak var redLabelOutlet: UILabel!
    @IBOutlet weak var greenLabelOutlet: UILabel!
    @IBOutlet weak var blueLabelOutlet: UILabel!
    
    var viewColorGesture: UIView = UIView()
    let width: CGFloat = 40
    let height:CGFloat = 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorOutlet.layer.cornerRadius = 10
        mixColorOutlet.layer.cornerRadius = mixColorOutlet.frame.height / 2
        imageViewOutlet.layer.cornerRadius = imageViewOutlet.frame.height / 2
        imageViewOutlet.layer.borderWidth = CGFloat(5)
        imageViewOutlet.layer.borderColor = CGColor(red: 100, green: 100, blue: 100, alpha: 1)

        action()
        ciColor()
        valueColor()
    }
    
    private func valueColor() {
        redLabelOutlet.text = String(format: "%.2f", CGFloat(redSliderOutlet.value))
        greenLabelOutlet.text = String(format: "%.2f", CGFloat(greenSliderOutlet.value))
        blueLabelOutlet.text = String(format: "%.2f", CGFloat(blueSliderOutlet.value))
    }
    
    private func rgbColor() {
        colorOutlet.backgroundColor = UIColor(red: CGFloat(redSliderOutlet.value),
                                              green: CGFloat(greenSliderOutlet.value),
                                              blue: CGFloat(blueSliderOutlet.value),
                                              alpha: 1)
    }
    
    private func ciColor() {
        let ciColor = CIColor(color: colorOutlet.backgroundColor ?? .white)
        
        redSliderOutlet.value = Float(ciColor.red)
        greenSliderOutlet.value = Float(ciColor.green)
        blueSliderOutlet.value = Float(ciColor.blue)
    }
    
    @IBAction func sliderActions(_ sender: UISlider) {
        rgbColor()
        valueColor()
    }
    
    func action() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        
        viewColorGesture = UIView(frame: CGRect(x: imageViewOutlet.center.x - (width / 2), y: imageViewOutlet.center.y - (height / 2), width: width, height: height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
        label.textColor = .white
        label.textAlignment = .center
        label.text = "⌾"
        label.font = UIFont.boldSystemFont(ofSize: 40)
        
        viewColorGesture.addGestureRecognizer(panGesture)
        viewColorGesture.addSubview(label)
        mixColorOutlet.addSubview(viewColorGesture)
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        guard let recognizerView = gesture.view else { return }
        
        if imageViewOutlet.frame.minY >= viewColorGesture.frame.minY ||
            imageViewOutlet.frame.maxY <= viewColorGesture.frame.minY ||
            imageViewOutlet.frame.minX >= viewColorGesture.frame.minX ||
            imageViewOutlet.frame.maxX <= viewColorGesture.frame.minX {
            gesture.isEnabled = false

            if imageViewOutlet.frame.minY >= viewColorGesture.frame.minY {
                viewColorGesture.frame.origin.y += 1
                gesture.isEnabled = true
            } else if imageViewOutlet.frame.minX >= viewColorGesture.frame.minX {
                viewColorGesture.frame.origin.x += 1
                gesture.isEnabled = true
            } else if imageViewOutlet.frame.maxY <= viewColorGesture.frame.minY {
                viewColorGesture.frame.origin.y -= 10
                gesture.isEnabled = true
            } else if imageViewOutlet.frame.maxX <= viewColorGesture.frame.minX {
                viewColorGesture.frame.origin.x -= 10
                gesture.isEnabled = true
            }
        } else {
            let translation = gesture.translation(in: imageViewOutlet)
            recognizerView.center.x += translation.x
            recognizerView.center.y += translation.y
            gesture.setTranslation(.zero, in: imageViewOutlet)
            colorOutlet.backgroundColor = imageViewOutlet.colorImage(recognizerView.center)
            valueColor()
            ciColor()
        }
    }
    
}
