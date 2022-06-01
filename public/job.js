window.onload = () => {
  function udpateCarousel() {
    const opts = {
      follow: true,
      headers: {
        'Accept': 'application/json'
      }
    };

    const configEle = document.getElementById('job_config');
    const directory = configEle.getAttribute('data-directory');
  
    fetch(`/pun/sys/files/api/v1/fs/${directory}`, opts)
      .then(response => response.json())
      .then(data => data['files'])
      .then(files => files.map(file => file['name']))
      .then(files => files.filter(file => file.endsWith('png')))
      .then(files => {
        for(const file of files) {
          const id = `image_${file.replaceAll('.', '_')}`;
          const ele = document.getElementById(id);
  
          if(ele == null) {
            console.log(`adding ${file} to carousel`);
  
            const carousel = document.getElementById('blend_image_carousel_inner');
            const carouselList = document.getElementById('blend_image_carousel_indicators');
            const listSize = carouselList.children.length;
  
            const newImg = document.createElement('div')
            newImg.id = id;
            newImg.classList.add('carousel-item');
            newImg.innerHTML = `<img class="d-block w-100" src="/pun/sys/files/api/v1/fs/${directory}/${file}" >`;
  
            const newIndicator = document.createElement('li');
            newIndicator.setAttribute('data-target', '#blend_image_carousel');
            newIndicator.setAttribute('data-slide-to', listSize+1);
  
            const listSpan = document.getElementById('list_size');
            listSpan.innerHTML = `${listSize+1}`;
  
            if(listSize == 0) {
              newImg.classList.add('active');
              newIndicator.classList.add('active');
            }
  
            carousel.append(newImg);
            carouselList.append(newIndicator);
          }
        }
      });
  
    setTimeout(udpateCarousel, 5000);
  }
  
  udpateCarousel();
}

