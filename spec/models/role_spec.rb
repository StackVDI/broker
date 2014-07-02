require 'spec_helper'

describe Role do

  it { should validate_presence_of(:machine_idletime)}
  it {should validate_numericality_of(:machine_idletime).is_greater_than_or_equal_to(0)}
  it { should validate_presence_of(:machine_lifetime)}
  it {should validate_numericality_of(:machine_lifetime).is_greater_than_or_equal_to(0)}
  it { should validate_presence_of(:concurrent_machines)}
  it {should validate_numericality_of(:concurrent_machines).is_greater_than_or_equal_to(1)}


end


