import React from 'react'
import ReactDOM from 'react-dom'
import AppsSlider from './react_app/AppsSlider'
import AppsTable from './react_app/AppsTable'
import { createStore, applyMiddleware } from 'redux'
import { Provider } from 'react-redux'
import tableApp from './react_app/table_app'
import thunk from 'redux-thunk'

document.addEventListener('DOMContentLoaded', () => {
  const controller = $('.js-data').data('controller');
  const action = $('.js-data').data('action');

  if(controller == 'static_pages' && action == 'home') {
    ReactDOM.render(
      <AppsSlider />,
      document.getElementById('react-slider'),
    )
  }

  if(controller == 'discounts' && action == 'index') {
    let store = createStore(
      tableApp,
      applyMiddleware(thunk)
    )

    ReactDOM.render(
      <Provider store={store}>
        <AppsTable />
      </Provider>,
      document.getElementById('react-table'),
    )
  }
})
