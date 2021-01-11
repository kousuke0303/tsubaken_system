class String
  def custom_truncate(return_length = "")
    length = self.length
    if length <= return_length
      return self
    else
      limit = return_length - 1
      return self[0..limit] + "..."
    end
  end
end
