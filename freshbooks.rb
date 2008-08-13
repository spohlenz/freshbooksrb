require File.dirname(__FILE__) + '/freshbooks/api'
require File.dirname(__FILE__) + '/freshbooks/base'

module FreshBooks
  
  # Must be called before invoking API methods
  
  def self.setup(url, token)
    @url = url
    API.configure(url, token)
  end

  def self.url
    @url
  end
  
  # Models exposed by FreshBooks API
  
  class Client < Base
    has_many :recurrings
    has_many :invoices
    has_many :estimates
    has_many :payments
  end
  
  class Invoice < Base
    map :date     => :date,
        :amount   => :float,
        :discount => :float
    
    has_many :payments
    belongs_to :client
    
    def sendByEmail
      self.class.sendByEmail(invoice_id)
    end
    
    def sendBySnailMail
      self.class.sendBySnailMail(invoice_id)
    end
    
    def self.sendByEmail(id)
      call_api_with_id('sendByEmail', id)
    end
    
    def self.sendBySnailMail(id)
      call_api_with_id('sendBySnailMail', id)
    end
  end
  
  class Estimate < Base
    map :date     => :date,
        :amount   => :float,
        :discount => :float
    
    belongs_to :client
    
    def sendByEmail
      self.class.sendByEmail(invoice_id)
    end
    
    def self.sendByEmail(id)
      call_api_with_id('sendByEmail', id)
    end
  end
  
  class Recurring < Base
    map :date            => :date,
        :discount        => :float,
        :send_email      => :boolean,
        :send_snail_mail => :boolean
    
    has_many :invoices
    belongs_to :client
  end
  
  class Item < Base
    map :unit_cost => :float,
        :quantity  => :integer,
        :inventory => :integer
  end
  
  class Payment < Base
    map :date   => :date,
        :amount => :float
    
    belongs_to :client
    belongs_to :invoice
    
    def self.delete(id)
      raise 'Payments may not be deleted'
    end
  end
  
  class TimeEntry < Base
    map :hours => :float,
        :date  => :date
    
    belongs_to :project
    belongs_to :task
  end
  
  class Project < Base
    map :rate => :float
    
    has_many :time_entries
    has_many :tasks
  end
  
  class Task < Base
    map :rate     => :float,
        :billable => :boolean
    
    has_many :time_entries
  end
  
end
