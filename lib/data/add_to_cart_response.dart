class AddToCartResponse {
  final String productId;
  int count;

  AddToCartResponse(this.productId, this.count);

  AddToCartResponse.fromObject(Map<String, dynamic> json)
      : productId = json['product_id'],
        count = json['count'];
}
