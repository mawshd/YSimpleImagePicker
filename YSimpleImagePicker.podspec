Pod::Spec.new do |s|

  s.name         = "YSimpleImagePicker"
  s.version      = "2.0"
  s.summary      = "it is simple image picker from camera or gallery"
  s.description  = <<-DESC
This is IOS Swift 3.3 + Library for Image picking from gallery or camera with some simple customization.
                   DESC

  s.homepage     = "https://github.com/mawshd/YSimpleImagePicker"
  s.license      = { :type => "MIT", :file => "license" }
  s.author             = { "Awais Shahid" => "m_aws_s@hotmail.com" }
  s.ios.deployment_target = '10.0'
  s.ios.vendored_frameworks = 'YSimpleImagePicker.framework'
  s.source       = { :git => "https://github.com/mawshd/YSimpleImagePicker.git", :tag => "#{s.version}" }
  s.exclude_files = "Classes/Exclude"

end
