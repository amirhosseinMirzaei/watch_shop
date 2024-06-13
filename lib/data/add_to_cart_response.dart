class AddToCartResponse {
  final int productId;
  final int count;

  AddToCartResponse(this.productId, this.count);

  AddToCartResponse.fromJson(Map<String, dynamic> json)
      : productId = json['product_id'],
        count = json['count'];
}
