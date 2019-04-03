class EventVenue < ApplicationRecord
  validates :name, :length => { :minimum => 20 }, :format => { :with => /\A[a-z]+\z/i }
  validates :capacity, :numericality => { :greater_than => 0, :only_integer => true }
  def last_attendance
    # Latest event hosted at this venue
    last_event = Event.where(event_venue:self).order(start_date: :desc).first
    
    # Get all the corresponding tickets
    Ticket.where(ticket_type: TicketType.where(event: last_event)).count
  end
end
