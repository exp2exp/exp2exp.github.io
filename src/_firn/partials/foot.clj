(defn foot
  []
  [:script (str
            "anchors.options = {
                               visible: 'always',
                               placement: 'left',
                               icon: '§'
                               };
            anchors.add('h2');
            anchors.add('h3');
            anchors.add('h4');
            anchors.add('h5');"
            )])
