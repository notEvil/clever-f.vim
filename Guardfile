# encoding: utf-8

def which cmd
  dir = ENV['PATH'].split(':').find {|p| File.executable? File.join(p, cmd)}
  File.join(dir, cmd) unless dir.nil?
end

def notify m
  msg = "'#{m}\\n#{Time.now.to_s}'"
  case
  when which('terminal-notifier')
    `terminal-notifier -message #{msg}`
  when which('notify-send')
    `notify-send #{msg}`
  when which('tmux')
    `tmux display-message #{msg}` if `tmux list-clients 1>/dev/null 2>&1` && $?.success?
  end
end

guard :shell do
  watch /^(.+\.vim)$/ do
    result = `../themis/bin/themis test/*.vim`
    unless $?.success?
      notify "test for clever-f.vim fails"
    end
    result
  end
end
