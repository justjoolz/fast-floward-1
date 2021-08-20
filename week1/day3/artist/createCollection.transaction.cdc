import Artist from "./contract.cdc"

// Create a Picture Collection for the transaction authorizer.
transaction {   
  prepare(account: AuthAccount) {
    if account.borrow<&Artist.Collection>(from: /storage/ArtistCollection) == nil {
      // Create a new Artist.Collection Vault and put it in storage
      account.save(<-Artist.createCollection(), to: /storage/ArtistCollection)

      // Create a public capability to the Collection that only exposes
      // the deposit function through the Receiver interface
     account.link<&Artist.Collection{Artist.Receiver}>(
        /public/ArtistCollectionReceiver,
        target: /storage/ArtistCollection
      )

      // Create a public capability to the Vault that only exposes
      // the balance field through the Balance interface
      account.link<&Artist.Collection{Artist.Viewer}>(
        /public/ArtistCollectionViewer,
        target: /storage/ArtistCollection
      )

    }
  }
}

 