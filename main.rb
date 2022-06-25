#!/usr/bin/ruby

OFFENSES = ["ERASE_ME", "HACK_ME", "XXX_ME", "binding.pry", "puts"]

def mainDiff
  #cmd1 = "git diff --cached --name-only --diff-filter=ACM -z | xargs -0 ...".split(" ")
  cmd1 = "git diff --cached --name-only --diff-filter=ACM".split(" ")
  #cmd1 = "git status".split(" ")
  io = IO.popen(cmd1)
  files = io.read
  io.close
  files
end

def analyze(diffs)
  puts diffs.inspect
  offenses = []
  start_diff = if diffs[1].split(" ")[0] == "new"
                 6
               else
                 5
               end
  diffs = diffs[start_diff..]
  # Up untill now, I have only changes in variable diffs.
  diffs.each do |diff|
    OFFENSES.each do |offense|
      offenses << diff if diff.include? offense
    end
  end
  return diffs
end

def run
  listing = mainDiff
  raise "it failed!" unless $?.exitstatus == 0
  listing.split("\n").each do |file|
    puts ":::: FILE #{file}"
    extension = file.split('.')[-1]
    next unless extension == 'rb'
    cmd = "git diff HEAD -U0 #{file}"
    io = IO.popen(cmd)
    #diffs = io.read.split("\n")[4..]
    #diffs = io.read.split("\n")[5..]
    diffs = io.read.split("\n")
    io.close
    results = analyze(diffs)
    puts results
  end
  exit 1
end

run

