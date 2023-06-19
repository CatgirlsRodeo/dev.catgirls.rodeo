#!/bin/ruby
require 'fileutils'
require "rexml/document"

path = ARGV[0]

class CodeModule
  attr_accessor :title, :color, :files, :code

  def initialize(title:, files:, color:)
    self.title = title
    self.color = color
    self.files = files
    self.code = ''
  end
end

code_modules = [
  CodeModule.new(title: 'Core', files: ['rodeo_8h.xml', 'common_8h.xml'], color: 'zinc'),
  CodeModule.new(title: 'Window', files: ['window_8h.xml'], color: 'stone'),
  CodeModule.new(title: 'Gfx', files: ['gfx_8h.xml'], color: 'purple'),
  CodeModule.new(title: 'Audio', files: ['audio_8h.xml'], color: 'blue'),
  CodeModule.new(title: 'Input', files: ['input_8h.xml'], color: 'red'),
  CodeModule.new(title: 'Log', files: ['log_8h.xml'], color: 'yellow'),
  CodeModule.new(title: 'Collision', files: ['collision_8h.xml'], color: 'green'),
  CodeModule.new(title: 'Math', files: ['math_8h.xml', 'rng_8h.xml', 'mat4_8h.xml', 'vec2_8h.xml', 'vec3_8h.xml'], color: 'sky'),
]
code_modules.each_with_index do |mod, index|
  mod.files.each do |file|
    file = File.new("#{path}/doxygen/xml/#{file}")
    doc = REXML::Document.new file
    root = doc.root

    defines = root.get_elements('//sectiondef').filter { |attr| attr.attributes['kind'] == "func" }

    defines.each do |func|
      func.get_elements('//definition').each_with_index do |defi, i|
        mod.code += "#{defi.text}#{func.get_elements('//argsstring')[i].text};\n"
      end
    end
  end
  FileUtils.mkdir_p "docs"
  File.write("./docs/#{index}#{mod.title.downcase}.html",
             "---
title: #{mod.title}
id: #{mod.title.downcase}
color: #{mod.color}
---
{% highlight c %}
#{mod.code}
{% endhighlight %}
")
end
