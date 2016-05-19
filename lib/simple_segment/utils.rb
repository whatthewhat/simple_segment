module SimpleSegment
  module Utils
    def self.included(klass)
      klass.extend(self)
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) { |(key, value), result|
        result[key.to_sym] = value
      }
    end
  end
end
