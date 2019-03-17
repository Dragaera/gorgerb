require 'json'

module Gorgerb
  class PlayerStatistics
    KDR = Struct.new(:alien, :marine)
    Accuracy = Struct.new(:alien, :marine)
    MarineAccuracy = Struct.new(:total, :no_onos)
    Meta = Struct.new(:sample_size)
    StatisticsPoint = Struct.new(:meta, :kdr, :accuracy)

    attr_reader :steam_id

    def self.from_hsh(data)
      stats_points = {}

      steam_id = data.fetch('_').fetch('steam_id')
      # Prevent it being treated as a stats point further below.
      data.delete('_')

      data.each do |stats_class, class_data|
        kdr_data = class_data.fetch('kdr')
        accuracy_data = class_data.fetch('accuracy')
        meta_data = class_data.fetch('_')

        kdr = KDR.new(
          kdr_data.fetch('alien'),
          kdr_data.fetch('marine')
        )

        accuracy = Accuracy.new(
          accuracy_data.fetch('alien'),
          MarineAccuracy.new(
            accuracy_data.fetch('marine').fetch('total'),
            accuracy_data.fetch('marine').fetch('no_onos'),
          )
        )

        meta = Meta.new(
          meta_data.fetch('sample_size')
        )

        stats_points[stats_class] = StatisticsPoint.new(
          meta,
          kdr,
          accuracy
        )
      end

      PlayerStatistics.new(steam_id, stats_points)
    end

    def initialize(steam_id, statistics_points)
      @steam_id = steam_id
      @statistics_points = statistics_points
    end

    def method_missing(m, *args, &block)
      stats_class = m.to_s

      if @statistics_points.key? stats_class
        @statistics_points[stats_class]
      else
        super(m, *args, &block)
      end
    end
  end
end
