require 'cgi'
api_url =  "https://hv77zjg5js-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%203.32.0&x-algolia-application-id=HV77ZJG5JS&x-algolia-api-key=341b3805a05cef630a2ae8f1619600a4"

search_terms = ['Energidryck']
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