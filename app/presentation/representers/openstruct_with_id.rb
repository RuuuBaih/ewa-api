# frozen_string_literal: true

module Ewa
  module Representer
    # OpenStruct for getting only restaurant infos with id & name
    class OpenStructWithId < OpenStruct
      attr_accessor :id
    end
  end
end
