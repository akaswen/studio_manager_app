const dropDownMaker = (() => {

    const styleLine = (line, icon) => {
        let size = icon.clientHeight;
        line.setAttribute('style', 
            `border: ${size/20}px solid ${icon.style.color}; 
            margin: 15% 10%;
            display: block;
            position: relative;
            transition: transform 300ms, opacity 300ms, top 300ms;
            top: 10%;`
        );
    };

    const makeClickable = icon => {
        icon.setAttribute('style', 'cursor: pointer;');
    };

    const makeLines = icon => {
        let i;
        for (i = 0; i < 3; i++) {
            let line = document.createElement('span');
            styleLine(line, icon);
            icon.appendChild(line); 
        }
    };

    const styleText = (text, icon) => {
        let size = icon.clientHeight;
        text.setAttribute(
            'style', 
            `font-size: ${size/5}px;
            text-align: center;`
        );
    };

    const addText = (icon) => {
        let text = document.createElement('P');
        text.textContent = 'Menu';
        styleText(text, icon);
        icon.appendChild(text);
    };
    const toggleDropDown = (icon, menu) => {
        menu.classList.toggle('shown');
        icon.classList.toggle('active');
    };

    const addDropDown = (icon, menu) => {
        icon.textContent = '';
        makeClickable(icon);
        makeLines(icon);
        addText(icon);

        const addToggle = (e) => {
            e.target.removeEventListener('click', addToggle);
            toggleDropDown(icon, menu, e);
            e.target.addEventListener('click', addToggle);
        };

        icon.addEventListener('click', addToggle);
    };
    
    return {addDropDown};
})();
