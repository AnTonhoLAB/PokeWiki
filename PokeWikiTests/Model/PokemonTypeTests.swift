//
//  PokemonTypeTests.swift
//  PokeWikiTests
//
//  Created by George Vilnei Arboite Gomes on 13/01/22.
//


import Quick
import Nimble
import GGDevelopmentKit

@testable import PokeWiki

class PokemonTypeTests: QuickSpec {
    private var sut: PokemonType!
    
    override func spec() {
        tests()
    }
    
    private func tests() {
      
        describe("Tipo de pokemon e cor que ele retorna") {
            
            context("Quando o pokemon for do tipo normal") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.normal
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo flying") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.flying
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.7350213434, green: 0.5857658941, blue: 1, alpha: 1)))
                }
                
            }
            
            context("Quando o pokemon for do tipo poison") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.poison
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.5944519139, green: 0.0970109588, blue: 0.9686274529, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo ground") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.ground
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo rock") {
               
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.rock
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo bug") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.bug
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo ghost") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.ghost
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo steel") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.steel
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo fire") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.fire
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.7993484268, green: 0.09057982137, blue: 0.08117144422, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo water") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.water
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo grass") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.grass
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo electric") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.electric
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo psychic") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.psychic
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.9254902005, green: 0.3827843903, blue: 0.492022982, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo ice") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.ice
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                }
            }
           
            context("Quando o pokemon for do tipo dragon") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.dragon
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo dark") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.dark
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.2116987177, green: 0.2116987177, blue: 0.2116987177, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo fairy") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.fairy
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.9251476526, green: 0.310475969, blue: 0.8065521193, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo unknown") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.unknown
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                }
            }
            
            context("Quando o pokemon for do tipo shadow") {
                
                afterEach {
                    self.sut = nil
                }

                beforeEach {
                    self.sut = PokemonType.shadow
                }
                
                it("Então a cor deve ser") {
                    expect(self.sut.color).to(equal(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                }
            }
        }
    }
}
