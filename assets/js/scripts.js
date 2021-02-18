var body = document.querySelector('body');
var menuTrigger = document.querySelector('#toggle-main-menu-mobile');
var menuContainer = document.querySelector('#main-menu-mobile');
var copyToClipboardButton = document.querySelector('button.copy');
var header = document.querySelector('.header');
var logo = document.querySelector('.logo');
var logoJS = document.querySelector('.logo-js');
var logoIntro = document.querySelector('.logo-intro');
var hamburgerInner = document.querySelector('.hamburger-inner');
var happyUserLogos = document.querySelectorAll('.js-happy-users-logo');
var numberOfLogos = 6;

if(body.classList.contains('page-home')) {
  window.addEventListener('scroll', (event) => {
    if (event.target.scrollingElement.scrollTop > 5) {
      if (!(header.classList.contains('is-sticky'))) {
        header.classList.add('is-sticky');
        logoIntro.classList.add('is-sticky');
        logo.classList.add('is-sticky');
        hamburgerInner.classList.add('is-sticky');
        logoJS.src = '/images/logo.svg';
      }
    } else {
      header.classList.remove('is-sticky');
      logoIntro.classList.remove('is-sticky');
      logo.classList.remove('is-sticky');
      hamburgerInner.classList.remove('is-sticky');
      logoJS.src = '/images/home/hero/keptn-logo-white.svg';
    }
  });

  window.addEventListener('DOMContentLoaded', function () {
    new Splide('.splide', {
      perPage: 2,
      perMove: 1,
      height: '380px',
      focus: 'center',
      drag: true,
      type: 'loop',
      breakpoints: {
        992: {
          perPage: 1,
          drag: true,
          type: 'loop',
          padding: {
            right: '1.5rem',
            left: '1.5rem',
          },
        },
      },
    }).mount();

    for (var randomLogoNumbers = [], i = 0; i < numberOfLogos; ++i) randomLogoNumbers[i] = i+1;
    shuffle(randomLogoNumbers);
    var counter = 0;
    happyUserLogos.forEach(logo => {
      logo.src = '/images/home/happy-users/logos/logo-' + randomLogoNumbers[counter] +  '.png';
      counter = ++counter;
    });
  });
} else {
  logoJS.src = '/images/logo.svg';
}

/**
 * Shuffles array in place. ES6 version
 * @param {Array} a items An array containing the items.
 */
function shuffle(a) {
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a;
}

if (menuTrigger) {
  menuTrigger.onclick = function () {
    menuContainer.classList.toggle('open');
    menuTrigger.classList.toggle('is-active');
    document.documentElement.classList.toggle('lock-scroll');
    body.classList.toggle('lock-scroll');
  }
}

