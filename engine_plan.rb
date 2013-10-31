ENV['BUNDLE_GEMFILE'] = './spec/internal/Gemfile'
ENV['RUNNING_VIA_ZEUS'] = 'true'

require 'zeus/rails'

ROOT_PATH = File.expand_path(Dir.pwd)
ENV_PATH  = File.expand_path('spec/internal/config/environment',  ROOT_PATH)
BOOT_PATH = File.expand_path('spec/internal/config/boot',  ROOT_PATH)
APP_PATH  = File.expand_path('spec/internal/config/application',  ROOT_PATH)
ENGINE_ROOT = File.expand_path(Dir.pwd)
ENGINE_PATH = File.expand_path('lib/curate/engine', ENGINE_ROOT)


class EnginePlan < Zeus::Rails
end

Zeus.plan = EnginePlan.new