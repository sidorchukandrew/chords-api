module MusicUtils

  CHORD_REGEX = /^([A-G]|[A-G]b|[A-G]#)(maj|min|[Mm+°])?6?(aug|d[io]m|ø)?7?(\/([A-G]|[A-G]b|[A-G]#))?$/

  def detect_key(content)
    chord_line = content.lines.find { |line| chord_line? line }
    chord_line.nil? ? nil : first_chord(chord_line)
  end

  def chord_line?(line)
    tokens = line.split
    chord_count = tokens.count { |token| CHORD_REGEX.match? token }
    chord_count > tokens.size / 2
  end

  def first_chord(line)
    chord = line.split[0]

    if chord.size > 1
      "#{chord_name(chord)}#{accidental(chord)}#{quality(chord)}"
    else
      chord_name(chord)
    end
  end

  def accidental(chord)
    chord[1] if chord[1] == '#' || chord[1] == 'b'
  end

  def quality(chord)
    'm' if chord[1] == 'm' || chord[2] == 'm'
  end

  def chord_name(chord)
    chord[0]
  end
end