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
      json_data = Zlib::GzipReader.new(rawdata) { |f| f.read }
    rescue Zlib::GzipFile::Error => e
      @logger.info('Gzip failure, probably not zipped', :error => e, :data => json_data)
      json_data = data
    end

    begin
      yield LogStash::Event.new(LogStash::Json.load(json_data)) if json_data
    rescue LogStash::Json::ParserError => e
      @logger.info('LogStash::Json parse failure. Falling back to plain-text', :error => e, :data => json_data)
      yield LogStash::Event.new('message' => json_data)
    end
  end # def decode

  def encode(data)
    raise NotImplementedError
  end # def encode

end # class LogStash::Codecs::JsonGz
