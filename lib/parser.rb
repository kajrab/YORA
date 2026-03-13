require 'json'

class YORAParser
  def initialize(rule_file)
    @rule_file = rule_file
    @rule_name = File.basename(rule_file, ".yora")
    @rule = {
      meta: {},
      patterns: [],
      condition: nil
    }
  end

  def parse
    current_block = nil

    File.foreach(@rule_file) do |line|
      line.strip!
      next if line.empty? || line == "{" || line == "}"
      next if line.start_with?("rule ")

      if line == "meta:"
        current_block = :meta
      elsif line == "patterns:"
        current_block = :patterns
      elsif line == "condition:"
        current_block = :condition
      else
        case current_block
        when :meta      then parse_meta(line)
        when :patterns  then parse_pattern(line)
        when :condition then parse_condition(line)
        end
      end
    end

    @rule
  end

  def save_cache
    cache_path = "cache/#{@rule_name}.json"
    File.write(cache_path, JSON.pretty_generate(@rule))
    puts "Cache written to: #{cache_path}"
  end

  private

  def parse_meta(line)
    key, value = line.split("=", 2).map(&:strip)
    value = value.gsub(/\A"|"\z/, '')
    @rule[:meta][key.to_sym] = value
  end

  def parse_pattern(line)
    return unless line.include?("$")
    value = line.split("=", 2).last.strip.gsub(/\A"|"\z/, '')
    @rule[:patterns] << value
  end

  def parse_condition(line)
    if line.include?("all")
      @rule[:condition] = "ALL"
    elsif line.include?("any")
      @rule[:condition] = "ANY"
    elsif line.match?(/\d+\s+of/)
      n = line.match(/(\d+)/)[1].to_i
      @rule[:condition] = "N_OF_#{n}"
    end
  end
end

if __FILE__ == $0
  parser = YORAParser.new("rules/default.yora")
  parser.parse
  parser.save_cache
end
