class YORAScanner
  def initialize(target_file, patterns)
    @target_file = target_file
    @patterns = patterns
    @matches = {}
  end

  def scan
    content = File.binread(@target_file)

    @patterns.each_with_index do |pattern, i|
      key = "$#{('a'.ord + i).chr}"
      @matches[key] = {
        pattern: pattern,
        matched: content.include?(pattern)
      }
    end

    @matches
  end
end

if __FILE__ == $0
  patterns = ["bash -i >& /dev/tcp/", "nc -e /bin/sh", "socket.socket"]
  scanner = YORAScanner.new("test/sample.txt", patterns)
  results = scanner.scan
  results.each do |key, data|
    status = data[:matched] ? "MATCH" : "NO MATCH"
    puts "#{data[:matched] ? '[+]' : '[-]'} #{key} = \"#{data[:pattern]}\"  #{status}"
  end
end
