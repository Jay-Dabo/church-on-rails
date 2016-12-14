require "rails_helper"

RSpec.describe "Families" do
  it_behaves_like "an authenticated feature", "/families"
  it_behaves_like "an authorized feature", "/families"

  context 'with access' do
    let(:user)  { create(:user, :person) }
    before { login_as user }

    context 'with read permissions' do
      before do
        user.person.join create(:team, people_reader: true)
      end

      it 'can browse families' do
        family1 = create(:family, name: 'Smith')
        family2 = create(:family, name: 'Johnson')
        members = create_list(:person, 3)
        members.each{|member| member.join family1 }

        visit '/families'
        expect(page).to have_content family1.name
        expect(page).to have_content family2.name

        fill_in 'q', with: 'Smith'
        click_on 'Search'
        expect(page).to have_no_content family2.name
        expect(page).to have_content family1.name

        click_on family1.name
        expect(page).to have_content 'Smith Family'

        # members
        members.each do |member|
          expect(page).to have_content member.name
        end

        # no edit or destroy
        expect(page).to have_no_selector '.list-group-item form.button_to .btn-link'
        expect(page).to have_no_content 'Edit'
        expect(page).to have_no_content 'Add member'
      end
    end

    context 'with write permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true)
      end

      it 'can edit families' do
        family = create(:family, name: 'Smith')

        visit "/families/#{family.id}"
        click_on "Edit"

        fill_in 'Name', with: 'Johnson'
        fill_in 'Address', with: '1 The Street'
        fill_in 'Town', with: 'The Neighbourhood'
        fill_in 'Post code', with: 'AB1 2CD'
        fill_in 'Country', with: 'United Kingdom'
        click_on "Save changes"
        expect(page).to have_content 'Johnson Family'
        expect(page).to have_content '1 The Street, The Neighbourhood, AB1 2CD, United Kingdom'

        new_person = create(:person)
        click_on "Add member"

        within '.side-and-details--details' do
          expect(page).to have_content 'Add to Family'
          select new_person.name, from: 'family_membership[person_id]'
          click_on 'Add member'
        end

        expect(page).to have_no_content 'Add to Family'
        expect(page).to have_content new_person.name
        expect(family.reload.people).to include new_person

        # no destroy
        expect(page).to have_no_selector '.list-group-item form.button_to .btn-link'
      end
    end

    context 'with manage permissions' do
      before do
        user.person.join create(:team, people_reader: true, people_editor: true, people_admin: true)
      end

      it 'can remove people from families' do
        family = create(:family, name: 'Smith')
        member = create(:person)
        member.join family

        visit "/families/#{family.id}"
        find(:css, '.list-group-item form.button_to .btn-link').click

        expect(page).to have_no_content member.name
        expect(family.reload.people).not_to include member
      end

      it 'can destroy families' do
        family = create(:family)

        visit "/families/#{family.id}"
        click_on 'Remove'
        click_on 'Yes, do it.'

        expect(page).to have_content "#{family} has been removed"
        visit '/families'
        expect(page).to have_no_content family.name
      end
    end
  end

end
