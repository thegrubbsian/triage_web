class Device < ActiveRecord::Base

  module OSTypes
    IOS = "ios"
    ANDROID = "android"
  end

  belongs_to :user

  validates_inclusion_of :os_type, in: OSTypes.constant_values

end
