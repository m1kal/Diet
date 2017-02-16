# FileSerializer
class FileSerializer
  def self.load(filename)
    File.exist?(filename) ? File.open(filename, 'r:UTF-8', &:read) : nil
  end

  def self.save(json, filename)
    File.open(filename, 'w:UTF-8') do |file|
      file.write(json)
    end
  end
end
