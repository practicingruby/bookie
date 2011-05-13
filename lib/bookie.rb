require "date"
require "fileutils"
require "tempfile"
require "erb"
require "strscan"

require "prawn"
require "eeepub"

require_relative "bookie/version"
require_relative "bookie/parser"
require_relative "bookie/emitters"
require_relative "bookie/book"

module Bookie
  TEMPLATES_DIR = File.expand_path("#{File.dirname(__FILE__)}/../data/templates/")
end
