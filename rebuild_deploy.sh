git pull
gem build logstash-codec-json_gz.gemspec
sudo /usr/share/logstash/bin/logstash-plugin install logstash-codec-json_gz-0.1.5.gem
sudo service logstash restart

