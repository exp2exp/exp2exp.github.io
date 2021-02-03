(defn erg-blog
  [{:keys [build-url title render partials]}]
  (let [{:keys [head]} partials]
    [:html
     (head build-url)
     [:body
      [:main
       [:article.def-wrapper
        [:div.def-content
         [:h1 title]
         ;; List files that "FIRN_UNDER" the "Updates" page
         ;; But only those which are immediately "under" it
         ;; sorted by newness
         ;; - ‘render’ renders HTML, but would be nice to have version that just returns data
         (render :sitemap {:start-at ["erg"]
                           :depth 1
                           :sort-by :newest})
         [:hr]
         [:div.back-to-main
          [:p "Back to main index: "
           [:a {:href "https://exp2exp.github.io/index.html"} "Exp2Exp"]]]
         ]]]]]))


