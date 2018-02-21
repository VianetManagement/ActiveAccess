# frozen_string_literal: true

module ActiveAccess
  class Config < Hash
    ALLOWED_SUFFIXES = %w[? =].freeze

    # @OVERRIDE
    # Ensure all key checks are in string format
    def key?(key)
      super(key.to_s)
    end

    # @OVERRIDE
    # Check to see if missing method should call the `method_missing/3` method
    def respond_to_missing?(method_name, *args)
      return true if key?(method_name)
      super
    end

    # @OVERRIDE
    # Will try to resolve the called method to a stored hash KV pair
    #
    # Example
    # config = ActiveAccess::Config.new
    # config.day?           #=> false
    # config.day = "Monday" #=> {"day" => "Monday"}
    # config.day?           #=> true
    # config.day            #=> "Monday"
    def method_missing(method_name, *args, &blk)
      return self.[](method_name.to_s, &blk) if key?(method_name)
      name, suffix = method_name_and_suffix(method_name)
      case suffix
      when "="
        self[name.to_s] = args.first
      when "?"
        !!self[name.to_s] # rubocop:disable Style/DoubleNegation
      when nil
        self[method_name.to_s]
      else
        super
      end
    end

    # Convert all keys to proper form. This will not work with deep merging!
    #
    # Example:
    # config = ActiveAccess::Config.new #=> { "enabled" => true, ... }
    # config.merge(tip: 2.00, flip: 1)  #=> { "enabled" => true, "tip" => 2.00, "flip" => 1, ... }
    def update!(**hash)
      hash.each_pair { |key, value| self[key.to_s] = value }
      self
    end
    alias merge! update!
    alias merge update!

    # @OVERRIDE
    def initialize(*)
      super
      self.enabled = true if enabled.nil?
      self.message = "Resource Not Found" if message.nil?
    end

    protected

    def method_name_and_suffix(method_name)
      method_name = method_name.to_s
      if method_name.end_with?(*ALLOWED_SUFFIXES)
        [method_name[0..-2], method_name[-1]]
      else
        [method_name[0..-1], nil]
      end
    end
  end
end
