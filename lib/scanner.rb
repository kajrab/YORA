require 'ffi'

module NativeScanner
  extend FFI::Library
  ffi_lib File.join(__dir__, '../native/scanner.so')
  attach_function :scan_file, [:string, :pointer, :int], :int
end

class YORAScanner
  def initialize(target_file, patterns)
    @target_file = target_file
    @patterns = patterns
    @matches = {}
  end

  def scan
    ptrs = @patterns.map { |p| FFI::MemoryPointer.from_string(p) }
    ptr_array = FFI::MemoryPointer.new(:pointer, ptrs.size)
    ptr_array.write_array_of_pointer(ptrs)

    result = NativeScanner.scan_file(@target_file, ptr_array, @patterns.size)

    @patterns.each_with_index do |pattern, i|
      key = "$#{('a'.ord + i).chr}"
      @matches[key] = {
        pattern: pattern,
        matched: (result & (1 << i)) != 0
      }
    end

    @matches
  end
end
