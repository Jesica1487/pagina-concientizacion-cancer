function mostrarSeccion(id) {
    document.querySelectorAll('.seccion').forEach(sec => {
        sec.classList.remove('activa');
        sec.classList.remove('fade-in');
    });
    const seccion = document.getElementById(id);
    seccion.classList.add('activa');
    setTimeout(() => seccion.classList.add('fade-in'), 10);
}

// Animación contador
function animarContador(id, valorFinal, duracion) {
    const el = document.getElementById(id);
    let inicio = 0;
    const incremento = Math.ceil(valorFinal / (duracion / 20));
    const intervalo = setInterval(() => {
        inicio += incremento;
        if (inicio >= valorFinal) {
            inicio = valorFinal;
            clearInterval(intervalo);
        }
        el.textContent = inicio;
    }, 20);
}

// Tip del día aleatorio
const tips = [
    "Realizá el autoexamen mamario una vez al mes.",
    "Consultá a tu médico ante cualquier cambio.",
    "La detección temprana salva vidas.",
    "Acompañá y escuchá a quienes lo necesitan.",
    "Compartí información confiable sobre prevención.",
    "No postergues tus controles médicos."
];
function mostrarTipDelDia() {
    const tip = tips[Math.floor(Math.random() * tips.length)];
    document.getElementById('tip-dia').textContent = tip;
}

// Testimonios con foto (puedes agregar más en el HTML)
const testimonios = [
    {
        nombre: "Ana, Córdoba",
        texto: "Nunca imaginé la fuerza que tenía hasta que la vida me puso a prueba. Hoy celebro cada día.",
        foto: "testimonio1.jpg"
    },
    {
        nombre: "Laura, Buenos Aires",
        texto: "El apoyo de mi familia y amigas fue fundamental. No estás sola.",
        foto: "testimonio2.jpg"
    }
];
function mostrarTestimonios() {
    const contenedor = document.getElementById('testimonios-con-foto');
    contenedor.innerHTML = '';
    testimonios.forEach(t => {
        const div = document.createElement('div');
        div.className = 'testimonio-foto';
        div.innerHTML = `
            <img src="${t.foto}" alt="${t.nombre}">
            <blockquote>${t.texto}</blockquote>
            <span>${t.nombre}</span>
        `;
        contenedor.appendChild(div);
    });
}

// Ejecutar al cargar
window.addEventListener('DOMContentLoaded', () => {
    mostrarTipDelDia();
    animarContador('contador-apoyo', 1245, 1200); // Número ejemplo
    mostrarTestimonios();
});

document.getElementById('form-contacto').addEventListener('submit', function(e) {
    e.preventDefault();
    document.getElementById('mensaje-exito').classList.remove('oculto');
    this.reset();
});
