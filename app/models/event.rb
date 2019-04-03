class Event < ApplicationRecord
  belongs_to :event_venue
  has_many :ticket_types
  validates :start_date, :presence => true
  validate :later_date
  #validates  :presence => true
  validate :host_date_venue

  def later_date
    today = Date.today.to_s
    if today > self.start_date.to_s
      errors.add(:later_date, "must be after today :(")
    end
  end

  def host_date_venue
    date = self.start_date
    myvenue_id = self.event_venue_id
    all_events = Event.all
    all_events.each do |evento|
	if evento.start_date == date && evento.event_venue_id == myvenue_id
		errors.add(:host_date_venue, "the venue is already used that day")
	end
    end
  end 
	

  def self.most_tickets_sold
    # The easiest and most efficient in this case is to simply issue a single SQL query
    sql = "select event_id, count(*) as c from tickets t, ticket_types tt where t.ticket_type_id = tt.id group by tt.event_id order by c desc limit 1"
    result = ActiveRecord::Base.connection.execute(sql)
    Event.find(result[0]['event_id']) unless result.nil?
  end

  def self.highest_revenue
    # Same approach as the above
    sql = "select sum(tt.price) as s, tt.event_id from tickets t, ticket_types tt where tt.id = t.ticket_type_id group by tt.event_id order by s desc limit 1"
    result = ActiveRecord::Base.connection.execute(sql)
    Event.find(result[0]['event_id']) unless result.nil?    
  end
end
