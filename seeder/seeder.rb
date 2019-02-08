require 'cgi'

search_terms = ['Red Bull', 'RedBull', 'Energidryck', 'Energidrycker']
search_post_params =  '{"requests":[{"indexName":"Prod_Product_5","params":"query=search_term&optionalFacetFilters=%5B%22featuredProductSearchTerm%3Asearch_term%22%5D&hitsPerPage=12&maxValuesPerFacet=40&page=0&getRankingInfo=false&facets=%5B%22categories.id%22%2C%22categories.lineageIds%22%2C%22labelTags.tag%22%2C%22displayBrand%22%2C%22_tags%22%2C%22id%22%2C%22tagNames%22%5D&tagFilters=ACTIVE%2C-SAMPLE"}]}'
search_terms.each do |search_term|

  pages << {
      page_type: 'products_search',
      method: 'POST',
      url: api_url,
      body:search_post_params.gsub(/search_term/,CGI.escape(search_term)),
      vars: {
          'input_type' => 'search',
          'search_term' => search_term,
          'page' => 1,
          'post_params'=>search_post_params.gsub(/query=query/,"query=#{search_term}")
      }


  }

end