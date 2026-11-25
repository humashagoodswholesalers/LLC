export const company = {
  name: 'Humasha Goods Wholesalers LLC',
  tagline: 'Your trusted partner in global industrial & construction supply',
  intro: 'Humasha Goods Wholesalers LLC specializes in supplying goods according to project and industry requirements, sourcing products from around the world. Established in June 2021, we support projects, industries, contractors and traders with a wide range of materials and equipment.',
  slogan: 'EARN TRUST WITH BUSINESS',
  mission: 'Our mission is to offer our customers the finest quality and best selection of products with the quickest service for project and industry requirements.',
  vision: 'To serve customers through exceptional international standards of service and make the company a market leader.',
  goal: 'Customer satisfaction is our ultimate goal. We are committed to providing products at the right time and at the right place.',
  objective: 'To become one of the leading market-share holders in a highly competitive global market.',
  strategy: 'To be the preferred goods supplier to international customers through the support and confidence of our experienced team.',
  address: 'P.O. Box 96234, Dubai, UAE',
  phones: ['+971 54 2656668', '+971 503576026', '+971 521548061'],
  founded: 'June 2021'
};
export const seed = {
  products: [
    ['Building Materials & Construction Materials','Building and construction supply','https://images.unsplash.com/photo-1504307651254-35680f356dfd?auto=format&fit=crop&w=900&q=80'],
    ['Sandwich Panel','Insulated panel solutions for project requirements','https://images.unsplash.com/photo-1511818966892-d7d671e672a2?auto=format&fit=crop&w=900&q=80'],
    ['Fasteners','Industrial fastening products and accessories','https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=900&q=80'],
    ['Fire Equipment','Fire safety equipment and related supplies','https://images.unsplash.com/photo-1581092580497-e0d23cbdf1dc?auto=format&fit=crop&w=900&q=80'],
    ['Chemical Items','Chemical products for industrial requirements','https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?auto=format&fit=crop&w=900&q=80'],
    ['DWT Tools','Tools and equipment for professional applications','https://images.unsplash.com/photo-1504148455328-c376907d081c?auto=format&fit=crop&w=900&q=80'],
    ['EPDM Rubber Items','EPDM rubber products and components','https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=900&q=80'],
    ['HDPE Pipe & Fittings','HDPE pipes and fittings for project supply','https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=900&q=80'],
    ['Valves & Electrical Items','Valves and electrical items for industry','https://images.unsplash.com/photo-1581092921461-eab62e97a780?auto=format&fit=crop&w=900&q=80']
  ].map((x,i)=>({id:`demo-p${i}`,name:x[0],description:x[1],image_url:x[2],published:true})),
  projects: [
    {id:'demo-pr1',name:'Ruppur Nuclear Power Plant Project',description:'Listed among the major projects in the company profile.',location:'Bangladesh',image_url:'https://images.unsplash.com/photo-1513828583688-c52646e5e3e8?auto=format&fit=crop&w=1200&q=80',published:true},
    {id:'demo-pr2',name:'Padma Bridge Project',description:'Listed among the major projects in the company profile.',location:'Bangladesh',image_url:'https://images.unsplash.com/photo-1473448912268-2022ce9509d8?auto=format&fit=crop&w=1200&q=80',published:true}
  ],
  clients: ['The Civil Engineers Ltd.','Paharpur Cooling Tower Ltd.','Karnaphuli Fertilizer Company Limited','Energy Pack Engineer Ltd.','Bangladesh Atomic Energy Commission','Primo BD','Rosemount BD','Equipment Care'].map((name,i)=>({id:`demo-c${i}`,name,description:'Valued client',image_url:'',published:true})),
  testimonials: [],
  services: ['Industrial Material Supply','Construction Material Supply','Project-Based Procurement','Global Product Sourcing','Building Material Distribution','Industrial Tools & Equipment Supply'].map((name,i)=>({id:`demo-s${i}`,name,description:'Sourcing and supply support tailored to project and industry requirements.',published:true}))
};
