document.addEventListener('DOMContentLoaded', () => {
    // ─── Mobile Nav Toggle ───
    const navToggle = document.getElementById('nav-toggle');
    const mainNav = document.getElementById('main-nav');
    if (navToggle && mainNav) {
        navToggle.addEventListener('click', () => {
            mainNav.classList.toggle('open');
        });
        // Close on link click
        mainNav.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', () => mainNav.classList.remove('open'));
        });
    }

    // ─── Hero Phone Screenshot Carousel ───
    const screenshots = document.querySelectorAll('.phone-screenshot');
    const dots = document.querySelectorAll('.phone-dot');
    let currentSlide = 0;
    let autoInterval;

    function showSlide(index) {
        screenshots.forEach(s => s.classList.remove('active'));
        dots.forEach(d => d.classList.remove('active'));
        currentSlide = index;
        if (screenshots[index]) screenshots[index].classList.add('active');
        if (dots[index]) dots[index].classList.add('active');
    }

    function nextSlide() {
        showSlide((currentSlide + 1) % screenshots.length);
    }

    function startAuto() {
        autoInterval = setInterval(nextSlide, 3500);
    }

    dots.forEach(dot => {
        dot.addEventListener('click', () => {
            clearInterval(autoInterval);
            showSlide(parseInt(dot.dataset.index));
            startAuto();
        });
    });

    if (screenshots.length > 0) {
        startAuto();
    }

    // ─── Scroll Reveal Animations ───
    const revealElements = document.querySelectorAll(
        '.feature-card, .screenshot-item, .download-card, .stat, .section-intro'
    );

    // Add the reveal class
    revealElements.forEach(el => el.classList.add('reveal'));

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                // Stagger children of the same parent
                const parent = entry.target.parentElement;
                const siblings = parent ? Array.from(parent.querySelectorAll('.reveal')) : [];
                const idx = siblings.indexOf(entry.target);
                const delay = idx >= 0 ? idx * 80 : 0;

                setTimeout(() => {
                    entry.target.classList.add('visible');
                }, delay);

                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.15,
        rootMargin: '0px 0px -40px 0px'
    });

    revealElements.forEach(el => observer.observe(el));

    // ─── Header scroll shadow ───
    const header = document.getElementById('header');
    let lastScroll = 0;
    window.addEventListener('scroll', () => {
        const scrollY = window.scrollY;
        if (scrollY > 60) {
            header.style.borderBottomColor = 'rgba(255,255,255,0.08)';
        } else {
            header.style.borderBottomColor = 'rgba(255,255,255,0.06)';
        }
        lastScroll = scrollY;
    }, { passive: true });

    // ─── Smooth anchor scroll offset for fixed header ───
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const targetId = this.getAttribute('href');
            if (targetId === '#') return;
            const target = document.querySelector(targetId);
            if (target) {
                e.preventDefault();
                const top = target.getBoundingClientRect().top + window.scrollY - 90;
                window.scrollTo({ top, behavior: 'smooth' });
            }
        });
    });
});
