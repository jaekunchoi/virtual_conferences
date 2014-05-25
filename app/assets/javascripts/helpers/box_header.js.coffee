Ember.Handlebars.helper 'boxHeader', (text) ->
    new Handlebars.SafeString '
        <header>
            <div class="icons"><i class="fa fa-edit"></i></div>
            <h5>' + text + '</h5>
            <div class="toolbar">
                <ul class="nav">
                    <li>
                        <a class="accordion-toggle minimize-box" data-toggle="collapse" href="#div-1">
                            <i class="fa fa-chevron-up"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </header>'