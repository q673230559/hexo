{% if page.comments %}
  <div class="comments" id="comments">
      {% if (theme.valine and theme.valine.enable)%}
        <script src="//cdn1.lncld.net/static/js/3.0.4/av-min.js"></script>
        <script src="https://xcss.github.io/Valine/dist/Valine.min.js"></script>
        <script>
            new Valine({
                        av: AV, // source from av-min.js
                        el: '.comment' ,
                        app_id: '{{ theme.valine.appId }}',
                        app_key: '{{ theme.valine.appKey }}',
                        // [v1.0.7 new]留言框占位提示文字
                        placeholder: 'ヾﾉ≧∀≦)o来啊，快活啊!'
            });
        </script>
      {% endif %}
  </div>
{% endif %}
