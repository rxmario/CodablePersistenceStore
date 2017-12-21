
Pod::Spec.new do |s|
  s.name             = 'CodablePersistenceStore'
  s.version          = '1.0.1.alpha'
  s.summary          = 'A Disk wrapper which makes your live easier while working with Codable Structs.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                A Disk wrapper which makes your live easier while working with the new Codable Structs.
                Persist your data directly on the user's device.
                It's simple.
                       DESC

  s.homepage         = 'https://github.com/xmari0/CodablePersistenceStore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mario Zimmermann' => 'info@mario-zmmrmnn.de' }
  s.source           = { :git => 'https://github.com/xmari0/CodablePersistenceStore.git', :tag => s.version.to_s }
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
