class Competition < ActiveRecord::Base
  STATES = {
      正常: '0',
      暂停: '1',
      停止: '2',
  }
end
