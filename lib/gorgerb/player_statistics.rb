require 'json'

module Gorgerb
  class PlayerStatistics
    KDR = Struct.new(:total, :alien, :marine)
    Accuracy = Struct.new(:total, :alien, :marine)
    MarineAccuracy = Struct.new(:total, :no_onos)

    attr_reader :steam_id, :kdr, :accuracy

    def self.from_hsh(data)
      kdr_data = data.fetch('kdr')
      accuracy_data = data.fetch('accuracy')

      steam_id = data.fetch 'steam_id'
      kdr = KDR.new(
        kdr_data.fetch('total'),
        kdr_data.fetch('alien'),
        kdr_data.fetch('marine')
      )
      accuracy = Accuracy.new(
        accuracy_data.fetch('total'),
        accuracy_data.fetch('alien'),
        MarineAccuracy.new(
          accuracy_data.fetch('marine').fetch('total'),
          accuracy_data.fetch('marine').fetch('no_onos'),
        )
      )

      PlayerStatistics.new(steam_id, kdr, accuracy)
    end

    def initialize(steam_id, kdr, accuracy)
      @steam_id = steam_id
      @kdr = kdr
      @accuracy = accuracy
    end
  end
end
