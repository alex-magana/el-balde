class Seed
  def roles_list
    [
      { role_name: "ADMIN" },
      { role_name: "N_USER" }
    ]
  end

  def users_list
    [
      {
        first_name: "Mary",
        last_name: "Littel",
        email: "flavie@schmitt.co",
        password_digest: "anewpassword",
        role_id: "2"
      }
    ]
  end

  def authentications_list
    [
      {
        token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9."\
          "eyJ1c2VyX2lkIjoxLCJleHAiOjE0ODA1MTY5MDksImlzcy"\
          "I6ImVsLWJhbGRlIiwiYXVkIjoiY2xpZW50In0.Z8HmWxxXHkSvL2D2"\
          "mNxm-RZIMmc8DFyDyFeUeLR8huQ",
        user_id: "1",
        status: "false"
      }
    ]
  end

  def bucket_lists_list
    [
      { name: "3 poles Challenge", user_id:	"1" },
      { name: "Seven summits Challenge", user_id: "1" },
      { name: "8000m Mountains", user_id: "1" },
      { name: "Africa Peaks Challenge", user_id: "1" },
      { name: "Watson Laboratories Challenge",	user_id: "1" },
      { name: "Washington Homeopathic Products",	user_id: "1" },
      { name: "SHISEIDO AMERICA INC.",	user_id: "1" },
      { name: "Bryant Ranch Prepack",	user_id: "1" },
      { name: "Perrigo New York Inc",	user_id: "1" },
      { name: "ANI Pharmaceuticals, Inc.",	user_id: "1" },
      { name: "Bausch & Lomb Incorporated",	user_id: "1" },
      { name: "Contract Pharmacy Services-PA",	user_id: "1" },
      { name: "Bryant Ranch Prepack",	user_id: "1" },
      { name: "Deseret Biologicals, Inc.",	user_id: "1" },
      { name: "Qualitest Pharmaceuticals",	user_id: "1" },
      { name: "Kroger Company",	user_id: "1" },
      { name: "Dr. Reddy's Laboratories Inc",	user_id: "1" }
    ]
  end

  def bucket_list_items_list
    [
      { name: "North pole", done:	false, bucket_list_id: "1" },
      { name: "South pole", done:	false, bucket_list_id: "1" },
      { name: "Everest", done:	false, bucket_list_id: "1" },
      { name: "Equator", done:	false, bucket_list_id: "1" },
      { name: "CVS Pharmacy", done:	false, bucket_list_id: "1" },
      { name: "HyVee Inc", done:	false, bucket_list_id: "1" },
      { name: "Apotheca Company", done:	false, bucket_list_id: "1" },
      { name: "Sagent Pharmaceuticals", done:	false, bucket_list_id: "1" },
      { name: "Rebel Distributors Corp.", done:	false, bucket_list_id: "1" },
      { name: "Dispensing Solutions, Inc.", done:	false, bucket_list_id: "1" },
      { name: "Amerisource Bergen", done:	false, bucket_list_id: "1" },
      { name: "Apotex Corp", done: false, bucket_list_id: "1" },
      { name: "Baxter Healthcare Corp.", done: false,	bucket_list_id: "1" },
      { name: "REMEDYREPACK INC.", done: false, bucket_list_id: "1" },
      { name: "Actavis Elizabeth LLC", done: false, bucket_list_id: "1" },
      { name: "Blacksmith Brands, Inc.", done: false, bucket_list_id: "1" },
      { name: "Mylan Institutional LLC", done: false, bucket_list_id: "1" },
      { name: "Kareway Product, Inc.", done: false, bucket_list_id: "2" },
      { name: "Apotheca Company", done:	false, bucket_list_id: "2" },
      { name: "Accudial Pharmaceutical", done: false, bucket_list_id: "2" },
      { name: "DZA Brands LLC", done: false, bucket_list_id: "2" },
      { name: "Aurobindo Pharma Ltd", done: false, bucket_list_id: "1" },
      { name: "Aidarex Pharmaceuticals", done: false, bucket_list_id: "3" },
      { name: "Sage Products LLC", done: false, bucket_list_id: "3" },
      { name: "Physicians Total Care", done: false, bucket_list_id: "3" },
      { name: "BJWC", done:	false, bucket_list_id: "3" },
      { name: "Ventura Corporation LTD.", done:	false, bucket_list_id: "3" },
      { name: "Walgreens", done: false, bucket_list_id: "3" },
      { name: "Allergy Laboratories, Inc.", done: false, bucket_list_id: "3" },
      { name: "Nelco Laboratories, Inc.", done: false, bucket_list_id: "3" },
      { name: "CHANEL PARFUMS BEAUTE", done: false, bucket_list_id: "3" },
      { name: "ALK-Abello, Inc.", done:	false, bucket_list_id: "3" },
      { name: "Roerig", done:	false, bucket_list_id: "3" },
      { name: "Roberts Oxygen Company", done: false, bucket_list_id: "1" },
      { name: "Natural Health Supply", done: false, bucket_list_id: "1" },
      { name: "Cardinal Health", done: false, bucket_list_id: "1" },
      { name: "Pharmaceutica North", done: false, bucket_list_id: "4" },
      { name: "Golden State Medical", done:	false, bucket_list_id: "4" },
      { name: "Jets, Sets, & Elephants", done: false, bucket_list_id: "4" },
      { name: "VENTURA INTERNATIONAL", done: false, bucket_list_id: "4" },
      { name: "REMEDYREPACK INC.", done: false, bucket_list_id: "4" },
      { name: "NATURE REPUBLIC CO.", done: false, bucket_list_id: "4" },
      { name: "Deseret Biologicals", done: false, bucket_list_id: "4" },
      { name: "Actavis Mid Atlantic", done: false, bucket_list_id: "4" },
    ]
  end

  def create_all
    roles_list.each { |role| Role.create(role) }
    users_list.each { |user| User.create(user) }
    authentications_list do |authentication|
      Authentication.create(authentication)
    end
    bucket_lists_list { |bucket_list| BucketList.create(bucket_list) }
    bucket_list_items_list do |bucket_list_item|
      BucketListItem.create(bucket_list_item)
    end
  end
end
