require "bluecloth"
module AsksHelper
  def topics_name_tag(topics,limit = 3)
    html = []
    return "" if topics.blank?
    if limit > 0
      topics = topics[0,limit]
    end
    for topic in topics
      html.append("<a class=\"topic\" href=\"/topic/#{topic.id}\">#{topic.name}</a>")
    end
    return raw html.join(",")
  end

  def md_body(str)
    str = sanitize(str,:tags => %w(strong b i u strike ol ul li br div), :attributes => %w(src))
    return raw str
  end

  def truncate_lines(body, lines = 4, max_chars = 400)
    return "" if body.blank?
    body_lines = body.strip("\n")
    lines = body_lines.count if body_lines.count < lines
    summary = body_lines[0,lines].join("\n")
    summary = inner_truncate_lines(body_lines, lines - 1, summary, max_chars)
    return summary
  end

  # 检测是否 Vote 过 Answer
  def voted?(answer,type = :up)
    return false if current_user.blank?
    if type == :up
      return false if answer.up_voter_ids.blank?
      return answer.up_voter_ids.count(current_user.id) > 0
    else
      return false if answer.down_voter_ids.blank?
      return answer.down_voter_ids.count(current_user.id) > 0
    end
  end

  private
  def inner_truncate_lines(body_lines, lines, summary, max_chars)
    if summary.length > max_chars
      lines -= 1
      if lines > 1
        body_lines = body_lines[0,lines]
        summary = body_lines.join("\n")
        return inner_truncate_lines(body_lines, lines, summary, max_chars)
      else
        summary = body_lines[0][0,max_chars]
        return summary
      end
    else
      return summary
    end
  end

  
end
