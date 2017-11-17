# encoding: utf-8
require "logstash/codecs/base"
require "logstash/json"
require "logstash/event"

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
      rawdata = StringIO.new(data);
      @logger.info('LogStash::Codecs::JsonGz: got data: ', :data => rawdata)
      gz = Zlib::GzipReader.new(rawdata)
      json_data = gz.read
    rescue Zlib::GzipFile::Error => e
      @logger.info('Gzip failure, PROBABLY not zipped. Falling back to plain text...', :error => e, :data => data)
      json_data = data
    end

    begin
      @logger.info('LogStash::Codecs::JsonGz: after zipping part. ', :data => json_data)

      yield LogStash::Event.new(LogStash::Json.load(json_data)) if json_data
    rescue LogStash::Json::ParserError => e
      @logger.info('LogStash::Json parse failure. Falling back to plain-text', :error => e, :data => json_data)
      yield LogStash::Event.new(json_data)
    end
  end # def decode

  def encode(data)
    raise NotImplementedError
  end # def encode

end # class LogStash::Codecs::JsonGz
