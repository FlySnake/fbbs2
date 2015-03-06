module HomeHelper
  
  def path_to_enviroment(enviroment, page)
    if page == :enviroment_build_jobs
      enviroment_build_jobs_path(:enviroment_title => enviroment.title)
    else
      home_enviroments_path(:enviroment_title => enviroment.title)
    end
  end
  
end
