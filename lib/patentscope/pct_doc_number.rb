module Patentscope

  class PctAppNumber < String

    def initialize(number = "")
      raise NoNumberError,
        "Patent application number was not entered" if number.nil?
      super(number.strip)
    end

    def valid?
      self.match(/\A(([Pp][Cc][Tt]\/?)?[a-zA-Z]{2}\d{4}\/?\d{6})\Z/)
    end

    def validate
      raise WrongNumberFormatError,
        "PCT application number is not in correct format (PCT/CCYYYY/NNNNNN)" unless valid?
    end

    def to_ia_number
      self.upcase!
      self.gsub!('/', '')
      self.gsub!('PCT', '')
      self
    end
  end

  class PctPubNumber < String

    def initialize(number = "")
      raise NoNumberError,
        "Patent publication number was not entered" if number.nil?
      super(number.strip)
    end

    def valid?
      self.match(/\A(([Ww][Oo]\/?)?\s?\d{4}\/?\s?\d{6})\Z/)
    end

    def validate
      raise WrongNumberFormatError,
        "PCT publication number is not in correct format (WO/YYYY/NNNNNN)" unless valid?
    end
  end
end
