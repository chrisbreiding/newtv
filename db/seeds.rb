# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AppData.create({
  last_updated: '1383748653',
  download_link: 'http://example.com?s=%s'
})

User.create({
  email: 'chrisbreiding@gmail.com',
  password: 'foobar',
  password_confirmation: 'foobar'
})

shows = Show.create([
  { name: 'Airing Show 1', tvsource_id: 1 },
  { name: 'Airing Show 2', tvsource_id: 2 },
  { name: 'Airing Show 3', tvsource_id: 3 },
  { name: 'Airing Show 4', tvsource_id: 4 },
  { name: 'Far Future Show 1', tvsource_id: 5 },
  { name: 'Off Air Show 1', tvsource_id: 6 },
  { name: 'Off Air Show 2', tvsource_id: 7 }
])

# Episodes for Airing Show 1
Episode.create([
  { title: '2 months ago', season: 3, episode_number: '01', show_id: shows[0].id, airdate: 2.months.ago.to_date },
  { title: '1 months ago', season: 3, episode_number: '02', show_id: shows[0].id, airdate: 1.months.ago.to_date },
  { title: '2 weeks ago', season: 3, episode_number: '03', show_id: shows[0].id, airdate: 2.weeks.ago.to_date },
  { title: '3 days ago', season: 3, episode_number: '04', show_id: shows[0].id, airdate: 3.days.ago.to_date.to_date },
  { title: '6 days from now', season: 3, episode_number: '05', show_id: shows[0].id, airdate: 6.days.from_now.to_date },
  { title: '2 weeks from now', season: 3, episode_number: '06', show_id: shows[0].id, airdate: 2.weeks.from_now.to_date },
  { title: '3 weeks from now', season: 3, episode_number: '07', show_id: shows[0].id, airdate: 3.weeks.from_now.to_date },
  { title: '4 weeks from now', season: 3, episode_number: '08', show_id: shows[0].id, airdate: 4.weeks.from_now.to_date }
])

# Episodes for Airing Show 2
Episode.create([
  { title: '3 months ago', season: 1, episode_number: '01', show_id: shows[1].id, airdate: 3.months.ago.to_date },
  { title: '2 months ago', season: 1, episode_number: '02', show_id: shows[1].id, airdate: 2.months.ago.to_date },
  { title: '1 week ago', season: 1, episode_number: '03', show_id: shows[1].id, airdate: 1.week.ago.to_date },
  { title: 'Today', season: 1, episode_number: '04', show_id: shows[1].id, airdate: Date.today },
  { title: '4 days from now', season: 1, episode_number: '05', show_id: shows[1].id, airdate: 4.days.from_now.to_date },
  { title: '2 weeks from now', season: 1, episode_number: '06', show_id: shows[1].id, airdate: 2.weeks.from_now.to_date },
  { title: '3 weeks from now', season: 1, episode_number: '07', show_id: shows[1].id, airdate: 3.weeks.from_now.to_date },
  { title: '4 weeks from now', season: 1, episode_number: '08', show_id: shows[1].id, airdate: 4.weeks.from_now.to_date },
  { title: '2 months from now', season: 1, episode_number: '09', show_id: shows[1].id, airdate: 2.months.from_now.to_date },
  { title: '3 months from now', season: 1, episode_number: '10', show_id: shows[1].id, airdate: 3.months.from_now.to_date }
])

# Episodes for Airing Show 3
Episode.create([
  { title: 'Yesterday', season: 5, episode_number: '01', show_id: shows[2].id, airdate: 1.day.ago.to_date },
  { title: '1 week from now', season: 5, episode_number: '02', show_id: shows[2].id, airdate: 1.week.from_now.to_date },
  { title: '2 weeks from now', season: 5, episode_number: '03', show_id: shows[2].id, airdate: 2.weeks.from_now.to_date },
  { title: '3 weeks from now', season: 5, episode_number: '04', show_id: shows[2].id, airdate: 3.weeks.from_now.to_date },
  { title: '4 weeks from now', season: 5, episode_number: '05', show_id: shows[2].id, airdate: 4.weeks.from_now.to_date }
])

# Episodes for Airing Show 4
Episode.create([
  { title: '11 months ago', season: 1, episode_number: '01', show_id: shows[3].id, airdate: 11.months.ago.to_date },
  { title: '10 months ago', season: 1, episode_number: '02', show_id: shows[3].id, airdate: 10.months.ago.to_date },
  { title: '9 months ago', season: 1, episode_number: '03', show_id: shows[3].id, airdate: 9.months.ago.to_date },
  { title: '8 months ago', season: 1, episode_number: '04', show_id: shows[3].id, airdate: 8.months.ago.to_date },
  { title: '4 weeks ago', season: 2, episode_number: '01', show_id: shows[3].id, airdate: 4.week.ago.to_date },
  { title: '3 weeks ago', season: 2, episode_number: '02', show_id: shows[3].id, airdate: 3.weeks.ago.to_date },
  { title: '2 weeks ago', season: 2, episode_number: '03', show_id: shows[3].id, airdate: 2.weeks.ago.to_date },
  { title: '1 week ago', season: 2, episode_number: '04', show_id: shows[3].id, airdate: 1.week.ago.to_date },
  { title: '2 days ago', season: 2, episode_number: '05', show_id: shows[3].id, airdate: 2.days.ago.to_date },
  { title: '1 week from now', season: 2, episode_number: '06', show_id: shows[3].id, airdate: 1.week.from_now.to_date },
  { title: '2 weeks from now', season: 2, episode_number: '07', show_id: shows[3].id, airdate: 2.weeks.from_now.to_date },
  { title: '3 weeks from now', season: 2, episode_number: '08', show_id: shows[3].id, airdate: 3.weeks.from_now.to_date },
  { title: '4 weeks from now', season: 2, episode_number: '09', show_id: shows[3].id, airdate: 4.weeks.from_now.to_date },
  { title: '5 weeks from now', season: 2, episode_number: '10', show_id: shows[3].id, airdate: 5.weeks.from_now.to_date }
])

# Episodes for Far Future Show 2
Episode.create([
  { title: '11 weeks from now', season: 11, episode_number: '01', show_id: shows[4].id, airdate: 11.weeks.from_now.to_date },
  { title: '12 weeks from now', season: 11, episode_number: '02', show_id: shows[4].id, airdate: 12.weeks.from_now.to_date },
  { title: '13 weeks from now', season: 11, episode_number: '03', show_id: shows[4].id, airdate: 13.weeks.from_now.to_date },
  { title: '14 weeks from now', season: 11, episode_number: '04', show_id: shows[4].id, airdate: 14.weeks.from_now.to_date }
])

# Episodes for Off Air Show 1
Episode.create([
  { title: '14 weeks ago', season: 1, episode_number: '01', show_id: shows[5].id, airdate: 14.weeks.ago.to_date },
  { title: '13 weeks ago', season: 1, episode_number: '02', show_id: shows[5].id, airdate: 13.weeks.ago.to_date },
  { title: '12 weeks ago', season: 1, episode_number: '03', show_id: shows[5].id, airdate: 12.weeks.ago.to_date },
  { title: '11 weeks ago', season: 1, episode_number: '04', show_id: shows[5].id, airdate: 11.weeks.ago.to_date }
])

# Episodes for Off Air Show 2
Episode.create([
  { title: '23 weeks ago', season: 1, episode_number: '01', show_id: shows[6].id, airdate: 23.weeks.ago.to_date },
  { title: '22 weeks ago', season: 1, episode_number: '02', show_id: shows[6].id, airdate: 22.weeks.ago.to_date },
  { title: '21 weeks ago', season: 1, episode_number: '03', show_id: shows[6].id, airdate: 21.weeks.ago.to_date },
  { title: '20 weeks ago', season: 1, episode_number: '04', show_id: shows[6].id, airdate: 20.weeks.ago.to_date },
  { title: '14 weeks ago', season: 2, episode_number: '01', show_id: shows[6].id, airdate: 14.weeks.ago.to_date },
  { title: '13 weeks ago', season: 2, episode_number: '02', show_id: shows[6].id, airdate: 13.weeks.ago.to_date },
  { title: '12 weeks ago', season: 2, episode_number: '03', show_id: shows[6].id, airdate: 12.weeks.ago.to_date },
  { title: '11 weeks ago', season: 2, episode_number: '04', show_id: shows[6].id, airdate: 11.weeks.ago.to_date }
  ])
