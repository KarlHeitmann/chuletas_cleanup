#!/usr/bin/ruby
# frozen_string_literal: true

OFFENSES = ['ERASE_ME', 'HACK_ME', 'XXX_ME', 'binding.pry', 'puts'].freeze

# IOUtils is used to retrieve data fro IO sucprocess with only one command HACK_ME
class IOUtils
  def getCmdData(cmd)
    io = IO.popen(cmd)
    data = io.read
    io.close
    # raise 'it failed!' unless $?.exitstatus == 0
    data
  end
end

def mainDiff(io)
  cmd1 = 'git diff --cached --name-only --diff-filter=ACM'.split
  io.getCmdData(cmd1)
end

def analyze(diffs)
  offenses = {}
  offenses.default_proc = proc { 0 }
  start_diff = diffs[1].split[0] == 'new' ? 6 : 5
  diffs = diffs[start_diff..]
  diffs.each do |diff|
    OFFENSES.each do |offense|
      offenses[offense] += 1 if diff.include? offense
    end
  end
  offenses
end

def getDiffFile(io, file)
  cmd = "git diff HEAD -U0 #{file}"
  io.getCmdData(cmd).split("\n")
end

def run
  io = IOUtils.new
  listing = mainDiff(io)

  listing.split("\n").each do |file|
    extension = file.split('.')[-1]
    next unless extension == 'rb'

    diffs = getDiffFile(io, file)
    results = analyze(diffs)
    puts results
  end
  exit 1
end

run if ENV['CHULETAS_CLEANUP_TEST'].nil? # HACK_ME
