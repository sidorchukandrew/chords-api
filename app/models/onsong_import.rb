class OnsongImport < ApplicationRecord
  require 'zip'

  belongs_to :team
  has_one_attached :backup

  attr_accessor :songs_to_save, :backup_temp_file, :custom_errors, :binder, :new_errors

  def unzip(file)
    expand file
  end

  def create_songs(imported_songs, binder)
    puts "Importing: #{imported_songs}, binder: #{binder}"
    @songs_to_save = imported_songs
    @binder = Binder.where(id: binder).first

    if backup.attached?
      puts 'Backup attached'
      backup.open do |temp_file|
        @backup_temp_file = temp_file
        save_songs
      end
    else
      puts 'Not attached'
    end
  end

  private

  def expand(zipped_file)
    Zip::File.open(zipped_file) do |zip|
      prepare_response zip
    end
  end

  def prepare_response(zip)
    sorted_entries = zip.sort { |a, b| a <=> b }
    text_files = sorted_entries.select { |entry| txt? entry }
    text_files.each_with_index.map { |file, index| HashWithIndifferentAccess.new(id: index, name: file.name.force_encoding('UTF-8')) }
  end

  def txt?(entry)
    entry.file? && File.extname(entry.name).downcase == '.txt'
  end

  def save_songs
    Zip.force_entry_names_encoding = 'UTF-8'
    Zip::File.open(@backup_temp_file) do |zip|
      all_songs = songs_with_index(zip)

      selected_songs = all_songs.filter do |song|
        @songs_to_save.any? { |song_to_save| matches?(song_to_save, song) }
      end

      selected_songs.each { |song| save_song(song) }

      retry_with_other_encoding unless @custom_errors.nil?
      backup.purge
      self
    end
  end

  def songs_with_index(zip)
    sorted_entries = zip.sort { |a, b| a <=> b }
    text_files = sorted_entries.select { |entry| txt? entry }
    text_files.each_with_index.map { |file, index| { 'id' => index, 'file' => file } }
  end

  def matches?(song_to_save, song_file)
    song_to_save['id'] == song_file['id'] && song_to_save['name'] == song_file['file'].name.force_encoding('UTF-8')
  end

  def save_song(song_wrapper)
    song_lines = []
    song_file = song_wrapper['file']
    file_contents = song_file.get_input_stream.read

    encoded = file_contents.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    song_lines = encoded.split("\n")

    song = Song.new do |s|
      s.name = File.basename(song_file.name, '.txt').strip
      s.source = 'Onsong'
      s.team = team
      add_lines_to_song(song_lines, s)
      s.content = strip_trailing_line_breaks(s.content)
    end

    begin
      song.save
      @binder.songs << song if @binder.present?
    rescue StandardError => e
      @custom_errors = [] if @custom_errors.nil?
      @custom_errors << song_wrapper
    end

  end

  def add_lines_to_song(lines, song)
    lines.drop(1).each do |line|
      if line.downcase.include? 'number:'
        # not supported yet
      elsif line.downcase.include? 'key:'
        song.original_key = retrieve_data_from line
      elsif line.downcase.include? 'artist:'
        song.artist = retrieve_data_from line
      elsif line.downcase.include? 'bpm:'
        song.bpm = retrieve_data_from line
      elsif line.downcase.include? 'flow:'
        # not supported yet
      else
        song.content = "#{song.content}#{line}\n"
      end
    end
  end

  def retrieve_data_from(line)
    line.split(':')[1].strip
  end

  def strip_trailing_line_breaks(content)
    if content.starts_with?("\n") || content.ends_with?("\n")
      lines = content.split("\n")
      lines = lines.drop(1) if lines[0] == "\n" || lines[0] == ''
      content = lines.join("\n")
    end

    content
  end

  def retry_with_other_encoding
    @custom_errors.each { |song| save_song_with_utf16(song) }
    @custom_errors = @new_errors.collect { |error| error['file'].name }
  end

  def save_song_with_utf16(song_wrapper)
    song_lines = []

    song_file = song_wrapper['file']

    song_lines = song_file.get_input_stream.read.force_encoding('UTF-16LE').encode('UTF-8').split("\n")

    song = Song.new do |s|
      s.name = File.basename(song_file.name, '.txt').strip
      s.source = 'Onsong'
      s.team = team
      add_lines_to_song(song_lines, s)
      s.content = strip_trailing_line_breaks(s.content)
    end

    @new_errors = [] if @new_errors.nil?
    begin
      song.save
      @binder.songs << song if @binder.present?
    rescue StandardError
      @new_errors << song_wrapper
    end
  end
end
