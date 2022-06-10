document.addEventListener('turbolinks:load', ready)
document.addEventListener('page:load', ready)
document.addEventListener('page:update', ready)


function ready() {
    $('.embed-gist').each(function() {
        let href = $(this).attr('href');
        let gistId = $(this).data('gistId')
        let oneGist = new Gh3.Gist({id:gistId});

        oneGist.fetchContents(function (err, res) {

            if(err) {
                throw "Gist: something went wrong!"
            }

            let gistFiles = oneGist.files;
            let name = gistFiles[0].filename;
            let content = gistFiles[0].content;

            $('*[data-gist-id=' + gistId + ']').replaceWith(createGistElement(name, content, href, gistId));
        });
    })
}

function createGistElement(name, content, href, gistId) {
    let nameElement = createElement('a', name, 'gist-name card-header');
    nameElement.setAttribute('href', href);
    let contentElement = createElement('code', content, 'gist-content card-body');
    let gistElement = document.createElement("div");
    gistElement.className = 'gist-container card';
    gistElement.setAttribute('data-gist-id', gistId)
    gistElement.appendChild(nameElement);
    gistElement.appendChild(contentElement);
    return gistElement;
}

function createElement(tag, content, className) {
    let element = document.createElement(tag);
    element.className = className;
    element.innerHTML = content;
    return element;
}
