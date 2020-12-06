# frozen_string_literal: true

module Ewa
  module Representer
    # OpenStruct for getting only restaurant infos with id & name
    class OpenStructWithIdName < OpenStruct
      attr_accessor :id, :name
    end
  end
end
