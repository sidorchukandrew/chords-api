require 'docx'
require 'ruby-rtf'

class SongFileImporter
  attr_accessor :files, :errors, :team_id

  def initialize(files = [], team_id)
    @files = files
    @team_id = team_id
    @errors = []
  end

  def convert_files
    @files.each { |file| convert_file file }
  end

  def errors?
    @errors.present?
  end

  private

  def convert_file(file)
    content = ''

    begin
      content = extract_content(file)
    rescue StandardError => e
      puts "#{file_name} #{e}"
      @errors << "#{file_name}: Could not parse/read file"
      return
    end

    file_name = File.basename(file.original_filename, '.*').force_encoding('UTF-8')
    song = Song.new do |s|
      s.name = file_name
      s.content = content
      s.source = 'File'
      s.team_id = @team_id
    end

    begin
      @errors << "#{file_name}: #{song.errors&.full_messages&.join(', ')}" unless song.save
    rescue StandardError => e
      puts e
      song.content = song.content.force_encoding('UTF-16LE').encode('UTF-8')
      @errors << "#{file_name}: #{song.errors&.full_messages&.join(', ')}" unless song.save
    rescue Exception => e
      puts e
      @errors << "#{file_name}: Could not parse/read file"
    end
  end

  def extract_content(file)
    extension = File.extname(file.original_filename)
    if extension == '.docx'
      extract_docx_content(file)
    elsif txt_format?(extension)
      extract_txt_content(file)
    elsif extension == '.pdf'
      extract_pdf_content(file)
    end
  end

  def extract_docx_content(file)
    doc = Docx::Document.open(file.path)
    doc.paragraphs.map { |p| p }.join("\n")
  end

  def extract_txt_content(file)
    content = file.read
    content = content.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    puts content
    file.close
    content
  end

  def extract_pdf_content(file)
    reader = PDF::Reader.new(file.path)
    reader.pages.map { |page| page.text }.join("\n")
  end

  def txt_format?(extension)
    ['.txt', '.chordpro'].include?(extension)
  end
end