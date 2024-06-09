//
//  AddGameView.swift
//  VideoGameCollection
//
//  Created by Jon Iger on 7/9/21.
//

//import the following frameworks...
import SwiftUI

/**
 View that contains the screen users will use to add new games to their collection
 */
struct AddGameView: View {
    @EnvironmentObject var gameObject: GameCollectionViewModel
    @State var showScanner: Bool
    @State var viewModel: ViewModel
    @State var scanner: ScannerViewController?
    
    init() {
        showScanner = false
        scanner = ScannerViewController()
        viewModel = ViewModel()
    }
    
    //initial body
    var body: some View {
        let bindSearch = Binding<String>(
            get: { viewModel.displayText},
            set: {
                viewModel.setBindSearch(string: $0)
            }
        )
        
        let bindMetacritic = Binding<Bool>(
            get: {viewModel.metacriticSort},
            set: {
                viewModel.setBindMetacritic(bool: $0)
            }
        )
        
        let bindPlatform = Binding<String>(
            get: { viewModel.platformSelection},
            set: {
                viewModel.setBindingPlatform(string: $0)
            }
        )
        
        let bindExact = Binding<Bool>(
            get: {viewModel.showExact},
            set: {
                viewModel.setBindingExact(bool: $0)
            }
        )
        
        //SwiftUI body
        if viewModel.canLoad{
            Form{
                Section(header: Text("Filters")){
                    Toggle("Exact Search", isOn: bindExact)
                    Picker("Platform", selection: bindPlatform, content: {
                        ForEach(viewModel.platformNames, id: \.self){ platform in
                            Text(platform).tag(platform)
                        }
                    })
                    Toggle("Sort by Metacritic", isOn: bindMetacritic)
                }
                HStack{
                    Image(systemName: "magnifyingglass")
                        .padding(4)
                    TextField("Search", text: bindSearch)
                }
                Section(header: Text("Results"), footer: ActivityIndicator(shouldAnimate: $viewModel.isLoading)){
                    List(viewModel.gameResults.results, id: \.id){ game in
                        GameResultRow(title: game.name, id: game.id, platformArray: game.platforms)
                    }
                }
            }
            .navigationTitle("Add Game")
            .navigationBarItems(trailing: Button{
                if viewModel.canLoad{
                    showScanner.toggle()
                }
            }
            label:{
                Image(systemName: "barcode.viewfinder")
            })
            .onAppear(perform: {
                handleFormOnAppear()
            })
            .sheet(isPresented: $showScanner, onDismiss: {
                handleScannerDismissal()
            }){
                if !viewModel.postCameraSuccessAlert{
                    ViewControllerWrapper(scanner: $scanner)
                        .onAppear{
                            viewModel.postCameraSuccessAlert = false
                        }
                }
            }
            .alert(isPresented: $viewModel.postCameraSuccessAlert){
                Alert(title: Text("Game Found"), message: Text("Would you like to add \(viewModel.barcodeTitle) to your collection?"), primaryButton: Alert.Button.default(Text("Yes"), action: {
                    gameObject.gameCollection = viewModel.addScanGameToCloud(gameObject: gameObject)
                }), secondaryButton: Alert.Button.cancel())
            }
        }
        else{
            Text("Unable to display data. Either RAWG or your internet connection is offline. Try again later.")
        }
    }
    
    func handleFormOnAppear(){
        viewModel.checkDatabaseStatus()
        if viewModel.canLoad{
            if viewModel.platformNames.isEmpty{
                viewModel.loadPlatformSelection()
            }
        }
    }
    
    func handleScannerDismissal() {
        do{
            if scanner?.upcString == nil{
                throw BarcodeError.noBarcodeScanned
            }
            viewModel.barcodeLookup(upcCode: (scanner?.upcString)!)
        }
        catch{
            print(error)
        }
    }
}

//Preview struct
struct AddGameView_Previews: PreviewProvider {
    static var previews: some View {
        AddGameView()
    }
}
