var API_ENDPOINT = "https://8gvz6b88e8.execute-api.us-east-2.amazonaws.com/my_stage";

const fileInput = document.getElementById("dni-upload");
const previewImg = document.getElementById("preview");
const submitBtn = document.getElementById("saveregister");
const statusMessage = document.getElementById("statusMessage");

fileInput.addEventListener("change", () => {
  const file = fileInput.files[0];
  if (!file) {
    previewImg.style.display = "none";
    submitBtn.disabled = true;
    statusMessage.textContent = "";
    return;
  }

  // Mostrar preview
  previewImg.src = URL.createObjectURL(file);
  previewImg.style.display = "block";

  // Habilitar botón
  submitBtn.disabled = false;
  statusMessage.textContent = "";
});

submitBtn.addEventListener("click", () => {
  const file = fileInput.files[0];
  if (!file) {
    alert("Please upload your DNI image first.");
    return;
  }

  submitBtn.disabled = true;
  statusMessage.style.color = "black";
  statusMessage.textContent = "Uploading...";

  const reader = new FileReader();
  reader.onloadend = () => {
    const base64Image = reader.result;

    const inputData = { image: base64Image };

    $.ajax({
      url: API_ENDPOINT,
      type: "POST",
      data: JSON.stringify(inputData),
      contentType: "application/json; charset=utf-8",
      success: (response) => {
        statusMessage.style.color = "green";
        statusMessage.textContent = "Register Data Saved!";
        submitBtn.disabled = false;
      },
      error: () => {
        statusMessage.style.color = "red";
        statusMessage.textContent = "Error saving register data.";
        submitBtn.disabled = false;
      },
    });
  };

  reader.readAsDataURL(file);
});

