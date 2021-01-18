var body = document.querySelector('body');
var menuTrigger = document.querySelector('#toggle-main-menu-mobile');
var menuContainer = document.querySelector('#main-menu-mobile');
var copyToClipboardButton = document.querySelector('button.copy');
var header = document.querySelector('.header');
var logo = document.querySelector('.logo');
var logoIntro = document.querySelector('.logo-intro');

window.addEventListener('DOMContentLoaded', function () {
  new Splide('.splide', {
    perPage: 2,
    perMove: 1,
    height: '380px',
    focus: 'center',
    drag: true,
    breakpoints: {
      992: {
        perPage: 1,
        drag: true,
        type: 'loop',
        padding: {
          right: '3rem',
          left: '2rem',
        },
      },
    },
  }).mount();
});

window.addEventListener('scroll', (event) => {
  if (event.target.scrollingElement.scrollTop > 5) {
    if (!(header.classList.contains('is-sticky'))) {
      header.classList.add('is-sticky');
      logoIntro.classList.add('is-sticky');
      logo.classList.add('is-sticky');
    }
  } else {
    header.classList.remove('is-sticky');
    logoIntro.classList.remove('is-sticky');
    logo.classList.remove('is-sticky');
  }
});

if (menuTrigger) {
  menuTrigger.onclick = function () {
    menuContainer.classList.toggle('open');
    menuTrigger.classList.toggle('is-active');
    document.documentElement.classList.toggle('lock-scroll');
    body.classList.toggle('lock-scroll');
  }
}

if (TypeIt) {
  var instance = new TypeIt('#typeit-editor', {
    speed: 100,
    startDelay: 900,
  })
    .type('<span class="command">keptn install</span>')
    .break()
    .break()
    .pause(500)
    .options({ speed: 0 })
    .type('Deploying keptn installer pod...')
    .break()
    .pause(100)
    .type('Installer pod deployed successfully.')
    .break()
    .pause(100)
    .type('Starting installation of keptn ...')
    .pause(500)
    .break()
    .type('keptn installed successfully!')
    .pause(2000)
    .empty()
    .options({ speed: 100 })
    .type('<span class="command">keptn create project myservice myshipyard.yaml</span>')
    .break()
    .break()
    .pause(500)
    .options({ speed: 0 })
    .type('Creating Git repositories for dev, staging and production')
    .break()
    .pause(500)
    .type('Creating k8s namespaces for dev, staging and production')
    .break()
    .pause(500)
    .type('Creating and storing configuration for your DevOps tooling')
    .break()
    .pause(2000)
    .empty()
    .options({ speed: 100 })
    .type('<span class="command">keptn onboard service myservice</span>')
    .break()
    .break()
    .pause(500)
    .options({ speed: 0 })
    .type('Updating configuration for your DevOps tooling')
    .pause(500)
    .break()
    .type('Keptn now ready to receive your artifacts for this service')
    .pause(2000)
    .options({ speed: 100 })
    .break()
    .break()
    .type('<span class="command">keptn new artifact myservice:1.0</span>')
    .break()
    .break()
    .pause(500)
    .options({ speed: 0 })
    .type('Updating configuration for myservice:1.0')
    .pause(500)
    .break()
    .type('Keptn now starting to ship your artifact')
    .pause(800)
    .break()
    .type('Artifact shipped and ready to use')
    .pause(2000)
    .go();
}
