Pod::Spec.new do |spec|
  spec.name                = "FreestarAds-Ogury-PreRelease"
  spec.version             = "1.0.0.0-beta-1"
  spec.author              = 'Freestar'
  spec.license             =  { :type => 'Apache2.0', :file => 'LICENSE' }
  spec.homepage            = 'http://www.freestar.com'
  spec.summary             = 'The Freestar Ogury adapter'
  spec.platform            = :ios, '11.0'

  spec.vendored_frameworks  = 'build/FreestarAds-Ogury.xcframework'
  spec.dependency "FreestarAds-PreRelease", "~> 5.12-beta"

  spec.source = { :git => '' }

end
