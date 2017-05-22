import axios from 'axios'
const DATA_URL = $('.data-source').data("api-url") + "/api/promotions"
const DISCOUNT_LIMIT = 20

const ApiClient = {
  fetch: (opts = { discount_limit: DISCOUNT_LIMIT }) => {
    return axios.get(DATA_URL, {
      params: {
        discounted_by: opts.discount_limit
      }
    })
  }
}

export default ApiClient
