class Task < ActiveRecord::Base

  STATES = ["now", "later", "done", "archived"]

  belongs_to :user

  validates_inclusion_of :state, in: STATES

  scope :in_order, -> { order("order_index DESC") }

  before_validation :set_default_state
  before_create :set_order_index

  def set_order_index
    self.order_index ||= ((user.tasks.maximum(:order_index) || 0) + 1)
  end

  def set_default_state
    self.state ||= "now"
  end

end
