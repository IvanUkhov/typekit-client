require 'spec_helper'
require 'rspec/bdd'

RSpec.feature 'Updating a kit' do
  given(:client) { Typekit::Client.new(token: token) }

  given(:kit) do
    client::Kit.new(:kits, id: 'xxx', name: 'Megakit',
      analytics: false, badge: true, domains: ['localhost'],
      families: [{ id: 'vqgt', subset: 'all', variations: ['n4'] }])
  end

  options = { vcr: { cassette_name: 'update_kits_xxx_name_ok' } }

  scenario 'Changing the name attribute via #save', options do
    kit.name = 'Ultrakit'
    kit.save!

    expect(kit.name).to eq('Ultrakit')
  end

  scenario 'Changing the name attribute via #update', options do
    kit.update!(name: 'Ultrakit')

    expect(kit.name).to eq('Ultrakit')
  end

  options = { vcr: { cassette_name: 'update_kits_xxx_families_ok' } }

  scenario 'Adding a new family', options do
    kit.families << Typekit::Record::Family.new(id: 'gkmg')
    kit.save!

    expect(kit.families.length).to be 2
    expect(kit.families.map(&:id)).to contain_exactly('gkmg', 'vqgt')
  end

  options = { vcr: {
    cassette_name: 'show_families_yyy_update_kits_xxx_families_ok' } }

  scenario 'Adding a family fetched earlier', options do
    family = client::Family.find('gkmg')

    expect(family).to be_complete
    expect(family.libraries).not_to be_empty
    expect(family.variations).not_to be_empty

    kit.families << family
    kit.save!

    expect(kit.families.length).to be 2
    expect(kit.families.map(&:id)).to contain_exactly('gkmg', 'vqgt')
  end

  options = { vcr: {
    cassette_name: 'update_kits_xxx_families_variations_ok' } }

  scenario 'Adding a new family with variations', options do
    family = Typekit::Record::Family.new(id: 'gkmg')

    expect { family.variations }.to raise_error(/Client is not specified/i)
    family.variations = [Typekit::Record::Variation.new(id: 'n4')]

    expect(kit.families).not_to be nil

    kit.families << family
    kit.save!

    expect(kit.families.length).to be 2
    expect(kit.families.map(&:id)).to contain_exactly('gkmg', 'vqgt')

    i = kit.families[0].id == 'gkmg' ? 0 : 1
    expect(kit.families[i].variations.map(&:id)).to eq(['n4'])
  end

  options = { vcr: {
    cassette_name: 'update_kits_xxx_empty_families_ok' } }

  scenario 'Deleting all families', options do
    expect(kit.families.length).to be 1

    family = kit.families.first
    kit.families.delete(family)
    kit.save!

    expect(kit.families).to be_empty
  end
end
