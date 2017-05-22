import React, { Component } from 'react'
import AppItem from './AppItem'
import _ from "./utils"
import { connect } from 'react-redux'
import { sortBy, filterBy, fetchApps, SORT_ORDERS, SORT_OPTIONS, SORT_ATTRIBUTE } from "./actions"

const mapStateToProps = (state, ownProps) => {
  return {
    apps: state.apps,
    sortBy: state.sortBy,
    sortOrder: state.sortOrder
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    onClickSortBy: (attribute) => {
      return () => {
        dispatch(sortBy(attribute))
      }
    },
    onAppNameEnter: () => {
      return (event) => {
        dispatch(filterBy('name', event.target.value))
      }
    },
    componentDidMount: () => {
      dispatch(fetchApps(20))
    }
  }
}

const Aux = _.Aux

const SortOrder = ({order}) => {
  if(order == -1) {
    return <span className='glyphicon glyphicon-menu-up'></span>
  } else {
    return <span className='glyphicon glyphicon-menu-down'></span>
  }
}

class AppsTable extends Component {
  componentDidMount() {
    this.props.componentDidMount()
  }

  render() {
    return (
      <Aux>
        <div className='top-20'>
          <span className="btn btn-default no-click">Sort by <SortOrder order={this.props.sortOrder}/></span>
          <div className='bottom-5'></div>
          <div className="btn-group" role="group">
            <span className={ "btn " + ((this.props.sortBy == SORT_OPTIONS.DISCOUNT || this.props.sortBy == undefined)  ? 'btn-primary' : 'btn-default') }onClick={ this.props.onClickSortBy(SORT_OPTIONS.DISCOUNT) } >Discount</span>
            <span className={ "btn " + (this.props.sortBy == SORT_OPTIONS.NAME ? 'btn-primary' : 'btn-default') } onClick={ this.props.onClickSortBy(SORT_OPTIONS.NAME) } >Name</span>
            <span className={ "btn " + (this.props.sortBy == SORT_OPTIONS.PRICE ? 'btn-primary' : 'btn-default') } onClick={ this.props.onClickSortBy(SORT_OPTIONS.PRICE) }>Price</span>
            <span className={ "btn " + (this.props.sortBy == SORT_OPTIONS.RATING ? 'btn-primary' : 'btn-default') } onClick={ this.props.onClickSortBy(SORT_OPTIONS.RATING) } >Rating</span>
          </div>
          <div className="text-center input-group col-centered">
            <input type="text" className="form-control app-name-input" placeholder="App name" onChange= { this.props.onAppNameEnter() }></input>
          </div>

          <div className='top-20'>
            { this.props.apps.map(app => {
              return <AppItem key={app.id} app={app}/>
            })}
          </div>
        </div>
        <div className='bottom-20 clear'></div>
      </Aux>
    )
  }
}

const ConnectedAppsTable = connect(
  mapStateToProps,
  mapDispatchToProps
)(AppsTable)

export default ConnectedAppsTable
