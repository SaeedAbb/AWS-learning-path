// Smooth scrolling for navigation links
document.addEventListener('DOMContentLoaded', function() {
    const links = document.querySelectorAll('a[href^="#"]');
    
    links.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                targetSection.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
    
    // Add scroll effect to header
    const header = document.querySelector('header');
    let lastScroll = 0;
    
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll > 100) {
            header.style.boxShadow = '0 4px 6px rgba(0,0,0,0.1)';
        } else {
            header.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
        }
        
        lastScroll = currentScroll;
    });
    
    // Simple page view tracking (in production, use proper analytics)
    console.log('Page loaded:', new Date().toISOString());
    console.log('Page:', window.location.pathname);
});