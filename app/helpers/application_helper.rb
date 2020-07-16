module ApplicationHelper
  
  def manage_authority(manager)
    @submanagers = Submanager.joins(matters: :managers).select('submanagers.*').merge(MatterSubmanager.where(manage_authority: true)).merge(Matter.where(id: current_matter.id)).merge(Manager.where(id: manager.id))
    if @submanagers.present?
      @name = @submanagers.first.name
      @telephone = @submanagers.first.phone
    else
      @name = manager.name
      @telephone = manager.phone
    end
  end
  
end
