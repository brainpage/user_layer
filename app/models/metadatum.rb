class Metadatum < ActiveRecord::Base
  belongs_to :host, :polymorphic => true
end
