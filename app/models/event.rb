class Event < ApplicationRecord
  belongs_to :event_venue
  has_many :ticket_types
  

  validates :start_date, :presence => true
  validate :end_date

  def end_date
    end_date = Date.today.to_s
    if end_date > self.start_date.to_s
      errors.add(:end_date, "must be after the start date")
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
