// Force HTTPS
if (location.protocol !== 'https:' && location.hostname !== 'localhost') {
    location.replace(`https:${location.href.substring(location.protocol.length)}`);
}

// Load deployment time
async function loadDeploymentTime() {
    try {
        const response = await fetch('/js/deployment-info.json');
        const data = await response.json();
        
        if (data.timestamp) {
            const date = new Date(data.timestamp * 1000);
            const options = { 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            };
            document.getElementById('last-updated').textContent = 
                `Updated: ${date.toLocaleDateString('en-US', options)}`;
        } else {
            document.getElementById('last-updated').textContent = 'Recently';
        }
    } catch (error) {
        console.log('Using current time for deployment info');
        const now = new Date();
        document.getElementById('last-updated').textContent = 
            `Updated: ${now.toLocaleDateString()} ${now.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'})}`;
    }
}

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('fade-in');
            observer.unobserve(entry.target);
        }
    });
}, observerOptions);

// Observe all sections for animations
document.querySelectorAll('section').forEach(section => {
    observer.observe(section);
});

// Smooth scrolling
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const targetId = this.getAttribute('href');
        if (targetId === '#') return;
        
        const target = document.querySelector(targetId);
        if (target) {
            window.scrollTo({
                top: target.offsetTop - 80,
                behavior: 'smooth'
            });
        }
    });
});

// Header scroll effect
let lastScroll = 0;
const header = document.querySelector('header');

window.addEventListener('scroll', () => {
    const currentScroll = window.pageYOffset;
    
    if (currentScroll > 100) {
        header.style.background = 'rgba(255, 255, 255, 0.95)';
        header.style.backdropFilter = 'blur(20px)';
    } else {
        header.style.background = 'rgba(255, 255, 255, 0.85)';
        header.style.backdropFilter = 'blur(20px)';
    }
    
    // Hide/show header on scroll
    if (currentScroll > lastScroll && currentScroll > 100) {
        header.style.transform = 'translateY(-100%)';
    } else {
        header.style.transform = 'translateY(0)';
    }
    
    lastScroll = currentScroll;
});

// Screenshot carousel navigation
const screenshotContainer = document.querySelector('.screenshots-container');
let isDragging = false;
let startX;
let scrollLeft;

screenshotContainer.addEventListener('mousedown', (e) => {
    isDragging = true;
    startX = e.pageX - screenshotContainer.offsetLeft;
    scrollLeft = screenshotContainer.scrollLeft;
    screenshotContainer.style.cursor = 'grabbing';
});

screenshotContainer.addEventListener('mouseleave', () => {
    isDragging = false;
    screenshotContainer.style.cursor = 'grab';
});

screenshotContainer.addEventListener('mouseup', () => {
    isDragging = false;
    screenshotContainer.style.cursor = 'grab';
});

screenshotContainer.addEventListener('mousemove', (e) => {
    if (!isDragging) return;
    e.preventDefault();
    const x = e.pageX - screenshotContainer.offsetLeft;
    const walk = (x - startX) * 2;
    screenshotContainer.scrollLeft = scrollLeft - walk;
});

// Initialize
document.addEventListener('DOMContentLoaded', () => {
    loadDeploymentTime();
    
    // Add initial animation class to hero
    document.querySelector('.hero-content').classList.add('fade-in');
    
    // Set cursor for screenshot container
    screenshotContainer.style.cursor = 'grab';
    
    // Add hover effect to cards
    document.querySelectorAll('.feature-card, .developer-card').forEach(card => {
        card.addEventListener('mouseenter', () => {
            card.style.transform = 'translateY(-10px)';
        });
        card.addEventListener('mouseleave', () => {
            card.style.transform = 'translateY(0)';
        });
    });
});

// Download counter animation
async function updateDownloadCount() {
    try {
        const response = await fetch('/api/downloads');
        const data = await response.json();
        const countElement = document.getElementById('download-count');
        if (countElement && data.count) {
            animateCount(countElement, data.count);
        }
    } catch (error) {
        console.log('Download count not available');
    }
}

function animateCount(element, target) {
    let current = 0;
    const increment = target / 100;
    const timer = setInterval(() => {
        current += increment;
        if (current >= target) {
            current = target;
            clearInterval(timer);
        }
        element.textContent = Math.floor(current).toLocaleString();
    }, 20);
}