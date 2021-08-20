pub contract Artist {

  pub struct Canvas {

    pub let width: UInt8
    pub let height: UInt8
    pub let pixels: String

    init(width: UInt8, height: UInt8, pixels: String) {
      self.width = width
      self.height = height
      // The following pixels
      // 123
      // 456
      // 789
      // should be serialized as
      // 123456789
      self.pixels = pixels
    }
  }

  pub resource Picture {

    pub let canvas: Canvas
    
    init(canvas: Canvas) {
      self.canvas = canvas
    }
  }

  pub resource Printer {

    pub let width: UInt8
    pub let height: UInt8
    pub let prints: {String: Canvas}

    init(width: UInt8, height: UInt8) {
      self.width = width;
      self.height = height;
      self.prints = {}
    }

    pub fun print(canvas: Canvas): @Picture? {
      // Canvas needs to fit Printer's dimensions.
      if canvas.pixels.length != Int(self.width * self.height) {
        return nil
      }

      // Canvas can only use visible ASCII characters.
      for symbol in canvas.pixels.utf8 {
        if symbol < 32 || symbol > 126 {
          return nil
        }
      }

      // Printer is only allowed to print unique canvases.
      if self.prints.containsKey(canvas.pixels) == false {
        let picture <- create Picture(canvas: canvas)
        self.prints[canvas.pixels] = canvas

        return <- picture
      } else {
        return nil
      }
    }
  }

  pub fun display(canvas: Canvas) {
    var border = "+"
    var i = 0
    while i < Int(canvas.width) {
      border = border.concat("-")
      i=i+1
    }  
    border = border.concat("+")

    log(border)
    
    i=0
    var lines : [String] = []
    var cursor = 0
    while i < Int(canvas.height) {
      cursor = i * Int(canvas.height)
      lines.append( "+"
        .concat( canvas.pixels
        .slice( from: cursor, upTo: cursor+Int(canvas.width))
        ).concat("+") 
      )
      log(lines[i])
      i=i+1
    }
    log(border)
  }



  pub resource interface Receiver {
    pub fun deposit(picture: @Picture)
  }

  pub resource interface Viewer {
    pub var pictures: @[Picture] 
    pub fun logPictures()
    pub fun getTotalPictures() : Int
  }  

  pub resource Collection : Receiver, Viewer {
    pub var pictures : @[Picture]
    
    init() {
      self.pictures <- []
    }

    pub fun getTotalPictures() : Int {
      return self.pictures.length
    }

    pub fun logPictures() {
      var i=0
      while i < self.getTotalPictures() {
        log( Artist.display(canvas: self.pictures[i].canvas))   
        i=i+1   
      }
    } 

    pub fun deposit(picture: @Picture) {
      self.pictures.append( <- picture )
    }

    destroy() {
      destroy self.pictures
    }

  }
  
  pub fun createCollection(): @Collection {
    return <- create Collection()
  }

  init() {
    self.account.save(
      <- create Printer(width: 5, height: 5),
      to: /storage/ArtistPicturePrinter
    )
    self.account.link<&Printer>(
      /public/ArtistPicturePrinter,
      target: /storage/ArtistPicturePrinter
    )
  }
}
