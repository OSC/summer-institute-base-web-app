window.onload = () => {

    // Shows file name
    const blend_file_input = document.getElementById('blend_file');
    blend_file_input.addEventListener('change', (event) => showFileName(event));
  
    function showFileName(event) {
      const info_area = document.getElementById('blend_file_name');
  
      const input = event.srcElement;
      const file_name = input.files[0].name;
  
      info_area.textContent = 'File chosen: ' + file_name;
    }
  };