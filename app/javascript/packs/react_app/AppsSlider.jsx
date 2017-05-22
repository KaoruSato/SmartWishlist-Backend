import React, { Component } from 'react'
import AppItem from './AppItem'
import Api from './api_client'

class AppsSlider extends Component {
  constructor(props) {
    super()
    this.state = {
      apps: []
    }
  }

  componentDidMount() {
    Api.fetch().then((res) => {
      this.setState({
        apps: res.data.products
      })
      $('.js-slider').slick({
        prevArrow: '.js-prev-slide',
        nextArrow: '.js-next-slide',
        draggable: false,
        swipe: false,
        infinite: true,
        slidesToShow: 3,
        autoplay: true,
        autoplaySpeed: 4000,
        responsive: [{
          breakpoint: 1024,
          settings: {
            slidesToShow: 2,
          }
        },
        {
          breakpoint: 600,
          settings: {
            slidesToShow: 1,
          }
        }
      ]
      })
    }).catch(console.log.bind(console))
  }

  render() {
    return (
      <div>
        <div className='js-slider slider'>
          { this.state.apps.map(app => {
            return <AppItem key={app.id} app={app}/>
          })}
        </div>
        <div className="btn-group" role="group" aria-label="...">
          <span className="btn btn-primary js-prev-slide">Prev</span>
          <a href="/discounts" className="btn btn-default no-underline">See all discounts <span className="badge badge-danger">{this.state.apps.length}</span></a>
          <span className="btn btn-primary js-next-slide">Next</span>
        </div>
      </div>
    )
  }
}

export default AppsSlider
