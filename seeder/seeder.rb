
api_url =  "https://hv77zjg5js-dsn.algolia.net/1/indexes/*/queries?x-algolia-agent=Algolia%20for%20vanilla%20JavaScript%203.32.0&x-algolia-application-id=HV77ZJG5JS&x-algolia-api-key=341b3805a05cef630a2ae8f1619600a4"
taxonomy_post_params =  '{"requests":[{"indexName":"Prod_Product_5_campaign","params":"query=&hitsPerPage=12&maxValuesPerFacet=40&page=0&getRankingInfo=false&facets=%5B%22categories.id%22%2C%22categories.lineageIds%22%2C%22labelTags.tag%22%2C%22displayBrand%22%2C%22_tags%22%2C%22id%22%2C%22tagNames%22%5D&tagFilters=ACTIVE%2C-SAMPLE&facetFilters=%5B%22categories.lineageIds%3A4250%22%5D"}]}'
    pages << {
    page_type: 'products_search',
    method: 'POST',
    url: api_url,
    body: taxonomy_post_params,
    vars: {
        'input_type' => 'taxonomy',
        'search_term' => '-',
        'post_params'=>taxonomy_post_params,
        'page' => 1
    }


}