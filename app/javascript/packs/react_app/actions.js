export const SORT_BY = 'SORT_BY'
export const SET_APPS = 'SET_APPS'
export const FILTER_BY = 'FILTER_BY'
import Api from './api_client'

export function sortBy(attribute) {
  return { type: SORT_BY, attribute }
}

export function filterBy(attribute, value) {
  return { type: FILTER_BY, attribute, value }
}

export function setApps(apps) {
  return { type: SET_APPS, apps }
}

export function fetchApps(discount_limit) {
  return dispatch => {
     Api.fetch({ discount_limit: discount_limit })
    .then((res) => {
      console.log('succ');
      console.log(res);
      dispatch(setApps(res.data.products))
    }).catch(console.log.bind(console))
  };
}

export const SORT_ORDERS = { ASC: -1, DESC: 1 }

export const SORT_OPTIONS = {
  DISCOUNT: 'DISCOUNT',
  NAME: 'NAME',
  PRICE: 'PRICE',
  RATING: 'RATING'
}

export const SORT_ATTRIBUTE = {
  DISCOUNT: 'discount_ratio',
  NAME: 'name',
  PRICE: 'current_price',
  RATING: 'average_user_rating'
}
