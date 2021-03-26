(defn head
  [build-url]
  [:doctype :html5]
   [:head
    [:meta {:charset "UTF-8"}]
    [:meta {:name "viewport" :content "width=device-width, initial-scale=1.0"}]
    [:script {:type "text/x-mathjax-config"}
     (str "MathJax.Hub.Config({
    tex2jax: {
      inlineMath: [ ['$','$'], ['\\\\(','\\\\)'] ],
      processEscapes: true
    }
  });")]
    [:script {:src "https://polyfill.io/v3/polyfill.min.js?features=es6"}]
    [:script {:src "https://hypothes.is/embed.js" :async "async"}]
    [:script {:type "text/javascript" :async "async" :src "https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"}]
    [:link {:rel "stylesheet" :href (build-url "/static/css/firn_base.css")}]
    [:link {:rel "preconnect" :href "https://fonts.gstatic.com"}]
    [:link {:rel "stylesheet" :href "https://fonts.googleapis.com/css2?family=Ubuntu+Condensed&family=Ubuntu+Mono&family=Ubuntu:wght@300;400&display=swap"}]
])

