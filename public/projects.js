// When the window loads - do all this work to set the page up.
window.onload = () => {

  // Setup the helper to show the filename that you uploaded
  const blend_file_input = document.getElementById('blend_file');
  blend_file_input.addEventListener('change', (event) => showFileName(event));

  function showFileName(event) {

    // Get label where the file name will be displayed.
    const infoArea = document.getElementById('blend_file_name');

    // Get the file input where a new file was selected.
    const input = event.srcElement;
    const fileName = input.files[0].name;

    // Change the label to display the file name.
    infoArea.textContent = 'File chosen: ' + fileName;
  }
};