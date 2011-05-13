As you can see in the code above, I decided that my `Piece#paint` method was
probably better off as `Canvas#paint_shape`, just to collect the presentation
logic in one place. Here’s what the updated code ended up looking like.

    class Canvas
     # ...

     def paint_shape(shape, position)
       shape.translated_points(position).each do |point|
         paint(point, Piece::SYMBOL)
       end
     end
    end

This new code does not rely directly on the `Piece#points` method anymore, but
instead, passes a position to the newly created `Piece#translated_points` to get a
set of coordinates anchored by the specified position.
