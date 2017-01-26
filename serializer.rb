class FileSerializer
  def self.load(filename)
    if File.exist?(filename)
      File.open(filename, 'r:UTF-8', &:read)
    else
      '{"days":[]}'
    end
  end

  def self.save(json, filename)
    File.open(filename, 'w:UTF-8') do |file|
      file.write(json)
    end
  end
end
