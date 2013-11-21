require 'debugger'
ITEMS = [  {"AVOCADO" => {:price => 3.00, :clearance_items => true}},
    {"AVOCADO" => {:price => 3.00, :clearance_items => true}},
    {"KALE" => {:price => 3.00,:clearance_items => false}},
    {"KALE" => {:price => 3.00,:clearance_items => false}},
    {"BLACK_BEANS" => {:price => 2.50,:clearance_items => false}},
    {"ALMONDS" => {:price => 9.00, :clearance_items => false}},
    {"TEMPEH" => {:price => 3.00,:clearance_items => true}},
    {"CHEESE" => {:price => 6.50,:clearance_items => false}},
    {"BEER" => {:price => 13.00, :clearance_items => false}},
    {"PEANUTBUTTER" => {:price => 3.00,:clearance_items => true}},
    {"BEETS" => {:price => 2.50,:clearance_items => false}}]

COUPS = [  {:item=>"AVOCADO", :num=>2, :cost=>5.00},
    {:item=>"BEER", :num=>2, :cost=>20.00},
    {:item=>"CHEESE", :num=>3, :cost=>15.00}]

#randomly generates set of coupons
def generate_coupons
  # UPDATE a constant called COUPS with updated discounts for those on clearance
  update_coupons_for_clearance_discount
  coups = []
  rand(2).times do
    coups.push(COUPS.sample)
  end
  update_coupons_for_triple_discount(coups) if coups.size == 2
  coups
end

# APPLY THE COUPONS

#changes price for couponed items
def coupon_items(cart, coupons)
  return 0 if coupons.nil?
  cost = 0
  cart.each do |item|
    # items {"AVOCADO"=>{:price=>3.0, :clearance_items=>true, :count=>2}}
    item.each do |name, attributes|
      # name is "AVOCADO", an attributes is {:price=>3.0, :clearance_items=>true, :count=>2}
      coupons.each do |coupon|
        # coupon => {:item=>"AVOCADO", :num=>2, :cost=>5.00}
        # we want to make sure we have the minimum number of the food to apply the coupon
        if name == coupon[:item] && attributes[:count] >= coupon[:num]
          # add the item to our total cost
          cost += coupon[:cost]
          # so we've paid for the number of items reflected in the coupon
          attributes[:count] = attributes[:count] - coupon[:num]
          # so if we started with 3 avocados, wed now have 1 in the cart, and 2 paid for
        end
      end
    end
  end
  cost
end

# RULE
##if any of the items are on clearance_items add a 20% discount

#updates coupons to reflect discount
def update_coupons_for_clearance_discount
  COUPS.each do |coupon|
    # coupon => {:item=>"AVOCADO", :num=>2, :cost=>5.00}
    ITEMS.each do |items|
      # items {"AVOCADO"=>{:price=>3.0, :clearance_items=>true, :count=>2}}
      items.each do |name, attributes|
        coupon[:cost] = coupon[:cost] * 0.8 if coupon[:item] == name && attributes[:clearance_items] == true
      end
    end
  end
end

# all were doing here is counting the items in the cart, and creating
# a hash that tracks the names of the items ,and their counts
def count_cart_items(cart)
  counts = {}
  cart.each do |item|
    # {"AVOCADO" => {:price => 3.00, :clearance_items => true}}
    item.each do |name, attributes|
      # "AVOCADO", {:price => 3.00, :clearance_items => true}
      counts[name] = cart.select{|other_item| other_item == item}.size
    end
  end
  counts
end

# update the cart, so that each item has its count in the cart
# and remove and duplicate items in the cart
def update_cart_counts(cart, counts)
  cart.uniq!
  cart.each do |item|
    # {"AVOCADO"=>{:price=>3.0, :clearance_items=>true}}
    item.each do |name, attributes|
      # key is "AVOCADO", value is {:price=>3.0, :clearance_items=>true}
      # counts is {"AVOCADO"=>2, "KALE"=>2, "BLACK_BEANS"=>1, "ALMONDS"=>1, "TEMPEH"=>1, "CHEESE"=>1, "BEER"=>1, "PEANUTBUTTER"=>1, "BEETS"=>1}
      counts.each do |item2, number|
        # item2 should be "AVOCADO", and number should be 2
        attributes[:count] = number if item2 == name
      end
    end
  end
end

#gives clearance_items discount
def clearance_items(cart, cost)
  # for items on clearance we're going to apply a 20 percent discount
  cart.each do |item|
    item.each do |name, attribute|
      if attribute[:clearance]
        # price * quantity, get the discount, add to our total cost, and mark
        # the item as paid for by setting the count to 0
        cost += (attribute[:price] * attribute[:count]) * 0.8
        attribute[:count] = 0
      end
    end
  end
  cost
end

#gives cost of normal items
def full_price_items(cart, cost)
  cart.each do |item|
    item.each do |name,attribute|
      cost += (attribute[:price] * attribute[:count])
    end
  end
  cost
end

#gives cost of normal items
def full_price_items(cart, cost)
  cart.each do |item|
    item.each do |name,attribute|
      cost += (attribute[:price] * attribute[:count])
    end
  end
  cost
end

generated_coupons = generate_coupons
counts = count_cart_items(ITEMS)
# update a constant called ITEMS
cart = update_cart_counts(ITEMS, counts)
cost = coupon_items(cart, generated_coupons)
cost = clearance_items(cart, cost)
cost = full_price_items(cart, cost)
debugger
puts 'hi'