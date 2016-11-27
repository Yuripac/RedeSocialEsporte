namespace :sample_data do
  desc 'Users'
  task users: :environment do
    User.destroy_all

    User.create!(
      uid: '811642225624631',
      name: 'Yuri Matheus',
      email: 'yuri_dias_@hotmail.com',
      provider: 'facebook'
    )

    User.create!(
      uid:'4484643654646',
      name: 'Ricardo de Andrade',
      email: 'ricardo.andrade@hotmail.com',
      provider: 'facebook'
    )

    User.create!(
      uid: '44684254848484',
      name: 'Ana Paula',
      email: 'ana.paula@hotmail.com',
      provider: 'facebook'
    )
  end

  desc 'Sports'
  task sports: :environment do
    Sport.destroy_all

    sport_names = ['running', 'football', 'basketball', 'swimming',
      'volleyball', 'functional training']

    sport_names.each { |n| Sport.create(name: n) }
  end

  desc 'Groups'
  task groups: :environment do
    Group.destroy_all

    user_yuri    = User.find_by(uid: '811642225624631')
    user_ricardo = User.find_by(uid: '4484643654646')

    g = Group.create!(
      name: 'Fort Running',
      description: 'Nós nos reunimos pelos parques e praças de Fortaleza e corremos em média 5km. Todos serão bem vindos.',
      sport: Sport.find_by(name: 'running'),
      admins: [user_yuri]
    )

    g1 = Group.create!(
      name: 'Aldeota Funcional',
      description: 'Grupo para quem procura uma boa equipe de treino funcional. Atividades ocorrem pelas praças do bairro Aldeota todos os dias.',
      sport: Sport.find_by(name: 'functional training'),
      admins: [user_ricardo]
    )
  end

  desc 'Memberships'
  task memberships: :environment do
    user_ana = User.find_by(uid: '44684254848484')
    user_yuri = User.find_by(uid: '811642225624631')

    group_fort = Group.find_by(name: 'Fort Running')
    group_aldeota = Group.find_by(name: 'Aldeota Funcional')

    group_aldeota.members << user_yuri
    
    Group.all.each do |g|
      g.members << user_ana
    end
  end

  desc 'Activities'
  task activities: :environment do
    group_func = Group.find_by(name: 'Aldeota Funcional')

    group_func.create_activity(address: 'Praça da Imprensa', latitude: '-3.7460479',
      longitude: '-38.5017598', date: 1.day.from_now)
  end

  desc 'Participations'
  task participations: :environment do
    Participation.destroy_all
    user_ana = User.find_by(uid: '44684254848484')
    act_func = Group.find_by(name: 'Aldeota Funcional').activity

    act_func.participants << user_ana
  end

  desc 'Everything'
  task all: ['db:reset', :users, :sports, :groups, :memberships, :activities, :participations]
end
