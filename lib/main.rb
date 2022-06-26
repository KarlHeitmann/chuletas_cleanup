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
    next unless diff.start_with? '+'

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

def loopFiles(listing, io)
  results = []
  listing.split("\n").each do |file|
    extension = file.split('.')[-1]
    next unless extension == 'rb'

    diffs = getDiffFile(io, file)
    # puts diffs.inspect
    result = { file => analyze(diffs) }
    results << result unless result[file].empty?
  end
  results
end

puts "Hola"

def showOffenses(results)
  results.reduce("OFFENSES:\n") { |acc, result|
    acc += result.reduce('') { |memo, (file, offenses)| 
      # offenses_string = offenses
      offenses_string = offenses.reduce("") { |memo_offense, (name, times)|
        memo_offense += "    #{name} #{times}\n"
      }
      memo += "  #{file}\n#{offenses_string}"
    }
  }
end

def run
  io = IOUtils.new
  listing = mainDiff(io)
  results = loopFiles(listing, io)
  if results.any?
    puts "=================="
    puts results.inspect
    puts "//////////////////"
    puts showOffenses(results)
    exit 1
  end
end

run if ENV['CHULETAS_CLEANUP_TEST'].nil? # HACK_ME
