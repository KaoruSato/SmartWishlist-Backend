import React, { Component } from 'react'
import _ from "./utils"

const APP_STORE_BUTTON = $('.data-source').data("appstore-button")

const AppItem = ({app}) => (
  <div className='media app-card' >
    <a href={ "discounts/" + app.slug } className='media-left'>
      <img className='media-object round app-icon' src={app.icon_url} alt={ app.name + " icon" }></img>
    </a>
    <div className='media-body'>
      <h4 className='media-heading media-left'><a href={ "discounts/" + app.slug } className='label label-primary app-name'> { _.truncate(app.name, 30) } </a></h4>
      <div>
        <div className='media-left app-details'>
          <div className="btn-group" role="group">
            <div className="btn btn-default no-click">Now { app.current_price_formatted }</div>
            <div className="btn btn-default no-click">from { app.base_price_formatted }</div>
          </div>
        </div>
        <a href={app.store_url} target="_blank">
          <img src={APP_STORE_BUTTON} alt={ "Download discounted '" + app.name + "' on the iOS App Store" } className='store-btn' width='100px'></img>
        </a>
        <div className="btn btn-default btn-sm left bottom-btn rating-btn no-click">
          <span className='glyphicon glyphicon-star'></span>
          { app.average_user_rating_formatted + " (" + app.user_rating_count_formatted + ")" }
        </div>
        <div className="btn btn-danger btn-sm left bottom-btn no-click">
          -{ app.discount_ratio }%
        </div>
      </div>
    </div>
  </div>
);

export default AppItem
