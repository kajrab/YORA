require 'fileutils'

class YORAReporter
  def initialize(rule, matches, target_file)
    @rule = rule
    @matches = matches
    @target_file = target_file
    @output_path = "reports/#{File.basename(target_file, ".*")}_report.txt"
    FileUtils.mkdir_p("reports")
  end

  def generate
    result = evaluate_condition

    report = <<~REPORT
      YORA SCAN REPORT
      ================
      Description : #{@rule[:meta][:description]}
      Author      : #{@rule[:meta][:author]}
      Severity    : #{@rule[:meta][:severity]}
      Target      : #{@target_file}
      Scanned at  : #{Time.now.strftime("%Y-%m-%d %H:%M:%S")}

      Patterns:
      #{pattern_lines}

      Condition : #{@rule[:condition]}
      Result    : #{result ? 'MATCH DETECTED' : 'CLEAN'}
    REPORT

    File.write(@output_path, report)
    puts report
    puts "Report saved to: #{@output_path}"
  end

  private

  def pattern_lines
    @matches.map do |key, data|
      "  #{data[:matched] ? '[+]' : '[-]'} #{key} = \"#{data[:pattern]}\"  #{data[:matched] ? 'MATCH' : 'NO MATCH'}"
    end.join("\n")
  end

  def evaluate_condition
    matched_count = @matches.count { |_, data| data[:matched] }

    case @rule[:condition]
    when "ALL"
      matched_count == @matches.size
    when "ANY"
      matched_count > 0
    when /N_OF_(\d+)/
      matched_count >= $1.to_i
    end
  end
end
