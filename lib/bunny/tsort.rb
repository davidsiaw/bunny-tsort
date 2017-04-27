require "bunny/tsort/version"

module Bunny
  module Tsort

    class CyclicGraphException < Exception
    end

    def self.tsort(dephash)

      newhash = {}

      # add implicit jobs as start jobs
      dephash.each do |k,v|
        newhash[k] = v.clone
        v.each {|x| newhash[x] = [] if !dephash.has_key?(x) }
      end

      lists = []

      loop do
        break if newhash.keys.length == 0

        doables = newhash.select { |k,v| v.length == 0 }.map{|k,v| k}
        if doables.length == 0
          raise CyclicGraphException
        else
          lists << doables
          doables.each { |x| newhash.delete(x) }
          newhash.each { |k,v| newhash[k] = v - doables }
        end
      end

      lists

    end
  end
end
