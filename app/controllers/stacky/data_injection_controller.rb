# frozen_string_literal: true

class DataInjectionController < ApplicationController
  def add
    puts "TOM DEBUG::32 data injection add endpoint reached"
    puts params
  end

  def modify
    puts "TOM DEBUG::32 data injection modify endpoint reached"
    puts params
  end

  def delete
    puts "TOM DEBUG::32 data injection delete endpoint reached"
    puts params
  end
end

