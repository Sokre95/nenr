require 'fox16'
require_relative 'gesture.rb'
require_relative 'neural/train_data.rb'
include Fox

class AppWindow < FXMainWindow

  def initialize(app, neural_net)
    super(app, "NENR alphabet", :width => 700, :height => 600)
    @raw_gesture = []
    @current_letter = :alfa
    @show_representatives = true
    @neural_net = neural_net
    @predict = false

    init_layout
    init_drawing_area
    init_buttons
    init_drawing_handler
  end

  def create
    super
    show(PLACEMENT_SCREEN)
  end

  private 

  def init_layout
    @contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|LAYOUT_FILL_X|LAYOUT_FILL_Y,
      padLeft: 0, padRight: 0, padTop: 0, padBottom: 0)

    @canvas_frame = FXVerticalFrame.new(@contents,
      FRAME_SUNKEN|LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 10, padBottom: 10)

    @buttons_frame = FXVerticalFrame.new(@contents,
      FRAME_SUNKEN|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 10, padBottom: 10)
  end

  def init_drawing_area
    FXLabel.new(@canvas_frame, "Prostor za crtanje", nil, JUSTIFY_CENTER_X|LAYOUT_FILL_X)
    # Drawing canvas
    @canvas = FXCanvas.new(@canvas_frame, opts: LAYOUT_FILL_X|LAYOUT_FILL_Y|LAYOUT_TOP|LAYOUT_LEFT)
    @canvas.connect(SEL_PAINT) do |sender, sel, event|
      FXDCWindow.new(@canvas, event) do |dc|
        dc.foreground = @canvas.backColor
        dc.fillRectangle(event.rect.x, event.rect.y, event.rect.w, event.rect.h)
      end
    end
  end

  def init_buttons
    clear_button = FXButton.new(@buttons_frame, "&Clear",
      opts: FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 5, padBottom: 5
    )

    clear_button.connect(SEL_COMMAND) do
      clear_drawing_area()
      @raw_gesture = []
    end

    show_rep_button = FXCheckButton.new(@buttons_frame, "Prikaži karakteristične točke")
    show_rep_button.setCheck(true)
    show_rep_button.connect(SEL_COMMAND) do |sender, sel, checked|
      @show_representatives = checked
      draw_representative_points
    end

    @mode_group = FXGroupBox.new(@buttons_frame, "Načina rada", GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    @mode_group_dt = FXDataTarget.new(0)
    @mode_group_dt.connect(SEL_COMMAND) do
      case @mode_group_dt.value
        when 0
          @save_gesture_button.show
          @alphabet_letter_group.show
          @start_training_button.hide
          @predict = false
        when 1
          @save_gesture_button.hide
          @alphabet_letter_group.hide
          @start_training_button.hide
          @predict = true
        when 2
          @save_gesture_button.hide
          @alphabet_letter_group.hide
          @start_training_button.show
          @predict = false
      end
    end
    FXRadioButton.new(@mode_group, "Stvaranje uzoraka", @mode_group_dt, FXDataTarget::ID_OPTION)
    FXRadioButton.new(@mode_group, "Prepoznavanje uzoraka",  @mode_group_dt, FXDataTarget::ID_OPTION + 1)
    FXRadioButton.new(@mode_group, "Treniranje",  @mode_group_dt, FXDataTarget::ID_OPTION + 2)

    @alphabet_letter_group = FXGroupBox.new(@buttons_frame, "Tip uzorka", GROUPBOX_TITLE_CENTER|FRAME_RIDGE)
    @alphabet_letter_group_dt = FXDataTarget.new(0)
    @alphabet_letter_group_dt.connect(SEL_COMMAND) do
      @current_letter = Gesture::IDENTIFIERS.keys[@alphabet_letter_group_dt.value]
    end
    FXRadioButton.new(@alphabet_letter_group, Gesture::IDENTIFIERS.keys[0].to_s, @alphabet_letter_group_dt, FXDataTarget::ID_OPTION)
    FXRadioButton.new(@alphabet_letter_group, Gesture::IDENTIFIERS.keys[1].to_s, @alphabet_letter_group_dt, FXDataTarget::ID_OPTION + 1)
    FXRadioButton.new(@alphabet_letter_group, Gesture::IDENTIFIERS.keys[2].to_s, @alphabet_letter_group_dt, FXDataTarget::ID_OPTION + 2)
    FXRadioButton.new(@alphabet_letter_group, Gesture::IDENTIFIERS.keys[3].to_s, @alphabet_letter_group_dt, FXDataTarget::ID_OPTION + 3)
    FXRadioButton.new(@alphabet_letter_group, Gesture::IDENTIFIERS.keys[4].to_s, @alphabet_letter_group_dt, FXDataTarget::ID_OPTION + 4)

    @save_gesture_button = FXButton.new(@alphabet_letter_group, "&Spremi uzorak",
      opts: FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_TOP|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 5, padBottom: 5
    )

    @save_gesture_button.connect(SEL_COMMAND) do
      save_gesture_sample
      clear_drawing_area
    end

    FXButton.new(@buttons_frame, "&Exit", nil, app, FXApp::ID_QUIT,
      FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_BOTTOM|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 5, padBottom: 5
    )
    @start_training_button = FXButton.new(@buttons_frame, "&Zapocni treniranje",
      opts: FRAME_THICK|FRAME_RAISED|LAYOUT_FILL_X|LAYOUT_BOTTOM|LAYOUT_LEFT,
      padLeft: 10, padRight: 10, padTop: 5, padBottom: 5
    )
    @start_training_button.connect(SEL_COMMAND) do
      puts "NN Start training"
      train_data = Neural::TrainData.read_from_file(AppData.train_data_file_name)
      @neural_net.train(train_data, AppData.learning_rate, AppData.max_iterations, AppData.batch_size)
    end
  end

  def clear_drawing_area
    FXDCWindow.new(@canvas) do |dc|
      dc.foreground = @canvas.backColor
      dc.fillRectangle(0, 0, @canvas.width, @canvas.height)
    end
  end

  def init_drawing_handler
    @draw_color = "blue"
    @mouse_down = false
    
    @canvas.connect(SEL_LEFTBUTTONPRESS) do
      @canvas.grab
      @mouse_down = true
      @raw_gesture = []
    end

    @canvas.connect(SEL_MOTION) do |sender, sel, event|
      if @mouse_down
        dc = FXDCWindow.new(@canvas)
        dc.foreground = @draw_color
        dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)
        @raw_gesture << [event.last_x, event.last_y]
        dc.end
      end
    end
    @canvas.connect(SEL_LEFTBUTTONRELEASE) do |sender, sel, event|
      @canvas.ungrab
      if @mouse_down
        dc = FXDCWindow.new(@canvas)
        dc.foreground = @draw_color
        dc.drawLine(event.last_x, event.last_y, event.win_x, event.win_y)
        dc.end
        
        @raw_gesture << [event.win_x, event.win_y]

        draw_representative_points if @show_representatives

        @mouse_down = false
      end
    end
  end

  def draw_representative_points
    dc = FXDCWindow.new(@canvas)
    dc.foreground = "red"

    gesture = Gesture.new(@raw_gesture)

    klasa = @neural_net.predict(gesture.representatives.flatten)
    slovo = Gesture::IDENTIFIERS.keys[klasa]
    puts "Slovo: #{slovo}"

    gesture.representative_points.each do |point|
      next if point[0] == Float::NAN || point[1] == Float::NAN # TODO
      x, y = point[0].to_i, point[1].to_i
      dc.drawLine(x - 8, y, x + 8, y)
      dc.drawLine(x, y - 8, x, y + 8)
    end

    dc.end
  end

  def save_gesture_sample
    return if @raw_gesture.empty?

    gesture = Gesture.new(@raw_gesture)
    gesture.save_to_file(@current_letter.to_sym)

    #clear_drawing_area
    @raw_gesture = []
  end
end