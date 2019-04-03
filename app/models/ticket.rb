class Ticket < ApplicationRecord
  belongs_to :ticket_type
  belongs_to :order
  validates :ticket_type, :presence => true
  before_validation :ticket_created_before_event

  def ticket_created_before_event
	event_date = self.ticket_type.event.start_date.to_s
	today = Date.today.to_s
	if event_date < today
		errors.add("must be created before the event date")
	end
  end
end
