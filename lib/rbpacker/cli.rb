# frozen_string_literal: true

require_relative "source_bundler"

module Rbpacker
  # Command-line interface for rbpacker
  class Cli
    # @param src_file [String]
    # @param dst_file [String,nil] non-nil: output to filepath, nil: output to stdout
    def perform(src_file:, dst_file:)
      content = SourceBundler.new.bundle(src_file).result

      if dst_file
        File.binwrite(dst_file, content)
        puts "#{dst_file} is created"
      else
        puts content
      end
    end
  end
end
