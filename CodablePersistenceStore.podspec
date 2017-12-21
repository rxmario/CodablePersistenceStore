
Pod::Spec.new do |s|
  s.name             = 'CodablePersistenceStore'
  s.version          = '1.0.1.alpha'
  s.summary          = 'A Disk wrapper which makes your live easier while working with Codable structs.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/Mario Zimmermann/CodablePersistenceStore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mario Zimmermann' => 'info@mario-zmmrmnn.de' }
  s.source           = { :git => 'https://github.com/Mario Zimmermann/CodablePersistenceStore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://www.instagram.com/xmari0_ios/'

  s.ios.deployment_target = '11.0'

  s.source_files = 'CodablePersistenceStore/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CodablePersistenceStore' => ['CodablePersistenceStore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
    s.dependency 'Disk', '~> 0.3.3'
end
