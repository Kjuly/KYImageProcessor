Pod::Spec.new do |spec|
  spec.name         = "KYImageProcessing"
  spec.version      = "1.1.0"
  spec.summary      = "The image processing foundation of KYPhotoPicker."
  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Kjuly/KYImageProcessing.git", :tag => spec.version.to_s }
  spec.homepage     = "https://github.com/Kjuly/KYImageProcessing"

  spec.author             = { "Kjuly" => "dev@kjuly.com" }
  spec.social_media_url   = "https://twitter.com/kJulYu"

  spec.ios.deployment_target = "15.5"
  spec.osx.deployment_target = "12.0"
  spec.watchos.deployment_target = "6.0"

  spec.swift_version = '5.0'

  spec.source_files  = "KYImageProcessing"
  spec.exclude_files = "KYImageProcessing/KYImageProcessing.docc"

  spec.requires_arc = true
end
