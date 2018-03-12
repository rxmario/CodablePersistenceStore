
Pod::Spec.new do |s|
  s.name             = 'CodablePersistenceStore'
  s.version          = '2.0.2'
  s.summary          = 'A Disk wrapper which makes your live easier while working with the new Codable Type.'
  s.homepage         = 'https://github.com/xmari0/CodablePersistenceStore'
  s.license          = 'MIT'
  s.author           = { 'Mario Zimmermann' => 'info@mario-zmmrmnn.de' }
  s.source           = { :git => 'https://github.com/xmari0/CodablePersistenceStore.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/xmari0_iOS'
  s.ios.deployment_target = '11.0'
  s.source_files = 'CodablePersistenceStore/Classes/**/*'
  s.dependency 'Disk', '~> 0.3.3'
  s.default_subspec = 'Standard'
  
  s.subspec 'Standard' do |standard|
      standard.source_files = 'CodablePersistenceStore/Classes/**/*'
  end
  

  s.subspec 'JB' do |jb|
    jb.source_files = 'JBPersistenceStore-Protocols/Classes/*.swift'
    jb.dependency "JBPersistenceStore-Protocols", "~> 2.1.1"
    
  end
  
end
