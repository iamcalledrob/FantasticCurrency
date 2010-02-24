module FantasticCurrency
  
  class Helper
    include Singleton
    include ActionView::Helpers
  end
  
  class Currency
    def self.format(value, options={})
      options = {
        :currency => nil,
        :format => false,
        :extra_zeros => false,
        :delimiter => ",",
        :separator => ".",
        :free_as_text => true,
        :display_unit => true,
        :before_unit => "",
        :after_unit => " ",
        :convert_to => nil,
        :precise_input => false,
        :full_symbols => true
      }.merge(options)
      
      if options[:precise_input] == true
        value = BigDecimal.new(value.to_s) * 10**FantasticCurrency::Config.get_currency(options[:currency])[:precision]
      end
      
      if options[:convert_to] and options[:convert_to] != options[:currency]
        source_currency = FantasticCurrency::Config.get_currency(options[:currency])
        dest_currency = FantasticCurrency::Config.get_currency(options[:convert_to])
        value = value * BigDecimal.new(source_currency[:nominal_value].to_s) / BigDecimal.new(dest_currency[:nominal_value].to_s)
        value = value / 10**(source_currency[:precision] - dest_currency[:precision])
        
        active_currency = dest_currency
      else
        active_currency = FantasticCurrency::Config.get_currency(options[:currency])
      end
      
      precision_factor = 10**active_currency[:precision]

      if options[:format] == true
        if value == 0 and options[:free_as_text]
          return "free"
        end
        helper = FantasticCurrency::Helper.instance
        
        if options[:extra_zeros] == false and (value.to_i / precision_factor * precision_factor) == value.to_i
          precision = 0
        else
          precision = active_currency[:precision]
        end
        
        value_as_string = helper.number_with_precision(BigDecimal.new(value.to_s) / precision_factor,
          :precision => precision,
          :delimiter => options[:delimiter],
          :separator => options[:separator])
        
        if options[:display_unit] == true
          unit_to_display = options[:full_symbols] ? active_currency[:symbol] : active_currency[:symbol_short] || active_currency[:symbol]
          options[:before_unit] + unit_to_display + options[:after_unit] + value_as_string
        else
          value_as_string
        end
      else
        BigDecimal.new(value.to_s) / precision_factor
      end
      
    end

  end
  
  class Config
    # Some initial currencies to have fun with. Exchange rates will be inaccurate.
    @@currencies = {
      :USD => { :symbol => "$", :precision => 2, :name => "US Dollars", :nominal_value => 1 },
      :GBP => { :symbol => "£", :precision => 2, :name => "British Pounds", :nominal_value => "1.5666" },
      :CAD => { :symbol => "CA $", :precision => 2, :name => "Canadian Dollars", :nominal_value => "0.95" },
      :AUD => { :symbol => "AU $", :precision => 2, :name => "Australian Dollars", :nominal_value => "0.8886" },
      :EUR => { :symbol => "€", :precision => 2, :name => "Euro", :nominal_value => "1.3617" },
      :JPY => { :symbol => "¥", :precision => 0, :name => "Japanese Yen", :nominal_value => "0.011116" },
      :KRW => { :symbol => "₩", :precision => 0, :name => "South Korean Won", :nominal_value => "0.000869" }
    }
    def self.define_currencies currencies
      @@currencies = currencies
    end
    def self.currencies
      @@currencies
    end
    def self.get_currency currency=nil
      if currency and FantasticCurrency::Config.currencies[currency.to_sym]
        return FantasticCurrency::Config.currencies[currency.to_sym]
      else
        return { :symbol => "$", :precision => 2, :nominal_value => 1 } #default currency.
      end 
    end
  end
  
  module ActiveRecord
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    def format_currency(value, options={})
      FantasticCurrency::Currency.format(value, options)
    end

    module ClassMethods

      def currency(field_name)
    
        define_method "#{field_name.to_s}" do |*args|
          if self[field_name]
            format_currency(self[field_name], { :currency => self[:currency] }.merge(args.first || {}))
          end
        end
        
        alias_method "#{field_name.to_s}_before_type_cast", "#{field_name}"
    
        define_method "#{field_name.to_s}=" do |value|
          raise "Money doesn't float!" if value.class.name == "Float"
          
          currency = FantasticCurrency::Config.get_currency(self[:currency])
          self[field_name] = (BigDecimal.new(value.to_s) * (10**currency[:precision])).to_i
        end
        
      end
    end
  end
  
  module ActionController
    def format_currency(value, options={})
      FantasticCurrency::Currency.format(value, options)
    end
  end
  
end

ActiveRecord::Base.send(:include, FantasticCurrency::ActiveRecord)
ActionController::Base.send(:include, FantasticCurrency::ActionController)