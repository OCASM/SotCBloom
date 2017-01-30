Bloom effect from Shadow of the Colossus for Unity
 
It's based on the scene depth, not on the brightness of the pixels in the color buffer. It relies on frame blending to achieve a high blur radius.

For more info [take a look at this] and [this].

Off:
![ScreenshotA1][ImageA1]
On:
![ScreenshotA2][ImageA2]

Because it's applied after transparencies it can make them look translucent:

Off:
![ScreenshotB1][ImageB1]
On:
![ScreenshotB2][ImageB2]

[this]: https://forum.beyond3d.com/posts/1957634/
[take a look at this]: http://selmiak.bplaced.net/games/ps2/index.php?lang=eng&game=sotc&page=makingof

[ImageA1]: http://i.imgur.com/9YUx3ZL.png
[ImageA2]: http://i.imgur.com/6JkbOY5.png

[ImageB1]: http://i.imgur.com/mFzbqGx.png
[ImageB2]: http://i.imgur.com/nMtFhmd.png
