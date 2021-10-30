
# 1) Trazer todos os dados de racas da API

Vamos utilizar:

struct Breed {
   adaptability: Int, // Adaptabilidade
affectionLevel: Int, // Afeicao
childFriendly: Int, // Gosta de criancas
countryCode: String, 
description: String, 
dogFriendly: Int, // Gosta de cachorros
energyLevel: Int, // Nivel de energia
experimental: Int, 
grooming: Int, // Precisa escovar
hairless: Int, // Sem pelo
healthIssues: Int, // Problemas de saude
hypoallergenic: Int, // Nao da alergia
identity: String,
image: CatImage, 
indoor: Int, // Pode viver em apto
intelligence: Int, // Inteligente
lap: Int, // Gosta de colo
lifeSpan: String, // Anos de vida
name: String,
natural: Int, // Natural ? 
origin: String,
rare: Int, // Raro 
rex: Int, // https://excitedcats.com/types-of-rex-cats/
sheddingLevel: Int, // Solta pelo 
shortLegs: Int, // Perninha curta
socialNeeds: Int, // Necessidade 
strangerFriendly: Int,  // Amigavelmente estranho
suppressedTail: Int, // Rabo pequeno
temperament: String,  //Temperamentos (varios)
vocalisation: Int, // Barulhento
weight: CatWeight // Peso


struct CatImage {
    url: String

}

struct CatWeight {
	var weight: {
	var metric: String
}

}

{
    "adaptability": 5,
    "affection_level": 5,
    "alt_names": "",
    "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
    "child_friendly": 3,
    "country_code": "EG",
    "country_codes": "EG",
    "description": "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
    "dog_friendly": 4,
    "energy_level": 5,
    "experimental": 0,
    "grooming": 1,
    "hairless": 0,
    "health_issues": 2,
    "hypoallergenic": 0,
    "id": "abys",
    "image": {
      "height": 1445,
      "id": "0XYvRd7oD",
      "url": "https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg",
      "width": 1204
    },
    "indoor": 0,
    "intelligence": 5,
    "lap": 1,
    "life_span": "14 - 15",
    "name": "Abyssinian",
    "natural": 1,
    "origin": "Egypt",
    "rare": 0,
    "reference_image_id": "0XYvRd7oD",
    "rex": 0,
    "shedding_level": 2,
    "short_legs": 0,
    "social_needs": 5,
    "stranger_friendly": 5,
    "suppressed_tail": 0,
    "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
    "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
    "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
    "vocalisation": 1,
    "weight": {
      "imperial": "7  -  10",
      "metric": "3 - 5"
    },
    "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)"
  },


# 2) CRIAR O BANCO DE DADOS DE RACAS NO CORE DATA com entity Breed

# 3) Mapear struct que veio da API para a classe Breed 

# 4) Na primeira tela: vamos sempre trazer os dados da API. Se sucesso, apagamos tudo do Core Data e substituimos

# 5) Tela de escolha do usuario: ao apertar o botao, selecionar do Banco de dados

# 6) Abrir uma nova tela com tableview com as opcoes

# 7) Ao clicar no desejado: abrir tela de detalhes

# 8) Usuario pode favoritar

# 9) 

