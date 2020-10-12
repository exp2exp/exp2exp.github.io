;;; org-roam-manual.el — Build a PDF manual based on an org roam directory

;;; Commentary:

;; This provides a simple way to build a PDF based on the org files
;; collected in ‘org-roam-directory’.  The contents and order are
;; controlled by ‘files-to-combine’.  (Sample content for the exp2exp
;; wiki is provided.)

;;; Code:

(defun downsample ()
  "Process an Org Roam buffer for inclusion in a standard Org file.
Changes title to header, and increase indentation of existing headers.
Changes file links to internal links."
  (if (looking-at "^#\\+TITLE:")
      (replace-match "*"))
  (forward-line 1)
  (if (looking-at "^#\\+roam_tags:\\(.*\\)")
      (replace-match ":PROPERTIES:
  :tag:\\1
  :END:"))
  (while (re-search-forward "^\\*" nil t)
    (replace-match "**"))
  (goto-char (point-min))
  (while (re-search-forward "\\[\\[file:\\([^]]*\\)\\]\\[\\([^]]*\\)\\]\\]" nil t)
    (replace-match "[[*\\2][\\2]]"))
  (buffer-substring-no-properties (point-min) (point-max)))

(defun combine-org-roam-files (&rest args)
"Combine a list of files, specified as ARGs.
The files are to be found in `org-roam-directory'."
  (apply #'concat
         (mapcar (lambda (file)
                   (save-window-excursion
                     (find-file (concat org-roam-directory file))
                     (let ((contents (buffer-substring-no-properties (point-min)
                                                                     (point-max))))
                       (with-temp-buffer (insert contents)
                                         (goto-char (point-min))
                                         (downsample)))))
                 (or (car args) (nthcdr 5 command-line-args)))))

(defvar files-to-combine
'("20200810131435-hyperreal_enterprises.org"
"20200810132653-top.org"
"20200905124558-why_not_what.org"
 "20200909195629-teach_arbitrary_coding.org"
 "20200810135851-how_to_design_programs_with_if.org"
"20200905124405-construct_critique_improve_models_of_the_creative_process.org"
  "20200905125342-emacs_hyper_notebook.org"
"20200905125023-which_model_construction_process_works_as_a_whole.org"
 "20200905131027-information_extraction_from_so_q_a_items.org"
"20200905131918-knowledge_graph.org"
"20200905124432-underlying_foundation.org"
 "20200905125713-category_theoretic_glue.org"
 "20200905131656-probabilistic_programming_for_scientific_modelling.org"
"20201003205523-potential_products.org"
 "20200905130423-agent_model.org"
 "20200817172825-recommender_system.org"
 "20200810135457-visual_interfaces.org"
 "20200814203551-data_course.org"
 "20200905132603-paperspace_do_nj_etc_collaboratory.org"
"20200814210243-business_development.org"
"20200905134325-research_outputs.org"
 "20200810135325-advances_in_tutoring_systems_for_programming.org"
 "20200810135403-advances_in_knowledge_mining_from_technical_documents.org"
 "20200905132334-an_abm_of_the_computer_programming_domain.org"
"20200906003704-bottom.org"
 "20201003164408-downstream.org"
 "20201003165500-consulting_clients.org"
 "20201003170312-open_source_developers.org"
 "20201003170333-tutoring_students.org"
 "20201003171011-programmers.org"
"20200810135126-organisational_infrastructure.org"
 "20200810135619-discord_server.org"
 "20200811185435-obs_recordings.org"
 "20200814193042-code_sharing_platform.org"
 "20200912223428-wiki.org"
 "20201003164100-forum.org"
 "20200814195259-blog.org")
"An ordered list of files to combine in our export.
This is where the order of presentation in the downstream org file
and derived PDF is defined.")

(defun indent-org-roam-export ()
  "Utility function to increase indention for selected trees."
  (org-map-entries (lambda ()
                     ;; don’t demote the top level items and their sub-items
                     (let ((tag (org-entry-get nil "tag")))
                       (if (and tag (string= (car (split-string tag)) "HL"))
                           (progn (org-end-of-subtree)
                                  (setq org-map-continue-from (point)))
                         (org-do-demote))))
                   nil 'file))

(defun rebuild-org-roam-pdf ()
  "Build an org file and PDF compiling `files-to-combine'."
  (interactive)
  (save-excursion (find-file (concat org-roam-directory
                                     "/manual/combined.org"))
    (goto-char (point-min))
    (search-forward "# IMPORT")
    (let ((beg (point)))
      (delete-region (point) (point-max))
      (insert "\n" (combine-files files-to-combine))
      (goto-char beg)
      (indent-org-roam-export)
      (org-latex-export-to-pdf))))

;;; org-roam-manual.el ends here
