# frozen_string_literal: true

module SimpleSegment
  module Utils
    def self.included(klass)
      klass.extend(self)
    end

    def symbolize_keys(hash)
      hash.each_with_object({}) do |(key, value), result|
        result[key.to_sym] = value
      end
    end

    # public: Converts all the date values in the into iso8601 strings in place
    #
    def isoify_dates!(hash)
      hash.replace isoify_dates hash
    end

    # public: Returns a new hash with all the date values in the into iso8601
    #         strings
    #
    def isoify_dates(hash)
      hash.each_with_object({}) do |(k, v), memo|
        memo[k] = maybe_datetime_in_iso8601(v)
      end
    end

    def maybe_datetime_in_iso8601(prop)
      case prop
      when Time
        prop.iso8601(3)
      when DateTime
        prop.to_time.iso8601(3)
      when Date
        prop.strftime('%F')
      else
        prop
      end
    end
  end
end
