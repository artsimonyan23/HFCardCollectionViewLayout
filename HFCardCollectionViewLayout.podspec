Pod::Spec.new do |s|
  s.name         = 'HFCardCollectionViewLayout'
  s.version      = '1.0.0'
  s.summary      = 'The HFCardCollectionViewLayout provides a card stack layout not quite similar like the apps Reminder and Wallet.'
  s.license	 = 'MIT'
  s.homepage     = 'https://github.com/hfrahmann/HFCardCollectionViewLayout'
  s.ios.deployment_target = '9.0'
  s.author = {
    'Hendrik Frahmann' => 'contact@hendrik-frahmann.de'
  }
  s.source = {
    :git => 'https://github.com/hfrahmann/HFCardCollectionViewLayout.git',
    :tag => '1.0.0'
  }
  s.source_files = 'Source/*'
end
