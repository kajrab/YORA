# bin/yora.rb
require_relative '../lib/parser'
require_relative '../lib/scanner'
require_relative '../lib/reporter'

if ARGV.length != 2
  puts "Usage: ruby bin/yora.rb <rule_file> <target_file>"
  puts "Example: ruby bin/yora.rb rules/default.yora test/sample.txt"
  exit 1
end

rule_file   = ARGV[0]
target_file = ARGV[1]
output_path = ARGV[2]

parser = YORAParser.new(rule_file)
rule = parser.parse
parser.save_cache

scanner = YORAScanner.new(target_file, rule[:patterns])
matches = scanner.scan

reporter = YORAReporter.new(rule, matches, target_file)
reporter.generate
