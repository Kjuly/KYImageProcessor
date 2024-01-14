Pod::Spec.new do |spec|
  spec.name         = "KYImageProcessor"
  spec.version      = "2.2.0"
  spec.summary      = "The image processing foundation of KYPhotoPicker."
  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Kjuly/KYImageProcessor.git", :tag => spec.version.to_s }
  spec.homepage     = "https://github.com/Kjuly/KYImageProcessor"

  spec.author             = { "Kjuly" => "dev@kjuly.com" }
  spec.social_media_url   = "https://twitter.com/kJulYu"

  spec.ios.deployment_target = "15.5"
  spec.osx.deployment_target = "12.0"
  spec.watchos.deployment_target = "6.0"

  spec.swift_version = '5.0'

  spec.source_files  = "KYImageProcessor"
  spec.exclude_files = "KYImageProcessor/KYImageProcessor.docc"

  spec.requires_arc = true
end
