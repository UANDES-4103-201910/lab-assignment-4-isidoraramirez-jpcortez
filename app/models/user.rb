class User < ApplicationRecord
  has_many :orders
  validates :password, :length => { :in => 8..12 }, :format => { :with => /\A[\sa-z0-9]+\Z/i }
  #validates :password
  validates :email, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  #validates :
  def most_expensive_ticket_bought
    # Look for self's orders, then the corresponding tickets, the the corresponding ticket types
    # and finally, look up the maximum price
    TicketType.where(id: Ticket.where(order: self.orders).select("ticket_type_id")).maximum(:price)
  end

  def most_expensive_ticket_bought_between(date_start, date_end)
    # The same as the above, but pre-filter the purchases according to the dates given
    ods = self.orders.where("created_at >= ? and created_at <= ?", date_start, date_end)
    TicketType.where(id: Ticket.where(order: ods).select("ticket_type_id")).maximum(:price)
  end

  def last_event()
    # Get all the events for which the user has purchased tickets, and select the one
    # with the latest start date
    Event.where(id: TicketType.where(id: Ticket.where(order: self.orders).\
      select("ticket_type_id")).select("event_id")).order(start_date: :desc).first
  end
end

      
