namespace :load do
  task :defaults do
    Capistrano::S3::Defaults.populate(self, :set)
  end
end

namespace :deploy do
  namespace :s3 do
    desc "Empties bucket of all files. Caution when using this command, as it cannot be undone!"
    task :empty do
      Capistrano::S3::Publisher.clear!(fetch(:s3_endpoint), fetch(:access_key_id), fetch(:secret_access_key), fetch(:bucket))
    end

    desc "Upload files to the bucket in the current state"
    task :upload_files do
      extra_options = { :write => fetch(:bucket_write_options), :redirect => fetch(:redirect_options) }
      Capistrano::S3::Publisher.publish!(fetch(:s3_endpoint), fetch(:access_key_id), fetch(:secret_access_key),
                             fetch(:bucket), fetch(:deployment_path), extra_options)
    end

    desc "Upload a single file"
    task :upload_single, [:file] do |t, args|
      extra_options = { :write => fetch(:bucket_write_options), :redirect => fetch(:redirect_options) }
      Capistrano::S3::Publisher.publish_single!(fetch(:s3_endpoint), fetch(:access_key_id), fetch(:secret_access_key),
                                         fetch(:bucket), fetch(:deployment_path), File.join(fetch(:deployment_path), args[:file]), extra_options)
    end
  end

  before :updated, :upload_s3 do
    invoke("deploy:s3:upload_files")
  end
end
