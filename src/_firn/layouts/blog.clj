(defn blog                   ; define a clojure func
  [{:keys [build-url title render partials]}] ; destructured commonly used functions and data
  (let [{:keys [head]} partials]              ; Ignore for now, partials will be explained later
    [:html                      ; => opens a `html` tag
     (head build-url)           ; => Renders the `head` partial
     [:body                     ; => opens a `body` tag
      [:main                    ; => Ditto
       [:article.def-wrapper    ; => opens a `article` html tag with a class of `def-wrapper`
        [:div.def-content       ; => see above
         [:h1 title]            ; => renders an `h1` tag with the file title.
         (render :sitemap {:sort-by :newest})
         ]]]]]))                ; => all these closing brackets can be thought of as closing html tags (for now)
