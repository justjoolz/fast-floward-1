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

pub fun serializeStringArray(_ lines: [String]): String {
  var buffer = ""
  for line in lines {
    buffer = buffer.concat(line)
  }

  return buffer
}

pub resource Picture {

  pub let canvas: Canvas
  
  init(canvas: Canvas) {
    self.canvas = canvas
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

pub fun main() {
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let canvasX = Canvas(
    width: 5,
    height: 5,
    pixels: serializeStringArray(pixelsX)
  )
  let letterX <- create Picture(canvas: canvasX)
  log(letterX.canvas)
  destroy letterX
}