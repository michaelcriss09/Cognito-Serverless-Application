var API_ENDPOINT = "https://7b86fl6s9c.execute-api.us-east-2.amazonaws.com/my_stage";

let currentUserId = null;

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

    previewImg.src = URL.createObjectURL(file);
    previewImg.style.display = "block";

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

                currentUserId = response.userId;

                statusMessage.style.color = "green";
                statusMessage.textContent = "Register Data Saved!";
                submitBtn.disabled = false;

                document.getElementById('surname').value = response.surname || "";
                document.getElementById('lastname').value = response.last_name || "";
                document.getElementById('country').value = response.Country || "";
                document.getElementById('birthdate').value = response.born_date || "";

                setTimeout(() => {
                    document.getElementById("upload-container").style.display = "none";
                    document.getElementById("profile-container").style.display = "flex";
                }, 1000);
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

document.getElementById("generateForm").onclick = function() {
    if (!currentUserId) {
        alert("No userId found. Please upload and save your profile first.");
        return;
    }

    const surname = document.getElementById('surname').value.trim();
    const lastname = document.getElementById('lastname').value.trim();
    const country = document.getElementById('country').value.trim();
    const birthdate = document.getElementById('birthdate').value;

    if (!surname || !lastname || !country || !birthdate) {
        alert('Please fill out all fields.');
        return;
    }

    const updateData = {
        surname: surname,
        last_name: lastname,
        Country: country,
        born_date: birthdate,
        userId: currentUserId 
    };

    $.ajax({
        url: API_ENDPOINT,
        type: 'PUT',
        data: JSON.stringify(updateData),
        contentType: 'application/json; charset=utf-8',
        success: function(response) {
            alert('Profile updated successfully!');
        },
        error: function() {
            alert('Error updating profile.');
        }
    });
}
