# encoding: utf-8
require 'logstash/codecs/base'

class LogStash::Codecs::JsonGz < LogStash::Codecs::Base
  config_name 'json_gz'
  milestone 1

  public
  def register
    require 'zlib'
    require 'stringio'
  end # def register

  def decode(data)
    begin
      json_data = Zlib::GzipReader.new(StringIO.new(data)) { |f| f.read }
    rescue Zlib::GzipFile::Error => e
      @logger.info('Gzip failure, probably not zipped', :error => e, :data => json_data)
      json_data = data
    end

    begin
      yield LogStash::Event.new(JSON.parse(json_data)) if json_data
    rescue JSON::ParserError => e
      @logger.info('JSON parse failure. Falling back to plain-text', :error => e, :data => json_data)
      yield LogStash::Event.new('message' => json_data)
    end
  end # def decode

  def encode(data)
    raise NotImplementedError
  end # def encode

end # class LogStash::Codecs::JsonGz
