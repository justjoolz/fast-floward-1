import Artist from "./contract.cdc"

// Print a Picture and store it in the authorizing account's Picture Collection.
transaction(width: UInt8, height: UInt8, pixels: String) {
    prepare(account: AuthAccount) {
        // borrow refernce to printer from storage
        let printerCap = account.getCapability<&Artist.Printer>(/public/ArtistPicturePrinter)
        let printerRef = printerCap.borrow() ?? panic("Unable to borrow Printer resource")
        // or borrow directly from /storage/ 
        // let printerRef = account.borrow<&Artist.Printer>(from: /storage/ArtistPicturePrinter)
        
        let picture <- printerRef.print( canvas: Artist.Canvas( height: height, width: width, pixels: pixels ) )
        let collectionCap = account.getCapability(/public/ArtistCollectionReceiver) 
        let collectionRef = collectionCap.borrow<&Artist.Collection{Artist.Receiver}>() ?? panic("unable to borrow auth accounts picture collection" )

        collectionRef.deposit( picture: <- picture! )
  }
}