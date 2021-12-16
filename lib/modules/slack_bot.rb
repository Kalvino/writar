class SlackBot
  def self.notify(title, fallback, errors)
    notifier = Slack::Notifier.new(ENV["SLACK_WEBHOOK_URL"], channel: '#exceptions', username: 'bughunter')
    error = {
        fallback: fallback,
        title: title,
        text: "```#{errors.inspect}```",
        color: "#DF2626",
        mrkdwn_in: [
            "text",
            "pretext"
        ]
    }
    notifier.ping title, attachments: [error]
  end
end
