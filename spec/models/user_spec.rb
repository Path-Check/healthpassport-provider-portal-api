RSpec.describe User do

  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_length_of(:email).is_at_least(4) }

  it { is_expected.to have_many :vaccination_programs }

end
