FactoryGirl.define do
	factory :user do
		name "Sherlock Holmes"
		email "sherlock@deduction.org"
		password "foobar"
		password_confirmation "foobar"
	end
end	