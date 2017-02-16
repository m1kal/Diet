require 'redis'

# MemSerializer
class MemSerializer
  @@values = {}

  def self.save(json, key)
    @@values[key] = json
  end

  def self.load(key)
    @@values[key]
  end
end
