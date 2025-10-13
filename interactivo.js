document.addEventListener('DOMContentLoaded', () => {
    mostrarTipDelDia();
    animarContador('contador-apoyo', 1245, 1200);
    mostrarTestimonios();
    configurarNavegacion();
    configurarFormulario();
});

function mostrarSeccion(id) {
    document.querySelectorAll('.seccion').forEach(sec => {
        sec.classList.remove('activa', 'fade-in');
    });

    const seccion = document.getElementById(id);
    if (seccion) {
        seccion.classList.add('activa');
        setTimeout(() => seccion.classList.add('fade-in'), 10);
    }
}

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
    const tipElemento = document.getElementById('tip-dia');
    if (tipElemento) {
        tipElemento.textContent = tip;
    }
}

const testimonios = [
    {
        nombre: "Ana, Córdoba",
        texto: "Nunca imaginé la fuerza que tenía hasta que la vida me puso a prueba. Hoy celebro cada día.",
        foto: "imagen1.jpg"
    },
    {
        nombre: "Laura, Buenos Aires",
        texto: "El apoyo de mi familia y amigas fue fundamental. No estás sola.",
        foto: "imagen6.jpg"
    }
];

function mostrarTestimonios() {
    const contenedor = document.getElementById('contenedor-testimonios');
    if (contenedor) {
        contenedor.innerHTML = '';
        testimonios.forEach(t => {
            const div = document.createElement('div');
            div.className = 'testimonio';
            div.innerHTML = `
                <img src="${t.foto}" alt="Testimonio de ${t.nombre}">
                <blockquote>"${t.texto}"</blockquote>
                <p class="nombre-testimonio">- ${t.nombre}</p>
            `;
            contenedor.appendChild(div);
        });
    }
}

function configurarNavegacion() {
    const botones = document.querySelectorAll('nav button');
    botones.forEach(boton => {
        const seccionId = boton.getAttribute('data-seccion');
        boton.addEventListener('click', () => mostrarSeccion(seccionId));
    });
}

function configurarFormulario() {
    const formulario = document.getElementById('form-contacto');
    const mensajeExito = document.getElementById('mensaje-exito');

    if (formulario && mensajeExito) {
        formulario.addEventListener('submit', function (e) {
            e.preventDefault();
            mensajeExito.classList.remove('oculto');
            formulario.reset();
            setTimeout(() => {
                mensajeExito.classList.add('oculto');
            }, 3000);
        });
    }
}

// Inserta/quita un iframe de YouTube en el contenedor indicado
function toggleEmbeddedVideo(videoId, containerId) {
    const container = document.getElementById(containerId);
    if (!container) return;
    const existing = container.querySelector('iframe');
    if (existing) {
        // quitar video
        container.innerHTML = '';
        container.classList.add('oculto');
        return;
    }
    // cerrar otros contenedores de video visibles
    document.querySelectorAll('.video-container').forEach(c => {
        if (c.id !== containerId) { c.innerHTML = ''; c.classList.add('oculto'); }
    });
    // crear iframe embebido (usar mute=1 para permitir autoplay tras interacción)
    const iframe = document.createElement('iframe');
    iframe.src = `https://www.youtube.com/embed/${videoId}?rel=0&autoplay=1&mute=1&modestbranding=1`;
    iframe.title = 'Video embebido';
    iframe.frameBorder = '0';
    iframe.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; autoplay';
    iframe.allowFullscreen = true;
    iframe.loading = 'lazy';
    container.innerHTML = '';
    container.appendChild(iframe);
    container.classList.remove('oculto');
}

// Registrar listeners para los botones de video (asegura que existan)
document.addEventListener('DOMContentLoaded', () => {
    const btnInfo = document.getElementById('mostrar-video-info');
    if (btnInfo) {
        btnInfo.addEventListener('click', () => {
            const vid = btnInfo.getAttribute('data-video-id');
            toggleEmbeddedVideo(vid, 'info-video');
        });
    }

    const btnMas = document.getElementById('mostrar-video-mas');
    if (btnMas) {
        btnMas.addEventListener('click', () => {
            const vid = btnMas.getAttribute('data-video-id');
            toggleEmbeddedVideo(vid, 'historias-mas-video');
        });
    }
});
