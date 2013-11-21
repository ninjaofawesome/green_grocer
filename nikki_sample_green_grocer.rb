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

counts = count_cart_items(ITEMS)
# update a constant called ITEMS
update_cart_counts(ITEMS, counts)
# update a constant called COUP
update_coupons_for_clearance_discount

debugger
puts 'hi'