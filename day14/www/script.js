window.addEventListener("scroll", function() {
    const sections = document.querySelectorAll(".glass");

    sections.forEach(section => {
        const position = section.getBoundingClientRect().top;
        const screenHeight = window.innerHeight;

        if (position < screenHeight - 100) {
            section.style.opacity = 1;
            section.style.transform = "translateY(0)";
        }
    });
});