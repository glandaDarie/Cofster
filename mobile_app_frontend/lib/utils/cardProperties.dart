import 'package:coffee_orderer/enums/coffeeTypes.dart' show CoffeeType;

Map<CoffeeType, String> coffeeImagePaths = {
  CoffeeType.cortado: "assets/images/coffee_cortado.png",
  CoffeeType.americano: "assets/images/coffee_americano.png",
  CoffeeType.cappuccino: "assets/images/coffee_cappuccino.png",
  CoffeeType.latteMachiatto: "assets/images/coffee_latte_machiatto.png",
  CoffeeType.flatWhite: "assets/images/coffee_flat_white.png",
  CoffeeType.coldEspresso: "assets/images/coffee_espresso.png",
  CoffeeType.mocha: "assets/images/coffee_mocha.png",
  CoffeeType.coldBrew: "assets/images/coffee_cold_brew.png",
  CoffeeType.coretto: "assets/images/coffee_coretto.png",
  CoffeeType.irishCoffee: "assets/images/coffee_irish_coffee.png"
};

Map<CoffeeType, String> coffeeNames = {
  CoffeeType.cortado: "Cortado",
  CoffeeType.americano: "Americano",
  CoffeeType.cappuccino: "Cappuccino",
  CoffeeType.latteMachiatto: "Latte Machiatto",
  CoffeeType.flatWhite: "Flat white",
  CoffeeType.coldEspresso: "Cold Espresso",
  CoffeeType.mocha: "Mocha",
  CoffeeType.coldBrew: "Cold brew",
  CoffeeType.coretto: "Coretto",
  CoffeeType.irishCoffee: "Irish coffee"
};

Map<CoffeeType, String> coffeeDescription = {
  CoffeeType.cortado:
      "Bold espresso balanced with steamed milk for a harmonious flavor",
  CoffeeType.americano:
      "Bold and robust espresso combined with hot water for a strong and smooth flavor",
  CoffeeType.cappuccino:
      "Perfectly brewed espresso with silky steamed milk and frothy foam",
  CoffeeType.latteMachiatto:
      "Savor the beauty of rich latte gently layered with velvety steamed milk",
  CoffeeType.flatWhite:
      "Indulge in the simplicity of double shots of bold espresso harmoniously",
  CoffeeType.coldEspresso:
      "Embrace the essence of pure coffee perfection with an intense espresso",
  CoffeeType.mocha:
      "Delight in the irresistible fusion of robust espresso with velvety steamed milk",
  CoffeeType.coldBrew:
      "Discover the refreshing side of coffee with our meticulously smooth cold brew",
  CoffeeType.coretto:
      "Elevate your coffee experience with the pure combination of espresso artistry",
  CoffeeType.irishCoffee:
      "Embark on a journey to Ireland with the classic blend of rich, smooth coffee"
};

Map<CoffeeType, String> coffeePrices = {
  CoffeeType.cortado: "\$3.99",
  CoffeeType.americano: "\$4.49",
  CoffeeType.cappuccino: "\$4.99",
  CoffeeType.latteMachiatto: "\$5.49",
  CoffeeType.flatWhite: "\$5.99",
  CoffeeType.coldEspresso: "\$4.99",
  CoffeeType.mocha: "\$5.49",
  CoffeeType.coldBrew: "\$4.99",
  CoffeeType.coretto: "\$6.49",
  CoffeeType.irishCoffee: "\$5.99"
};
