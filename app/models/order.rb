class Order < ApplicationRecord
  belongs_to :user
  has_many :tickets
  validates :ticket, :presence => true
  before_validation :order_created_before_buying

  def order_created_before_buying
	event_date = self.ticket.ticket_type.event.start_date.to_s
	today = Date.today.to_s
	if event_date < today
		errors.add("must buy before the event date")
	end
  end
end
end
