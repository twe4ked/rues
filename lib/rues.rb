module Rues
  def self.store_event payload
    events[payload[:id]] << payload
  end

  def self.load_aggregate id, type
    type.new.tap do |aggregate|
      events.fetch(id, []).each do |event|
        aggregate.apply_event event
      end
    end
  end

  def self.events
    @events
  end

  def self.clear_events
    @events = Hash.new { |h, k| h[k] = [] }
  end

  clear_events
end
