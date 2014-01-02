require 'spec_helper'

describe Machine do
  it { should belong_to :user } 
  it { should belong_to :image }

  it { should validate_presence_of :remote_username }
  it { should validate_presence_of :remote_password }

end
