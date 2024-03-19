module Pod
    class Command
      class Privacy < Command
        class Install < Privacy
            self.summary = '在工程中创建对应隐私清单文件'

            self.description = <<-DESC
                1、在工程Resources 文件夹下创建隐私清单文件
                2、搜索对应组件，补全隐私Api部分
                3、只处理隐私Api部分，隐私权限相关需要自行处理！！！
            DESC

            def self.options
                [
                  ["--folds=folds", '传入自定义搜索文件夹，多个文件目录使用“,”分割'],
                  ['--query', '仅查询隐私api，不做写入'],
                  ['--all', '忽略黑名单和白名单限制，查询工程所有组件'],
                ].concat(super)
            end

            def initialize(argv)
                @folds = argv.option('folds', '').split(',')
                is_query = argv.flag?('query',false)
                is_all = argv.flag?('all',false)
                instance = Pod::Config.instance
                instance.is_query = is_query
                instance.is_all = is_all
                super
            end
    
            def run
                verify_podfile_exists!

                installer = installer_for_config
                installer.repo_update = false
                installer.update = false
                installer.deployment = false
                installer.clean_install = false
                installer.privacy_analysis(@folds)
            end
        end
      end
    end
  end
  