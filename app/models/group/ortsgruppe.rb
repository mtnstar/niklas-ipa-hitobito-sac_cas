# frozen_string_literal: true

#  Copyright (c) 2012-2023, Schweizer Alpen-Club. This file is part of
#  hitobito_sac_cas and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_sac_cas.

class Group::Ortsgruppe < ::Group

  self.layer = true
  self.event_types = [Event, Event::Course]

  children Group::SektionsFunktionaere,
    Group::SektionsMitglieder,
    Group::SektionsNeuanmeldungenSektion,
    Group::SektionsNeuanmeldungenNv,
    Group::SektionsTourenkommission,
    Group::SektionsExterneKontakte,
    Group::SektionsHuettenkommission

  self.default_children = [
    Group::SektionsFunktionaere,
    Group::SektionsMitglieder,
    Group::SektionsNeuanmeldungenNv,
    Group::SektionsTourenkommission ]

  mounted_attr :foundation_year, :integer
  validates :foundation_year,
            numericality:
            { greater_or_equal_to: 1863, smaller_than: Time.zone.now.year + 2 }

  mounted_attr :section_canton, :string, enum: Cantons.short_name_strings.map(&:upcase)

  mounted_attr :language, :string, enum: %w(DE FR IT), default: 'DE', null: false

  mounted_attr :mitglied_termination_by_section_only, :boolean, default: false, null: false

  def sac_cas_self_registration_url(host)
    Groups::SektionSelfRegistrationLink.new(self, host).url
  end

end
