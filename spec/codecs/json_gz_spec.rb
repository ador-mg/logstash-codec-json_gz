# encoding: utf-8
require_relative '../spec_helper'
require "logstash/codecs/json_gz"
require "logstash/errors"
require "stringio"

def compress_with_gzip(io)
  compressed = StringIO.new('', 'r+b')

  gzip = Zlib::GzipWriter.new(compressed)
  gzip.write(io.read)
  gzip.finish

  compressed.rewind

  compressed
end

describe LogStash::Codecs::JsonGz do
  let!(:uncompressed_log) do
    # Using format from
    # http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
    str = StringIO.new

    str << "{ 'name': 'foo', 'type': 'bar' }"

    str.rewind
    str
  end

  describe "#decode" do
    it "should create events from a gzip file" do
      events = []

      subject.decode(compress_with_gzip(uncompressed_log)) do |event|
        events << event
      end

      expect(events.size).to eq(2)
    end
  end
end
