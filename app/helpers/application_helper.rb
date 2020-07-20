module ApplicationHelper
  
  # Matter:窓口担当
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
  
  # Manegerに属するサブマネ、スタッフ
  def submanager_staff_arrey
    submanager_arrey = current_manager.submanagers.pluck(:submanager, :id, :name)
    staff_arrey = current_manager.staffs.pluck(:staff, :id, :name)
    staff_arrey.each do |staff|
      @arrey = submanager_arrey.push(staff)
    end
    return @arrey
  end
end
