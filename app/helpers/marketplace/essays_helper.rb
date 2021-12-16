module Marketplace::EssaysHelper
  def pricing_table_data
    {
        "1-2"   => 4,
        "3-5"   => 9,
        "6-15"  => 13,
        "16-25" => 18,
        "26-35" => 23,
        "36-50" => 27,
        "50+"   => 40
    }.to_a
  end
end
