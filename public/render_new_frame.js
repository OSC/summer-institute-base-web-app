// When the window loads - do all this work to set the page up.
window.onload = () => {

  // Get the file input.
  const input = document.getElementById('blend_file');

  // Detect when a new file is selected.
  input.addEventListener('change', (event) => showFileName(event));

  // Function to change the file name label when a new file is selected.
  function showFileName(e) {


    // Get label where the file name will be displayed.
    const infoArea = document.getElementById('blend_file_name');

    // Get the file input where a new file was selected.
    const input = e.srcElement;

    // Get the name of the first file in the input.
    const fileName = input.files[0].name;

    // Change the label to display the file name.
    infoArea.textContent = 'File chosen: ' + fileName;
  }
};
