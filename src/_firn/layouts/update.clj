(defn update
  [{:keys [render partials title date-created build-url]}]
  (let [{:keys [head]} partials]
    [:html
     (head build-url)
     [:body
      [:main
       [:article.content
        ;; [:div (render :toc)] ;; Optional; add a table of contents
        [:h1 title]
        [:i date-created]
        [:div (render :file)]
        ;; if backlinks exist, store them in a let bindings.
        (when-let [backlinks (render :backlinks)] 
          [:div
           [:hr]
           [:div.backlinks
            [:h4 "Backlinks to this document:"]
            backlinks]])
        [:hr]
        [:div.back [:p "Back to blog: " [:a {:href "https://exp2exp.github.io/updates.html"} "Exp2Exp: Updates"]]]]]]]))
