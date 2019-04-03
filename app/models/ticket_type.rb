class TicketType < ApplicationRecord
  belongs_to :event
  belongs_to :ticket_zone
  validates :price, :numericality => { :greater_than => 0, :only_integer => true }
end
