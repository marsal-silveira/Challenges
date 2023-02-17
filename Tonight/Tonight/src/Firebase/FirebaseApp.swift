//
//  FirebaseApp.swift
//  Tonight
//
//  Created by Marsal on 29/02/16.
//  Copyright © 2016 Marsal Silveira. All rights reserved.
//

import Firebase

struct FirebaseApp
{
    // ****************************** //
    // MARK: Singleton
    // ****************************** //
    
    private static let singleton = FirebaseApp()
    static func sharedInstance() -> FirebaseApp
    {
        return singleton
    }
    
    // this must be private to avoid init it without using singleton way
    private init() { }
    
    // ****************************** //
    // MARK: Firebase References
    // ****************************** //
    
    private static let BASE_URL = "https://tonight-mps.firebaseio.com"
    
    private var _BASE_REF = Firebase(url: "\(BASE_URL)")
    
    private var _USER_REF = Firebase(url: "\(BASE_URL)/users")
    
    var _CURRENT_USER_REF: Firebase {
        let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        return Firebase(url: "\(_USER_REF)").childByAppendingPath(userID)
    }
    
    // ****************************** //
    // MARK: User
    // ****************************** //
    
    func authUser(email: String!, password: String!, withCompletionBlock block: ((NSError!, FAuthData!) -> Void)!)
    {
        _BASE_REF.authUser(email, password: password, withCompletionBlock: block);
    }
    
    func authWithOAuthProvider(provider: String!, token oauthToken: String!, withCompletionBlock block: ((NSError!, FAuthData!) -> Void)!)
    {
        _BASE_REF.authWithOAuthProvider(provider, token: oauthToken, withCompletionBlock: block)
    }
    
    func unauthUser()
    {
        // unauth() is the logout method for the current user.
        _CURRENT_USER_REF.unauth()
    }
    
    func restorePreviousSession() -> FAuthData!
    {
        // If we have the uid stored, the user is already logger in - no need to sign in again!
        var result: FAuthData! = nil
        if (NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil) {
            result = _CURRENT_USER_REF.authData
        }
        return result
    }
    
    func createUser(email: String!, password: String!, withValueCompletionBlock block: ((NSError!, [NSObject : AnyObject]!) -> Void)!)
    {
        _BASE_REF.createUser(email, password: password, withValueCompletionBlock: block)
    }
    
    func insertUser(user: User)
    {
        _USER_REF.childByAppendingPath(user.uid).setValue(user.toJSON())
    }
    
    // ****************************** //
    // MARK: Club
    // ****************************** //
    
    private var _CLUB_REF = Firebase(url: "\(BASE_URL)/clubs")
    var CLUB_REF: Firebase {
        return _CLUB_REF
    }
    
    func insertClub(club: Club)
    {
        // only continue if club has all required properties
        if (club.name != "") {
            
            // childByAutoId() saves the joke and gives it its own ID... setValue() saves to Firebase.
            let newRef = FirebaseApp.sharedInstance().CLUB_REF.childByAutoId()
            newRef.setValue(club.toJSON())
        }
    }
    
    func fetchClubsWithFilter(filter: String, completionBlock: ((clubs: [Club]) -> Void), failBlock: ((error: NSError) -> Void))
    {
        // filter all clubs from all places...
        if (filter == Filter_All_Places) {
            _CLUB_REF.observeEventType(.Value,
                
                withBlock: { snapshot in
                    // extract clubs from snapshot and return a club list
                    completionBlock(clubs: self.extractClubsFromSnapshot(snapshot))
                },
                withCancelBlock: { error in
                    // just redirect error
                    failBlock(error: error)
            })
        }
        // get only places from a specific city
        else {
            _CLUB_REF.queryOrderedByChild("city").queryEqualToValue(filter).observeEventType(.Value,
                
                withBlock: { snapshot in
                    // extract clubs from snapshot and return a club list
                    completionBlock(clubs: self.extractClubsFromSnapshot(snapshot))
                },
                withCancelBlock: { error in
                    // just redirect error
                    failBlock(error: error)
                })
        }
    }
    
    private func extractClubsFromSnapshot(snapshot: FDataSnapshot) -> [Club]
    {
        // The snapshot is a current look at our clubs data
//        print(snapshot.value)
        
        var clubs = [Club]()
        if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
            
            for snap in snapshots {
                
                if let properties = snap.value as? [String: AnyObject] {
                    
                    // Items are returned chronologically, but it's more fun with the newest clubs first.
                    clubs.insert(Club(properties: properties), atIndex: 0)
                }
            }
        }
        
        return clubs
    }
    
    private
    
    // ****************************** //
    // MARK: Create Database (Data)
    // ****************************** //
    
    func createDatabase()
    {
        var club: Club
        var parties: [Party]! = nil
        
        // ****************************** //
        // MARK: Palhoça
        // ****************************** //
        parties = [Party(title: "Sonido Club #1", description: "Rock a 4 mãos e 4 pés", date: "04/03/2016", price: "R$ 10,00 (Masc / Fem)"),
            Party(title: "Groove de Cajon", description: "Rock e Reggae para todos os gostos", date: "05/03/2016", price: "R$ 10,00 (Masc / Fem)")]
        club = Club(
            name: "The Liffey Brew Pub",
            logoPath: "http://www.liffeypub.com.br/img/assets/the-liffey-brew-pub.png",
            address: "Rua da Universidade, Loja 27, Passeio Pedra Branca - Palhoça",
            city: "Palhoça",
            phone: "(48) 3283-0027",
            site: "http://www.liffeypub.com.br",
            latitude: "-27.6230369",
            longitude: "-48.6786597",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = nil
        club = Club(
            name: "Bendito Boteco",
            logoPath: "http://palhocense.com.br/polopoly_fs/1.1861671.1450359926!/imagens/14503598464547.jpg",
            address: "Avenida Prefeito Nelson Martins, 129, Centro - Palhoça",
            city: "Palhoça",
            phone: "(86) 98157-0135",
            site: "https://www.facebook.com/botecobendito",
            latitude: "-27.6558741",
            longitude: "-48.6745999",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = [Party(title: "Lucas Lucco", description: "Show Nacional - Sertanejo Universitário", date: "04/03/2016", price: "R$ 80,00 Masc / R$ 50,00 Fem")]
        club = Club(
            name: "Mumbai Live Club",
            logoPath: "http://www.boadiversao.com.br/altosagitos/midia/image/content/mumbai_live_club_8417.jpg",
            address: "Rua Caetano Silveira de Mattos, 2463, Centro - Palhoça",
            city: "Palhoça",
            phone: "(48) 3093-0593",
            site: "http://mumbailive.com.br",
            latitude: "-27.6440454",
            longitude: "-48.6649968",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        // ******************************** //
        // MARK: Santo Amaro da Imperatriz
        // ******************************** //
        
        parties = [Party(title: "Lord Dan", description: "Lord Dan Dubbel, Totalmente Faixa Preta", date: "05/03/2016", price: "R$ 5,00 (Masc / Fem")]
        club = Club(
            name: "Cervejaria Faixa Preta",
            logoPath: "http://blackled.com.br/wp-content/uploads/2015/09/400.jpg",
            address: "Rua dos Samurais, 40, esquina esquina com a BR-282, km 25 - Santo Amaro da Imperatriz",
            city: "Santo Amaro da Imperatriz",
            phone: "(48) 9142-4222",
            site: "https://www.facebook.com/cervejariafaixapreta",
            latitude: "-27.6788686",
            longitude: "-48.7512173",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = nil
        club = Club(
            name: "Santo Café Choperia",
            logoPath: "https://scontent-gru2-1.xx.fbcdn.net/hphotos-xpa1/v/t1.0-9/1149003_556250071100326_625070981_n.png?oh=268ced028d8b045d3249a2d40cdc5641&oe=575E03DB",
            address: "Rua Natividade, Nº 3680, Vila Becker - Santo Amaro da Imperatriz",
            city: "Santo Amaro da Imperatriz",
            phone: "(48) 8413-8955",
            site: "https://www.facebook.com/santocafechopperia",
            latitude: "-27.684143",
            longitude: "-48.7621215",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = nil
        club = Club(
            name: "Cervejaria Badenia",
            logoPath: "http://www.greifenbier.com.br/fotos_header/logo_badenia_rund.png",
            address: "Rua Intendente Broering, 3479, Vila Becker - Santo Amaro da Imperatriz",
            city: "Santo Amaro da Imperatriz",
            phone: "(48) 3245-8853",
            site: "http://www.greifenbier.com.br",
            latitude: "-27.6825792",
            longitude: "-48.7578981",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)

        // ******************************** //
        // MARK: São José
        // ******************************** //
        
        parties = [Party(title: "Velho Jeans", description: "Pop Rock Nacional 80's", date: "04/03/2016", price: "R$ 15,00 Masc / R$ 10,00 Fem"),
            Party(title: "Blackout", description: "Bruno Mars | Marron 5 | Blur | Pearl Jam | Green Day", date: "05/03/2016", price: "R$ 15,00 Masc / R$ 10,00 Fem")]
        club = Club(
            name: "Chopp do Gus Kobrasol",
            logoPath: "http://www.cardapiouniversal.com.br/restaurants/46/logo_crop.png",
            address: "Av. Lédio João Martins, 874, Kobrasol - São José",
            city: "São José",
            phone: "(48) 3034-6362",
            site: "http://www.choppdogus.com.br",
            latitude: "-27.5938826",
            longitude: "-48.6134827",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)

        parties = nil
        club = Club(
            name: "Quiosque Chopp Brahma",
            logoPath: "http://www.quiosquebrahma.com.br/img/site/topo/logo.png",
            address: "R. Gerôncio Thives, 1079, Barreiros - São José",
            city: "São José",
            phone: "(48) 3343-7146",
            site: "http://www.quiosquebrahma.com.br",
            latitude: "-27.5849884",
            longitude: "-48.6142711",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        // ******************************** //
        // MARK: Florianópolis
        // ******************************** //
        
        parties = nil
        club = Club(
            name: "Guacamole",
            logoPath: "http://www.aondir.com/img/estabelecimentos/foto_515.jpg",
            address: "Av. Jorn. Rubéns de Arruda Ramos, 2006, Centro - Florianópolis",
            city: "Florianópolis",
            phone: "(48) 3225-0900",
            site: "http://www.guacamolemex.com.br",
            latitude: "-27.5863518",
            longitude: "-48.5513352",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = [Party(title: "PACHA IS FANTASY", description: "Festa a Fantasia regada com muita musica e gente bonita na melhor noite de Floripa", date: "05/03/2016", price: "R$ 80,00 Masc / R$ 60,00 Fem"),
            Party(title: "KASKADE CLOSING SUMMER", description: "Um dos maiores nomes do cenário Eletro na melhor pista da noite", date: "12/03/2016", price: "R$ 70,00 Masc / R$ 50,00 Fem"),
            Party(title: "CRAZY BUNNY", description: "O coelho está solto na noite mais badalada da Ilhad da Magia", date: "26/03/2016", price: "R$ 100,00 Masc / R$ 60,00 Fem")]
        club = Club(
            name: "Pacha Floripa",
            logoPath: "http://www.blogjurereinternacional.com.br/wp-content/uploads/2009/12/Pacha-logo7.jpg",
            address: "Rodovia Jornalista Maurício Sirotski Sobrinho, s/n, Jurerê Internacional - Florianópolis",
            city: "Florianópolis",
            phone: "(48) 3028-5300",
            site: "http://pachafloripa.com.br",
            latitude: "-27.4606566",
            longitude: "-48.4942438",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = [Party(title: "Bruno e Marrone", description: "Uma das maiores duplas sertanejas encantado no palco da Fields", date: "12/04/2016", price: "R$ 80,00 Masc / R$ 40,00 Fem")]
        club = Club(
            name: "Fields",
            logoPath: "http://www.deolhonailha.com.br/fmanager/doni/diversao/imagem3808_1.jpg",
            address: "Av. Paulo Fontes, 1250, Centro - Florianópolis",
            city: "Florianópolis",
            phone: "(48) 3025-6646",
            site: "http://www.fieldsfloripa.com.br",
            latitude: "-27.5996861",
            longitude: "-48.5505914",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)
        
        parties = nil
        club = Club(
            name: "Didge SteakHouse Pub",
            logoPath: "https://pbs.twimg.com/profile_images/948884482/Logomarca_Didge_2010_nova.jpg",
            address: "Av. Jorn. Rubéns de Arruda Ramos, 1950, Centro - Florianópolis",
            city: "Florianópolis",
            phone: "(48) 3365-6615",
            site: "http://www.didge.com.br/",
            latitude: "-27.5865231",
            longitude: "-48.5512382",
            parties: parties)
        FirebaseApp.sharedInstance().insertClub(club)

    }
    
}