import UIKit

@IBDesignable
class TextFieldHelper: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.white {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let paddingView = UIView(frame: CGRect(x: 0 ,y: 0,width: 45 ,height: 30))
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = UIColor.lightGray.withAlphaComponent(0.5)
            paddingView.addSubview(imageView)
            paddingView.backgroundColor = UIColor.clear
            leftView = paddingView
            
            //mailTF.leftView = paddingView
            //mailTF.leftViewMode = UITextFieldViewMode.always
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: color])
    }
}
