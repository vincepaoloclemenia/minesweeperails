class BoardGenerator
  PERCENTAGE_PER_AREA = 0.2 # 20%

  def initialize(height:, width:, return_2d_array: false)
    @height = height
    @width = width
    @string = ''
    @return_2d_array = return_2d_array
    @array = []
    @errors = []
    @bombs = (height.to_f * width.to_f * PERCENTAGE_PER_AREA).round
  end
  
  attr_reader :height, :width, :string, :array, :errors, :bombs
  attr_accessor :return_2d_array
  
  def call
    validate_inputs
    place_bombs
    draw_board
    
    return array if @return_2d_array
    string
  end
  
  private

  def validate_inputs
    @errors << 'Invalid height. Must be at least 2 and above' if height <= 1
    @errors << 'Invalid width. Must be at least 2 and above' if width <= 1
    raise @errors.join(',') if @errors.any?
  end
  
  def place_bombs
    return if string.present?

    @string = (0...(height * width)).to_a.sample(bombs).each_with_object({}) do |coordinate, hash|
      if coordinate.zero?
        hash[coordinate] = [coordinate] if hash[coordinate].nil?
        hash[coordinate] << coordinate
        next
      end
      x = coordinate % width
      y = coordinate / width
      hash[y].nil? and hash[y] = [x] and next
      hash[y] << x
    end

    @string = @string.to_json
  end

  def draw_board
    return unless return_2d_array
    bomb_locs = JSON.parse string

    y = 0
    while y < height do
      array[y] = []
      array[y][width - 1] = nil
      bomb_locs[y.to_s]&.each do |x|
        array[y][x] = 'X'
      end
      y+=1
    end
  end
end