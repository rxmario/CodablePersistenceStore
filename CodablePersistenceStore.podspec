
Pod::Spec.new do |s|
  s.name             = 'CodablePersistenceStore'
  s.version          = '2.0.0'
  s.summary          = 'A Disk wrapper which makes your live easier while working with the new Codable Type.'
  s.homepage         = 'https://github.com/xmari0/CodablePersistenceStore'
  s.license          = 'MIT'
  s.author           = { 'Mario Zimmermann' => 'info@mario-zmmrmnn.de' }
  s.source           = { :git => 'https://github.com/xmari0/CodablePersistenceStore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmari0_iOS'
  s.ios.deployment_target = '11.0'
  s.source_files = 'CodablePersistenceStore/Classes/**/*'
  s.dependency 'Disk', '~> 0.3.3'
end
