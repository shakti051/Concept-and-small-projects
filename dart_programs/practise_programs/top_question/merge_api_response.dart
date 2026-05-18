

void main() {
  final products = [
    {"id": 1, "name": "Laptop"},
    {"id": 2, "name": "Phone"},
  ];

  final prices = [
    {"id": 1, "price": 50000},
    {"id": 2, "price": 20000},
  ];
 
  var priceMap = {};
  for (var item in prices) {
    priceMap[item["id"]]=item["price"];
  
  }
  print(priceMap);
 final merged = products.map((product){
  return{
    ...product,"price":priceMap[product["id"]]
  };
 }).toList();


  print(merged);
}
