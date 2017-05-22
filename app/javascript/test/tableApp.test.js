import tableApp from './../packs/react_app/table_app'
import configureMockStore from 'redux-mock-store'
import thunk from 'redux-thunk'
import { setApps } from './../packs/react_app/actions'

const middlewares = [thunk]
const mockStore = configureMockStore(middlewares)

const initialState = {
  sortBy: 'DISCOUNT',
  sortOrder: 1,
  apps: []
}

const store = mockStore(initialState)

test('initial state is no apps', () => {
  expect(store.getState().apps.length).toBe(0);
});


test('setting apps sets them', () => {
  const newState = tableApp(store.getState(), setApps([1,2,3,4]))
  expect(newState.apps.length).toBe(4);
});




