require 'spec_helper'

describe 'curate/people/show.html.erb' do
  let(:person) { FactoryGirl.create(:person_with_user) }
  let(:user) { person.user }

  context 'A person who has a collection in their profile' do
    let(:outer_collection) { FactoryGirl.create(:collection, user: user, title: 'Outer Collection') }
    let(:inner_collection) { FactoryGirl.create(:collection, user: user, title: 'Inner Collection') }
    let(:outer_work) { FactoryGirl.create(:generic_work, user: user, title: 'Outer Work') }
    let(:inner_work) { FactoryGirl.create(:generic_work, user: user, title: 'Inner Work') }

    before do
      inner_collection.members << inner_work
      inner_collection.save!
      outer_collection.members << inner_collection
      outer_collection.save!

      person.profile.members << [outer_collection, outer_work]
      person.profile.save!
      assign :person, person
      controller.stub(:current_user).and_return(user)

      render
    end

    context 'with logged in user' do
      it 'lists the items within the outer collection, but not the inner collection' do
        assert_select '#person_profile #documents' do
          assert_select 'ul' do
            assert_select 'a[href=?]', collection_path(outer_collection), text: 'Outer Collection'
            assert_select 'a[href=?]', collection_path(inner_collection), text: 'Inner Collection'
            assert_select 'a[href=?]', curation_concern_generic_work_path(outer_work), text: 'Outer Work'
            assert_select 'a[href=?]', curation_concern_generic_work_path(inner_work), count: 0
          end
        end
      end
    end
  end

  context 'with an empty profile and not logged in' do
    before do
      assign :person, person
      controller.stub(:current_user).and_return(user)
      render
    end

    let(:user) { nil }
    it 'should render the person profile section' do
      assert_select '#person_profile' do
        assert_select '#documents', count: 0
        assert_select '#no-documents', count: 0
        assert_select '.form-action', count: 0
      end
    end
  end

  context 'A person when logged in' do
    let(:http_urls) { ['http://www.google.com/','http://www.google.com/map/12/test'] }
    let(:https_urls) { ['https://www.google.com/','https://www.google.com/map/12/test'] }
    let(:no_protocol_urls) { ['google.com/','www.google.com/','www.google.com/map/12/test','jira.duraspace.org'] }
    let(:bad_urls) {['google', 'ftp://test.com']}

    before do
      assign :person, person
      controller.stub(:current_user).and_return(user)
      render
    end

    it 'should match regular expressions' do
      check_url_regex(http_urls)
      check_url_regex(https_urls)
      check_url_regex(no_protocol_urls)
      check_url_regex(bad_urls)
    end

    it 'should render personal webpage and blog URLs as a-tags' do
      check_url_link(http_urls[0] )
      check_url_link(https_urls[0])
      check_url_link(no_protocol_urls[0])
    end
  end

  def check_url_regex(urls)
    http_url_regex = /(?i)\Ahttp(s?):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/
    no_protocol_url_regex = /\A(?i)[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/

    if urls == http_urls || urls == https_urls
      urls.each do |http_url_example|
      http_url_example.should match(http_url_regex)
      end
    end
    urls.each do |no_protocol_url_example|
      no_protocol_url_example.should match(no_protocol_url_regex)
    end if urls == no_protocol_urls
    urls.each do |bad_url_example|
      bad_url_example.should_not match(http_url_regex)
      bad_url_example.should_not match(no_protocol_url_regex)
    end if urls == bad_urls
  end

  def check_url_link(url_example)
    person.stub(:personal_webpage).and_return(url_example)
    render
    if url_example == no_protocol_urls[0]
      rendered.should have_link(url_example, href: 'http://' + url_example)
    else
      rendered.should have_link(url_example, href: url_example)
    end
  end

end
