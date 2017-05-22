import { SORT_BY, SET_APPS, FILTER_BY, SORT_ORDERS, SORT_OPTIONS, SORT_ATTRIBUTE } from "./actions"
import _ from "./utils"

const stateSortedBy = (attribute, state) => {
  let sortOrder = state.sortOrder

  if(state.sortBy == SORT_OPTIONS[attribute]) {
    sortOrder = sortOrder * -1;
  }

  const app_attribute = SORT_ATTRIBUTE[attribute]

  const sortingFunction = (app1, app2) => {
    if(app1[app_attribute] < app2[app_attribute]) {
      return 1 * sortOrder
    } else if(app1[app_attribute] === app2[app_attribute]) {
      return _.compareBy('id')(app1, app2)
    } else {
      return -1 * sortOrder
    }
  }

  const apps = state.apps.sort(sortingFunction)
  const allApps = state.allApps.sort(sortingFunction)

  return {
    sortOrder: sortOrder,
    sortBy: attribute,
    allApps: allApps,
    apps: apps,
    filterBy: state.filterBy,
    filterValue: state.filterValue
  }
 }

const stateFilteredBy = (attribute, value, state) => {
  let filterBy = null
  let filterValue = null
  let apps = []

  if(value == false || value == undefined || value.length == 0) {
    filterBy = null
    filterValue = null
    apps = state.allApps
  } else {
    apps = state.allApps.filter((app) => {
      return _.compressString(app[attribute]).includes(_.compressString(value))
    })
    filterBy = attribute
    filterValue = value
  }

  return {
    sortOrder: state.sortOrder,
    sortBy: state.attribute,
    allApps: state.allApps,
    apps: apps,
    filterBy: filterBy,
    filterValue: filterValue
  }
}

const initialState = {
  sortBy: 'DISCOUNT',
  sortOrder: 1,
  allApps: [],
  apps: [],
  filterBy: null,
  filterValue: null
}

function tableApp(state = initialState, action) {
  switch(action.type) {
    case SORT_BY:
      return stateSortedBy(action.attribute, state)
    case FILTER_BY:
      return stateFilteredBy(action.attribute, action.value, state)
    case SET_APPS:
      return {
        sortOrder: state.sortOrder,
        sortBy: state.sortBy,
        allApps: action.apps,
        apps: action.apps,
        filterBy: null,
        filterValue: null
      }
    default:
      return state
  }
}

export default tableApp
