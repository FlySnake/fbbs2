class SseTestsController < ActionController::Base#ApplicationController
  include ActionController::Live
  
  #skip_before_filter :authenticate_user!
  
  def test
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream, retry: 300, event: "event-name")
    10.times {
      puts "******"
      sse.write({ name: 'John'})
      sse.write({ name: 'John'}, id: 10)
      sse.write({ name: 'John'}, id: 10, event: "other-event")
      sse.write({ name: 'John'}, id: 10, event: "other-event", retry: 500)
      sleep 1
    }
    
  ensure
    puts "closing stream"
    sse.close
    puts "closed"
  end
  
   def test1
    response.headers['Content-Type'] = 'text/event-stream'
    3.times {
      puts "writing data to the stream..."
      response.stream.write "hello\n"
      sleep 1
    }
    puts "closing stream..."
    response.stream.close
    puts "closed"
  end
  
end
