var isMobile = {
    Android: function() {
        return navigator.userAgent.match(/Android/i);
    },
    BlackBerry: function() {
        return navigator.userAgent.match(/BlackBerry/i);
    },
    iOS: function() {
        return navigator.userAgent.match(/iPhone|iPad|iPod/i);
    },
    Opera: function() {
        return navigator.userAgent.match(/Opera Mini/i);
    },
    Windows: function() {
        return navigator.userAgent.match(/IEMobile/i);
    },
    any: function() {
        return (isMobile.Android() || isMobile.BlackBerry() || isMobile.iOS() || isMobile.Opera() || isMobile.Windows());
    }
};
//$("#cont-preview .contenidoCabecera").animate({marginTop:($(window).scrollTop()/5)*-1},{duration:0.1,queue:false,easing:"linear"});    
$(document).ready(function(){
    window.onscroll=function(e){
        if($(".img_portada")){
            TweenLite.to($(".img_portada div:first"), 0.2, {css:{"background-position-y":(($(window).scrollTop()/2)*1)+"px"}, ease:Power2.easeOut});
            //TweenLite.to($(".img_portada div:first"), 0.1, {css:{"background-position-y":(($(window).scrollTop()/2)*1)+"px"}, ease:Quad.easeOut});
        }        
    }
});