class GameConstant
  MATRIX_SIZE = 5

  STATUS_NEW = 'new'
  STATUS_JOINED = 'joined'
  STATUS_LEAVED = 'leaved'
  STATUS_STARTED = 'started'
  STATUS_PLAYING = 'playing'
  STATUS_FINISHED = 'finished'

  COLOR_RED = 'red'
  COLOR_BLUE = 'blue'
  COLOR_KEY = [self::COLOR_RED, self::COLOR_BLUE]

  DEFAULT_SCORE = {
    '0' => 0,
    '1' => 0
  }
end
