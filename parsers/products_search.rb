require 'cgi'

data = JSON.parse(content)
scrape_url_nbr_products = data['results'][0]['nbHits'].to_i
current_page = data['results'][0]['page'].to_i
page_size = data['results'][0]['hitsPerPage'].to_i
number_of_pages = data['results'][0]['nbPages'].to_i
products = data['results'][0]['hits']


# if ot's first page , generate pagination
if current_page == 0 and number_of_pages>1
  nbr_products_pg1 = page_size
  step_page = 1
  while step_page < number_of_pages
    pages << {
        page_type: 'products_search',
        method: 'POST',
        url: page['url'],
        body:page['vars']['post_params'].gsub(/page=0/,"page=#{step_page}"),
        vars: {
            'input_type' => page['vars']['input_type'],
            'search_term' => page['vars']['search_term'],
            'page' => step_page,
            'nbr_products_pg1' => nbr_products_pg1
        }
    }

    step_page = step_page + 1


  end
elsif current_page == 0 and number_of_pages==1
  nbr_products_pg1 = page_size
else
  nbr_products_pg1 = page['vars']['nbr_products_pg1']
end


products.each_with_index do |product, i|

  promotion = product['promotions'][0]['savings_text'] rescue ''
  availability = product['inStockQuantity'].to_i == 0 ? '' : '1'
  item_size_info = product['size']

  price = product['price']

  category = product['groupCategoryNamePath'][/([^\/]+?)\Z/]

  description = product['description'].gsub(/[\n\s]+/, ' ').gsub(/,/, '.') rescue ''


  regexps = [
      /(\d*[\.,]?\d+)\s?([Ff][Ll]\.?\s?[Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Oo][Zz])/,
      /(\d*[\.,]?\d+)\s?([Ff][Oo])/,
      /(\d*[\.,]?\d+)\s?([Ee][Aa])/,
      /(\d*[\.,]?\d+)\s?([Ff][Zz])/,
      /(\d*[\.,]?\d+)\s?(Fluid Ounces?)/,
      /(\d*[\.,]?\d+)\s?([Oo]unce)/,
      /(\d*[\.,]?\d+)\s?([Mm][Ll])/,
      /(\d*[\.,]?\d+)\s?([Cc][Ll])/,
      /(\d*[\.,]?\d+)\s?([Ll])/,
      /(\d*[\.,]?\d+)\s?([Gg])/,
      /(\d*[\.,]?\d+)\s?([Ll]itre)/,
      /(\d*[\.,]?\d+)\s?([Ss]ervings)/,
      /(\d*[\.,]?\d+)\s?([Pp]acket\(?s?\)?)/,
      /(\d*[\.,]?\d+)\s?([Cc]apsules)/,
      /(\d*[\.,]?\d+)\s?([Tt]ablets)/,
      /(\d*[\.,]?\d+)\s?([Tt]ubes)/,
      /(\d*[\.,]?\d+)\s?([Cc]hews)/,
      /(\d*[\.,]?\d+)\s?([Mm]illiliter)/i,
  ]
  regexps.find {|regexp| item_size_info =~ regexp}
  item_size = $1
  uom = $2


  regexps = [
      /(\d+)\s?[xX]/,
      /Pack of (\d+)/,
      /Box of (\d+)/,
      /Case of (\d+)/,
      /(\d+)\s?[Cc]ount/,
      /(\d+)\s?[Cc][Tt]/,
      /(\d+)[\s-]?Pack($|[^e])/,
      /(\d+)[\s-]pack($|[^e])/,
      /(\d+)[\s-]?[Pp]ak($|[^e])/,
      /(\d+)[\s-]?Tray/,
      /(\d+)\s?[Pp][Kk]/,
      /(\d+)\s?([Ss]tuks)/i,
      /(\d+)\s?([Pp]ak)/i,
      /(\d+)\s?([Pp]ack)/i,
  ]
  regexps.find {|regexp| item_size_info =~ regexp}
  in_pack = $1
  in_pack ||= '1'


  product_details = {
      # - - - - - - - - - - -
      RETAILER_ID: '101',
      RETAILER_NAME: 'mat',
      GEOGRAPHY_NAME: 'SE',
      # - - - - - - - - - - -
      SCRAPE_INPUT_TYPE: page['vars']['input_type'],
      SCRAPE_INPUT_SEARCH_TERM: page['vars']['search_term'],
      SCRAPE_INPUT_CATEGORY: page['vars']['input_type'] == 'taxonomy' ? category : '-',
      SCRAPE_URL_NBR_PRODUCTS: scrape_url_nbr_products,
      # - - - - - - - - - - -
      SCRAPE_URL_NBR_PROD_PG1: nbr_products_pg1,
      # - - - - - - - - - - -
      PRODUCT_BRAND: product['displayBrand'],
      PRODUCT_RANK: i + 1,
      PRODUCT_PAGE: current_page + 1,
      PRODUCT_ID: product['id'],
      PRODUCT_NAME: product['combinedNameWithBrand'],
      EAN: product['ean'],
      PRODUCT_DESCRIPTION: description,
      PRODUCT_MAIN_IMAGE_URL: product['imageUrl'],
      PRODUCT_ITEM_SIZE: item_size,
      PRODUCT_ITEM_SIZE_UOM: uom,
      PRODUCT_ITEM_QTY_IN_PACK: in_pack,
      SALES_PRICE: price,
      IS_AVAILABLE: availability,
      PROMOTION_TEXT: promotion,
      EXTRACTED_ON: Time.now.to_s,

  }
  product_details['_collection'] = 'products'


  outputs << product_details


end

