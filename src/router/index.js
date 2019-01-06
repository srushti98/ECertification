import Vue from 'vue'
import Router from 'vue-router'
import Dashboard from '@/components/Dashboard'
import IssuerPage from '@/components/IssuerPage'
import RecipientPage from '@/components/RecipientPage'
import EventsPage from '@/components/EventsPage'
import CertPage from '@/components/CertPage'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'dashboard',
      component: Dashboard
    },
    {
      path: '/issuerPage',
      name: 'issuerPage',
      component: IssuerPage
    },
    {
      path: '/recipientPage',
      name: 'recipientPage',
      component: RecipientPage
    },
    {
      path: '/EventsPage',
      name: 'eventsPage',
      component: EventsPage
    },
    {
      path: '/certPage:ipfs/:time/:issure/:recipient/:ctype/:cname/:cdes',
      name: 'certPage',
      component: CertPage
    }
  ]
})
