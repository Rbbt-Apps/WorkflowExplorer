require 'rbbt'
require 'net/ftp'

module ICGC
  SERVER = 'data.dcc.icgc.org'

  def self.ftp
    @ftp ||= begin
             ftp = Net::FTP.new(SERVER)
             ftp.login
             ftp
           end
  end

  def self.datasets
    ftp = self.ftp
    ftp.chdir('current')
    ftp.nlst.select{|n| n[0] != "!"}
  end

  def self.dataset_files(dataset)
    ftp = self.ftp
    ftp.chdir(File.join('/current', dataset))

    files = {}
    ftp.nlst.select{|n| n[0] != "!"}.each do |file|
      type, *rest = file.split '.'
      files[type] = File.join('/current', dataset, file)
    end
    ftp.chdir(File.join('/current', dataset))
    files
  end

  def self.get_file(file)
    Open.open('ftp://' << File.join(SERVER, file))
  end

  def self.study_rakefile(dataset)
    files = dataset_files(dataset)
    rakefile = ""

    if files.include? "ssm"
      rakefile +=<<-EOF

file :genotypes do |t|
  ICGC.job(:get_ssm, "ICGCScout", :dataset => '#{dataset}').run.each do |sample, genotype|
    Open.write(File.join(t.name, sample), genotype * "\\n")
  end
end

      EOF
    end
 
    if files.include? "cnv"
      rakefile +=<<-EOF

file :cnv do |t|
  ICGC.job(:get_cnv, "ICGCScout", :dataset => '#{dataset}').run.each do |sample, genotype|
    Open.write(File.join(t.name, sample), genotype * "\\n")
  end
end

      EOF
    end
 
    if files.include? "gene_expression"
      rakefile +=<<-EOF

file "matrices/gene_expression" do |t|
    Open.write(File.join(t.name, data), ICGC.job(:get_gene_expression, "ICGCScout", :dataset => '#{dataset}').run.to_s)
  end
end

      EOF
    end
    rakefile
  end

  def self.prepare_study(dataset)
    dir = Rbbt.studies.find(:lib)[dataset]
    FileUtils.mkdir_p dir
    Open.write(File.join(dir, 'Rakefile'), study_rakefile(dataset))
    Open.write(File.join(dir, 'metadata.yaml'), {:condition => dataset.sub(/-.*/,''), :organism => "Hsa/jan2013", :watson => true}.to_yaml)
  end
end

