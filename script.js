document.addEventListener('DOMContentLoaded', () => {
    // 1. Button Interaction Script
    const btn = document.getElementById('actionBtn');
    const message = document.getElementById('message');

    if (btn && message) {
        btn.addEventListener('click', () => {
            // Click scaling effect
            btn.style.transform = 'scale(0.95) translateZ(40px)';
            setTimeout(() => {
                btn.style.transform = 'translateZ(40px)';
            }, 150);

            // Toggle element
            if (message.classList.contains('visible')) {
                message.classList.remove('visible');
                btn.textContent = 'Read Breaking Alert';
            } else {
                message.classList.add('visible');
                btn.textContent = 'Hide Alert';
            }
        });
    }

    // 2. 3D Tilt Effect applied dynamically to all glass cards
    const cards = document.querySelectorAll('.glass-card');
    
    // We only apply this complex 3D tracking on devices that support hover (not mobile touch devices generally)
    if (window.matchMedia("(hover: hover)").matches) {
        cards.forEach(card => {
            card.addEventListener('mousemove', (e) => {
                // Get purely localized coordinates based on the card itself
                const rect = card.getBoundingClientRect();
                const x = e.clientX - rect.left;
                const y = e.clientY - rect.top;
                
                const centerX = rect.width / 2;
                const centerY = rect.height / 2;
                
                // Calculate rotation (more constrained for smaller cards)
                const rotateX = ((y - centerY) / centerY) * -10;
                const rotateY = ((x - centerX) / centerX) * 10;
                
                card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
            });

            card.addEventListener('mouseleave', () => {
                card.style.transform = 'perspective(1000px) rotateX(0deg) rotateY(0deg)';
                card.style.transition = 'transform 0.5s ease';
                
                setTimeout(() => {
                    card.style.transition = '';
                }, 500);
            });
        });
    }
});
