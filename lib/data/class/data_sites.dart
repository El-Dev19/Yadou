class Sites {
  final String name;
  final String description;
  final String price;
  final String etoile;
  final String lieu;
  String nom_searchable;
  final List<String> imageUrls;
  bool isFavorite;

  Sites({
    required this.name,
    required this.description,
    required this.price,
    required this.etoile,
    required this.lieu,
    required this.nom_searchable,
    required this.imageUrls,
    this.isFavorite = false,
  });
}

List<Sites> sitesTouristiques = [
  Sites(
    name: 'ROOM',
    price: '\$400',
    etoile: '4.5',
    lieu: 'Iles de Loos',
    nom_searchable: 'ROOM',
    description:
        "L'île de Room, située dans l'archipel des îles de Loos au large de Conakry en Guinée, est une île de taille modeste mais riche en histoire et en beauté naturelle. Elle est connue pour ses plages de sable doré, ses eaux claires, et ses paysages verdoyants. Room est un lieu paisible où les visiteurs peuvent profiter de la nature, se baigner, ou encore faire de petites randonnées pour découvrir la végétation luxuriante.Autrefois, l'île a joué un rôle important dans le commerce colonial et porte encore les traces de cette époque, avec quelques vestiges de bâtiments historiques. Les habitants, pour la plupart pêcheurs, sont accueillants et offrent un aperçu de la vie locale et de la culture guinéenne.",
    imageUrls: [
      'https://img.freepik.com/photos-gratuite/photo-aerienne-maisons-construites-au-dessus-mer-terre-arbres-aux-maldives_181624-3473.jpg?uid=R146568229&ga=GA1.1.1987036454.1721222001&semt=ais_hybrid'
    ],
  ),
  Sites(
    name: 'Bel Air',
    price: '\$250',
    etoile: '5.0',
    description:
        "La plage de Bel Air, située sur la côte atlantique de la Guinée, est réputée pour son sable blanc étendu, ses eaux claires et son atmosphère paisible. Cette plage est un lieu prisé pour la détente, avec des cocotiers qui offrent des zones d'ombre naturelles le long du rivage. Les vagues y sont souvent douces, ce qui permet de s’y baigner en toute tranquillité. En plus de sa beauté naturelle, Bel Air est entourée de petites structures d'accueil où les visiteurs peuvent déguster des plats locaux et se ressourcer. C'est une destination idéale pour une escapade relaxante.",
    lieu: 'Iles de Loos',
    nom_searchable: 'Bel Air',
    imageUrls: [
      'https://img.freepik.com/photos-gratuite/outdoor-parasol-chaise_74190-2386.jpg?uid=R146568229&ga=GA1.1.1987036454.1721222001&semt=ais_hybrid'
    ],
  ),
  Sites(
    name: 'Cascade Soumba',
    price: '\$250',
    etoile: '5.0',
    description:
        "La cascade de Soumba, située près de la ville de Dubréka à environ une heure de Conakry, est l'une des merveilles naturelles de la Guinée. Elle se distingue par ses chutes d'eau rafraîchissantes qui descendent en plusieurs paliers et créent de petits bassins parfaits pour la baignade. Entourée d'une végétation tropicale dense, la cascade offre un cadre paisible et enchanteur, idéal pour les amateurs de nature et de détente. C'est un lieu prisé pour les pique-niques, les randonnées et la découverte de la beauté naturelle guinéenne dans un environnement serein.",
    lieu: 'Iles de Loos',
    nom_searchable: 'Cascade Soumba',
    imageUrls: [
      'https://img.freepik.com/photos-gratuite/china-natural-jungle-park-vietnam-summer_1417-1108.jpg?uid=R146568229&ga=GA1.1.1987036454.1721222001&semt=ais_hybrid'
    ],
  ),
  Sites(
    name: 'Barrage Kinkon',
    price: '\$250',
    etoile: '5.0',
    description:
        "Le barrage de Kinkon, situé près de la ville de Pita en Moyenne Guinée, est un impressionnant ouvrage hydraulique entouré de paysages spectaculaires. Construit sur le fleuve Kinkon, il alimente en énergie plusieurs régions voisines. Les chutes de Kinkon, formées par le débit de l'eau du barrage, sont parmi les plus hautes et les plus belles cascades de Guinée, avec une hauteur d'environ 80 mètres. Ces chutes plongent dans une vallée verdoyante, offrant un spectacle à la fois puissant et apaisant. Le site est apprécié pour sa beauté naturelle et constitue un lieu d'excursion prisé pour les amateurs de nature, les randonneurs et les photographes.",
    lieu: 'Iles de Loos',
    nom_searchable: 'Barrage Kinkon',
    imageUrls: [
      'https://img.freepik.com/photos-gratuite/beau-paysage-montagne-par-journee-ensoleillee_23-2149063215.jpg?uid=R146568229&ga=GA1.1.1987036454.1721222001&semt=ais_hybrid'
    ],
  ),
  Sites(
    name: 'Iles De Cassa',
    description:
        "L'île de Cassa, située dans l'archipel des îles de Loos au large de Conakry, est une petite île paisible et peu fréquentée, ce qui en fait un lieu idéal pour ceux qui recherchent la tranquillité. Elle est connue pour ses plages de sable fin et ses eaux cristallines, parfaites pour la baignade et la plongée. L'île est entourée de végétation tropicale et offre de belles vues sur l'océan Atlantique. Cassa est aussi un lieu de vie pour les pêcheurs locaux, permettant aux visiteurs de découvrir un aperçu authentique de la culture guinéenne dans un cadre naturel préservé.",
    price: '\$250',
    etoile: '5.0',
    lieu: 'Iles de Loos',
    nom_searchable: 'Iles De Cassa',
    imageUrls: [
      'https://img.freepik.com/photos-gratuite/vue-aerienne-belle-petite-ile-verte-au-milieu-ocean_181624-2038.jpg?uid=R146568229&ga=GA1.1.1987036454.1721222001&semt=ais_hybrid'
    ],
  ),
];
