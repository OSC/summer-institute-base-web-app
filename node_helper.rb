class NodeHelper

  attr_reader :nodes, :start_frame, :end_frame

  def initialize(frames: nil, nodes: 0)
    @start_frame = frames.split('..').first.to_i
    @end_frame = frames.split('..').last.to_i

    @nodes = nodes.to_i
  end

  def task_frames
    start_frames = Array.new(nodes).map.with_index(1) do |_, array_id|
      task_start_frame(array_id)
    end

    end_frames = Array.new(nodes).map.with_index(1) do |_, array_id|
      task_end_frame(array_id)
    end

    [ start_frames, end_frames ]
  end


  def task_size
    task_size = (total_frames / nodes).to_i
    task_size.zero? ? 1 : task_size
  end

  def total_frames
    # need +1 here bc we're always starting at the first frame
    # 20 - 1 = is 20 frames, not 19. even 3-3 is 1 frame (the third)
    @total_frames ||= end_frame - start_frame + 1
  end

  def task_start_frame(array_id)
    if nodes == 1
      start_frame
    elsif task_size == 1
      # you have as many nodes as there are tasks
      start_frame.zero? ? array_id - 1 : array_id
    elsif array_id == 1
      start_frame
    else
      task_end_frame(array_id - 1) + 1
    end
  end

  def task_end_frame(array_id)
    if nodes == 1
      end_frame
    elsif last_task?(array_id)
      # last task just picks up all the rest
      end_frame
    elsif task_size == 1
      # you have as many nodes as there are tasks
      start_frame.zero? ? array_id - 1 : array_id
    else
      # have to shift everything -1 because task_size
      # is always > 1 here, but task_size includes start frame
      ef = task_start_frame(array_id) + task_size
      last_task?(array_id) ? ef : ef - 1
    end
  end

  def last_task?(array_id)
    array_id == nodes
  end
end