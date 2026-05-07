// Social Sharing Integration System

class SocialSharing {
    constructor() {
        this.shareData = {
            title: '',
            description: '',
            url: window.location.href,
            image: '',
            hashtags: ['KurdishTourism', 'VisitKurdistan', 'ExploreKurdistan']
        };
    }

    // Initialize sharing for a location
    initLocationSharing(location) {
        this.shareData = {
            title: location.name_ku || location.name_en,
            description: this.truncateText(location.description_ku || location.description_en || '', 150),
            url: `${window.location.origin}?location=${location.id}`,
            image: location.image_path || '',
            hashtags: ['KurdishTourism', 'VisitKurdistan', 'ExploreKurdistan', location.name_ku?.replace(/\s+/g, '')]
        };
    }

    // Share on Facebook
    shareOnFacebook() {
        const url = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(this.shareData.url)}&quote=${encodeURIComponent(this.shareData.description)}`;
        this.openShareWindow(url, 'facebook');
    }

    // Share on Twitter/X
    shareOnTwitter() {
        const text = `${this.shareData.title} - ${this.shareData.description}`;
        const url = `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(this.shareData.url)}&hashtags=${encodeURIComponent(this.shareData.hashtags.join(','))}`;
        this.openShareWindow(url, 'twitter');
    }

    // Share on Instagram (Note: Instagram doesn't support direct URL sharing, so we copy to clipboard)
    shareOnInstagram() {
        const shareText = `${this.shareData.title}\n\n${this.shareData.description}\n\n${this.shareData.url}\n\n${this.shareData.hashtags.map(tag => '#' + tag).join(' ')}`;
        
        if (navigator.clipboard) {
            navigator.clipboard.writeText(shareText).then(() => {
                this.showNotification('Instagram share text copied to clipboard! Open Instagram and paste in your story or post.', 'success');
                setTimeout(() => {
                    window.open('https://www.instagram.com/', '_blank');
                }, 1000);
            }).catch(() => {
                this.fallbackCopyToClipboard(shareText);
            });
        } else {
            this.fallbackCopyToClipboard(shareText);
        }
    }

    // Share on WhatsApp
    shareOnWhatsApp() {
        const text = `${this.shareData.title} - ${this.shareData.description}\n${this.shareData.url}`;
        const url = `https://wa.me/?text=${encodeURIComponent(text)}`;
        this.openShareWindow(url, 'whatsapp');
    }

    // Share on Telegram
    shareOnTelegram() {
        const url = `https://t.me/share/url?url=${encodeURIComponent(this.shareData.url)}&text=${encodeURIComponent(this.shareData.title + ' - ' + this.shareData.description)}`;
        this.openShareWindow(url, 'telegram');
    }

    // Share via email
    shareViaEmail() {
        const subject = encodeURIComponent(this.shareData.title);
        const body = encodeURIComponent(`I thought you might be interested in this location in Kurdistan:\n\n${this.shareData.title}\n\n${this.shareData.description}\n\n${this.shareData.url}\n\n${this.shareData.hashtags.map(tag => '#' + tag).join(' ')}`);
        window.location.href = `mailto:?subject=${subject}&body=${body}`;
    }

    // Copy link to clipboard
    copyLink() {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(this.shareData.url).then(() => {
                this.showNotification('Link copied to clipboard!', 'success');
            }).catch(() => {
                this.fallbackCopyToClipboard(this.shareData.url);
            });
        } else {
            this.fallbackCopyToClipboard(this.shareData.url);
        }
    }

    // Generate QR code for sharing
    generateQRCode() {
        const qrContainer = document.getElementById('qr-code-container');
        if (!qrContainer) return;

        // Clear existing QR code
        qrContainer.innerHTML = '';

        // Use QRCode.js library or create a simple QR code placeholder
        const qrImage = document.createElement('img');
        qrImage.src = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${encodeURIComponent(this.shareData.url)}`;
        qrImage.alt = 'QR Code';
        qrImage.style.width = '200px';
        qrImage.style.height = '200px';
        
        qrContainer.appendChild(qrImage);
        
        // Show QR code modal
        this.showQRCodeModal();
    }

    // Show QR code modal
    showQRCodeModal() {
        const modal = document.createElement('div');
        modal.className = 'qr-modal';
        modal.innerHTML = `
            <div class="qr-modal-content">
                <div class="qr-modal-header">
                    <h3>Share via QR Code</h3>
                    <button class="close-btn" onclick="this.closest('.qr-modal').remove()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="qr-modal-body">
                    <div id="qr-code-container"></div>
                    <p>Scan this QR code to share the location</p>
                    <button onclick="socialSharing.copyLink()" class="btn btn-secondary">
                        <i class="fas fa-copy"></i> Copy Link
                    </button>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Generate QR code
        this.generateQRCode();
    }

    // Open share window
    openShareWindow(url, platform) {
        const width = platform === 'facebook' ? 600 : 550;
        const height = platform === 'facebook' ? 400 : 420;
        const left = (window.screen.width - width) / 2;
        const top = (window.screen.height - height) / 2;
        
        window.open(url, 'share', `width=${width},height=${height},left=${left},top=${top},resizable=yes,scrollbars=yes`);
        
        // Track share event
        this.trackShare(platform);
    }

    // Fallback copy to clipboard
    fallbackCopyToClipboard(text) {
        const textArea = document.createElement('textarea');
        textArea.value = text;
        textArea.style.position = 'fixed';
        textArea.style.left = '-999999px';
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        
        try {
            document.execCommand('copy');
            this.showNotification('Text copied to clipboard!', 'success');
        } catch (err) {
            this.showNotification('Failed to copy text', 'error');
        }
        
        document.body.removeChild(textArea);
    }

    // Track share event
    trackShare(platform) {
        // Send analytics data
        if (typeof gtag !== 'undefined') {
            gtag('event', 'share', {
                method: platform,
                content_type: 'location',
                item_id: this.shareData.url
            });
        }
        
        // Track in your own analytics
        this.sendShareAnalytics(platform);
    }

    // Send share analytics to your server
    async sendShareAnalytics(platform) {
        try {
            await fetch('api.php?endpoint=share_analytics', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    platform,
                    url: this.shareData.url,
                    title: this.shareData.title,
                    timestamp: new Date().toISOString()
                })
            });
        } catch (error) {
            console.error('Failed to track share:', error);
        }
    }

    // Show notification
    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `social-notification social-notification-${type}`;
        notification.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : 'info-circle'}"></i>
            <span>${message}</span>
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    }

    // Truncate text
    truncateText(text, maxLength) {
        if (text.length <= maxLength) return text;
        return text.substring(0, maxLength) + '...';
    }

    // Create share buttons UI
    createShareButtons(containerId, location = null) {
        const container = document.getElementById(containerId);
        if (!container) return;

        if (location) {
            this.initLocationSharing(location);
        }

        container.innerHTML = `
            <div class="social-sharing">
                <h4>Share this location</h4>
                <div class="share-buttons">
                    <button onclick="socialSharing.shareOnFacebook()" class="share-btn facebook" title="Share on Facebook">
                        <i class="fab fa-facebook-f"></i>
                    </button>
                    <button onclick="socialSharing.shareOnTwitter()" class="share-btn twitter" title="Share on Twitter">
                        <i class="fab fa-twitter"></i>
                    </button>
                    <button onclick="socialSharing.shareOnInstagram()" class="share-btn instagram" title="Share on Instagram">
                        <i class="fab fa-instagram"></i>
                    </button>
                    <button onclick="socialSharing.shareOnWhatsApp()" class="share-btn whatsapp" title="Share on WhatsApp">
                        <i class="fab fa-whatsapp"></i>
                    </button>
                    <button onclick="socialSharing.shareOnTelegram()" class="share-btn telegram" title="Share on Telegram">
                        <i class="fab fa-telegram"></i>
                    </button>
                    <button onclick="socialSharing.shareViaEmail()" class="share-btn email" title="Share via Email">
                        <i class="fas fa-envelope"></i>
                    </button>
                    <button onclick="socialSharing.generateQRCode()" class="share-btn qrcode" title="Generate QR Code">
                        <i class="fas fa-qrcode"></i>
                    </button>
                    <button onclick="socialSharing.copyLink()" class="share-btn copy" title="Copy Link">
                        <i class="fas fa-link"></i>
                    </button>
                </div>
            </div>
        `;
    }

    // Create floating share button
    createFloatingShareButton(location = null) {
        const button = document.createElement('button');
        button.className = 'floating-share-btn';
        button.innerHTML = '<i class="fas fa-share-alt"></i>';
        button.title = 'Share location';
        
        button.addEventListener('click', () => {
            this.showShareModal(location);
        });
        
        document.body.appendChild(button);
        
        // Show/hide based on scroll
        let lastScrollY = window.scrollY;
        window.addEventListener('scroll', () => {
            if (window.scrollY > 200 && window.scrollY > lastScrollY) {
                button.classList.add('visible');
            } else {
                button.classList.remove('visible');
            }
            lastScrollY = window.scrollY;
        });
    }

    // Show share modal
    showShareModal(location = null) {
        if (location) {
            this.initLocationSharing(location);
        }

        const modal = document.createElement('div');
        modal.className = 'share-modal';
        modal.innerHTML = `
            <div class="share-modal-content">
                <div class="share-modal-header">
                    <h3>Share ${this.shareData.title}</h3>
                    <button class="close-btn" onclick="this.closest('.share-modal').remove()">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
                <div class="share-modal-body">
                    <div class="share-preview">
                        ${this.shareData.image ? `<img src="${this.shareData.image}" alt="${this.shareData.title}">` : ''}
                        <div class="share-preview-text">
                            <h4>${this.shareData.title}</h4>
                            <p>${this.shareData.description}</p>
                        </div>
                    </div>
                    <div class="share-buttons-grid">
                        <button onclick="socialSharing.shareOnFacebook()" class="share-btn facebook">
                            <i class="fab fa-facebook-f"></i>
                            <span>Facebook</span>
                        </button>
                        <button onclick="socialSharing.shareOnTwitter()" class="share-btn twitter">
                            <i class="fab fa-twitter"></i>
                            <span>Twitter</span>
                        </button>
                        <button onclick="socialSharing.shareOnInstagram()" class="share-btn instagram">
                            <i class="fab fa-instagram"></i>
                            <span>Instagram</span>
                        </button>
                        <button onclick="socialSharing.shareOnWhatsApp()" class="share-btn whatsapp">
                            <i class="fab fa-whatsapp"></i>
                            <span>WhatsApp</span>
                        </button>
                        <button onclick="socialSharing.shareOnTelegram()" class="share-btn telegram">
                            <i class="fab fa-telegram"></i>
                            <span>Telegram</span>
                        </button>
                        <button onclick="socialSharing.shareViaEmail()" class="share-btn email">
                            <i class="fas fa-envelope"></i>
                            <span>Email</span>
                        </button>
                    </div>
                    <div class="share-actions">
                        <button onclick="socialSharing.copyLink()" class="btn btn-secondary">
                            <i class="fas fa-copy"></i> Copy Link
                        </button>
                        <button onclick="socialSharing.generateQRCode()" class="btn btn-primary">
                            <i class="fas fa-qrcode"></i> QR Code
                        </button>
                    </div>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Close modal on background click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
    }

    // Initialize native sharing (Web Share API)
    initNativeSharing(location = null) {
        if (!navigator.share) return false;

        if (location) {
            this.initLocationSharing(location);
        }

        const shareData = {
            title: this.shareData.title,
            text: this.shareData.description,
            url: this.shareData.url
        };

        navigator.share(shareData)
            .then(() => {
                this.trackShare('native');
            })
            .catch((error) => {
                console.log('Share canceled or failed:', error);
            });

        return true;
    }

    // Try native sharing first, fallback to modal
    share(location = null) {
        if (!this.initNativeSharing(location)) {
            this.showShareModal(location);
        }
    }
}

// Initialize Social Sharing
let socialSharing;

// Export for global use
window.SocialSharing = SocialSharing;
window.initSocialSharing = function() {
    socialSharing = new SocialSharing();
    return socialSharing;
};

window.shareLocation = function(location) {
    if (!socialSharing) {
        socialSharing = new SocialSharing();
    }
    socialSharing.share(location);
};

window.createShareButtons = function(containerId, location) {
    if (!socialSharing) {
        socialSharing = new SocialSharing();
    }
    socialSharing.createShareButtons(containerId, location);
};

window.createFloatingShareButton = function(location) {
    if (!socialSharing) {
        socialSharing = new SocialSharing();
    }
    socialSharing.createFloatingShareButton(location);
};
