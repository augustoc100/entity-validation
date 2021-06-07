class Entity
  attr_reader :validations
  @@validations = {}
  def self.validate(attr, validation)
    @@validations[attr.to_sym] ||= []
    @@validations[attr.to_sym] << validation
  end

  attr_reader :errors
  def initialize(attributes)
    @errors = []
    @attributes = attributes
    run_validations
    create_methods(attributes)
  end

  def valid?
    @errors.empty?
  end

  private

  def create_methods(attributes)
    attributes.each do |key, value|
      self.class.instance_eval { attr_accessor key}
      instance_variable_set("@#{key}", value)
    end
  end

  def run_validations
    @@validations.each do |key, validation|
      validate(key, validation) if has_validation?(key)
    end

    @@validations = {}
  end


  def validate(key, validation)
    value = @attributes[key]
    error_message = 'validation not found' if validation.nil?
    validation
      .map { |v| v.call(value) }
      .each do |error_message, valid|
      add_error(key, error_message) if !valid
    end
  end

  def has_validation?(attr)
    !@@validations[attr.to_sym].nil?
  end

  def add_error(attr, error_message)
    @errors << {attr.to_sym => error_message }
  end
end

