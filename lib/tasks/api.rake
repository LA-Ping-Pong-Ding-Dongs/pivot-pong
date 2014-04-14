namespace :api do
  desc 'Update api documentation'
  task :document do
    FileUtils.rm_f('doc/apipie_examples.yml')

    old_env = ENV.to_hash
    ENV.update('APIPIE_RECORD' => 'examples')

    spec = Rake::Task['spec']
    spec.reenable
    spec.invoke

    ENV.replace old_env
  end

  def api_files
    ['app/controllers/**/*.rb',
      'app/views/**/*.*'].map {|x| Dir.glob(x) }.flatten
  end

  file 'doc/apipie_examples.yml' => api_files do
    Rake::Task['api:document'].invoke
  end
end
