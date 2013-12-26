require 'spec_helper'

describe Image do
    it { should belong_to(:cloud_server) }
    it { should have_and_belong_to_many(:roles)}

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:cloud_server) }
    it { should validate_presence_of(:machine) }
    it { should validate_presence_of(:flavor) }
    it { should validate_presence_of(:number_of_instances) }
    it { should validate_numericality_of(:number_of_instances).only_integer.is_greater_than(0) }


end
