require 'lib/rues'

RSpec.describe Rues do
  class Post
    attr_reader :id, :title, :body

    def apply_event payload
      @id = payload[:id]
      @title = payload[:title] if payload[:title]
      @body = payload[:body] if payload[:body]
    end
  end

  describe '.store_event' do
    it 'stores the event with the aggregate id' do
      Rues.store_event(id: 1, title: 'foo')
      Rues.store_event(id: 2, title: 'bar')
      Rues.store_event(id: 2, title: 'foobar', body: 'baz')
      Rues.store_event(id: 3, title: 'qux')

      expect(Rues.events).to eq(
        1 => [{id: 1, title: 'foo'}],
        2 => [{id: 2, title: 'bar'}, {id: 2, title: 'foobar', body: 'baz'}],
        3 => [{id: 3, title: 'qux'}],
      )
    end
  end

  describe '.load_aggregate' do
    it 'applies the relevant events' do
      Rues.store_event(id: 1, title: 'foo')
      Rues.store_event(id: 2, title: 'bar', body: 'baz')
      Rues.store_event(id: 2, title: 'foobar')
      Rues.store_event(id: 3, title: 'qux')

      post = Rues.load_aggregate(2, Post)
      expect(post.id).to eq 2
      expect(post.title).to eq 'foobar'
      expect(post.body).to eq 'baz'
    end
  end
end
