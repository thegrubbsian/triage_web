def system_try_and_fail(command)
  sh command do |ok, res|
    if !ok
      system_try_and_fail "git checkout master"
      raise "FAILURE: Error running #{command} (Pwd: #{Dir.pwd}, exit status:#{res.exitstatus}). Aborting"
    end
  end
end

namespace :deploy do

  HEROKU_ACCOUNT = "devmynd"
  MAINLINE_BRANCH = "master"
  STAGING_REMOTE = "triage-app-staging"
  PRODUCTION_REMOTE = "triage-app-production"
  TEST_COMMANDS = ["bundle exec rspec spec/"] # Add additional test commands for Jasmine or Cucumber here

  def make_git_timestamp
    "#{@env}-deploy-#{Time.now.to_s.gsub(/:/, "-").gsub(/\s/, "-").gsub(/--/, "-")}"
  end

  def check_master_branch
    branches = (`git branch`).split
    branches.each_with_index do |br, i|
      if br == "*" && branches[i+1] != MAINLINE_BRANCH
        raise "DEPLOY FAILED: You are not on #{MAINLINE_BRANCH}, you cannot deploy from other branches."
      end
    end
  end

  def check_pending_changes
    status = `git status`
    raise "DEPLOY FAILED: You cannot deploy with pending changes." if status !~ /nothing to commit/
  end

  def set_heroku_account
    system_try_and_fail "heroku accounts:set #{HEROKU_ACCOUNT}"
    log "Heroku account set to #{HEROKU_ACCOUNT}"
  end

  def run_deploy
    timestamp = make_git_timestamp
    deploy_tag(timestamp) if @strategy == "tag"
    deploy_branch(timestamp) if @strategy == "branch"
  end

  def deploy_tag(timestamp)
    log "Tagging with #{timestamp} for #{@env} deploy"
    system_try_and_fail "git tag #{timestamp}"
    system_try_and_fail "git push origin master --tags"
    log "Tag #{timestamp} pushed to origin"
    system_try_and_fail "git push #{@repo} master -f"
    log "Tag #{timestamp} pushed to heroku: #{@repo}"
  end

  def deploy_branch(timestamp)
    log "Branching with #{timestamp} for #{@env} deploy"
    system_try_and_fail "git checkout -b #{timestamp}"
    system_try_and_fail "git push origin #{timestamp}"
    log "Branch #{timestamp} pushed to origin"
    system_try_and_fail "git push #{@repo} #{timestamp}:master -f"
    log "Branch #{timestamp} pushed to heroku: #{@repo}"
    system_try_and_fail "git checkout master"
  end

  def run_specs
    log "Running specs"
    TEST_COMMANDS.each do |command|
      system_try_and_fail command
    end
    log "All specs passing"
  end

  def backup_database
    log "Backing up database"
    system_try_and_fail "heroku pgbackups:capture --expire --app=#{@repo}"
  end

  def migrate_database
    log "Migrate database"
    system_try_and_fail "heroku run rake db:migrate --app=#{@repo}"
  end

  def deploy
    check_master_branch
    check_pending_changes
    set_heroku_account
    log "Deploying to #{@env}"
    run_specs
    run_deploy
    log "Successful deployment to #{@env}"
  end

  def log(msg)
    puts "******** #{msg}"
  end

  task :staging do
    @repo = STAGING_REMOTE
    @strategy = "tag"
    @env = "staging"
    deploy
    migrate_database
  end

  task :production do
    @repo = PRODUCTION_REMOTE
    @strategy = "branch"
    @env = "production"
    backup_database
    deploy
  end

end
