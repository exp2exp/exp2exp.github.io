;;; org-roam-manual.el — Build a PDF manual based on an org roam directory

;;; Commentary:

;; This provides a simple way to build a PDF based on the org files
;; collected in ‘org-roam-directory’.  The contents and order are
;; controlled by ‘files-to-combine’.  (Sample content for the exp2exp
;; wiki is provided.)

;;; Code:

;; Here’s some code to turn a large Org mode file into sub-files
;; ready for Org Roam

(defun org-get-headline ()
  (org-back-to-heading t)
  (looking-at org-complex-heading-regexp)
  (match-string-no-properties 4))

(defun org-get-body ()
  (save-excursion
    (save-restriction
      (widen)
      (let* ((elt (org-element-at-point))
             (title (org-element-property :title elt))
             (beg (save-excursion (org-end-of-meta-data t) (point)))
             (end (save-excursion (org-end-of-subtree) (point))))
        (buffer-substring-no-properties beg end)))))

(defun zoom-in-and-enhance ()
  "Process an Org Mode buffer into multiple Org Roam-style files.
Changes headers to titles."
  (org-map-entries
   (lambda ()
     (let* ((title (org-get-headline))
            (contents (org-get-body)))
       (with-temp-buffer
         (insert "#+TITLE: " title "\n"
                 contents)
         (org-mode)
         (org-map-entries #'org-promote-subtree)
         (write-file (concat
                      (funcall
                       org-roam-title-to-slug-function
                       title) ".org")))))
   "LEVEL=1"))

;; Here’s the functionality needed for going the other direction
;; i.e., turning a collection of Org Roam files into one big Org Mode
;; file.

(defun downsample ()
  "Process an Org Roam buffer for inclusion in a standard Org file.
Changes title to header, and increase indentation of existing headers.
Changes file links to internal links."
  ;; Works in a temporary buffer
  (let ((beg (point)))
    (search-forward-regexp "^#\\+title:" nil t)
    (delete-region beg (point))
    (insert "*")
    (forward-line 1)
    (if (looking-at "^#\\+filetags:\\(.*\\)")
        (replace-match ":PROPERTIES:
:tag:\\1
:END:"))
    (while (re-search-forward "^\\*" nil t)
      (replace-match "**"))
    (goto-char (point-min))
    (while (re-search-forward "\\[\\[file:\\([^]]*\\)\\]\\[\\([^]]*\\)\\]\\]" nil t)
      (replace-match "[[*\\2][\\2]]"))
    (buffer-substring-no-properties (point-min) (point-max))))

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

(defvar front-page-plus-one
  '("20200810131435-hyperreal_enterprises.org"
"20200810132653-top.org"
"20200905124558-why_not_what.org"
"20200905124405-construct_critique_improve_models_of_the_creative_process.org"
"20200905125023-which_model_construction_process_works_as_a_whole.org"
"20200905131918-knowledge_graph.org"
"20200905124432-underlying_foundation.org"
"20200906003704-bottom.org"
"time_capsule.org")
  )

;; Probably this should be constructed automatically from the index.org page!
(defvar files-to-combine
'("20200810131435-hyperreal_enterprises.org"
"20200810132653-top.org"
"20200905124558-why_not_what.org"
 "20200909195629-teach_arbitrary_coding.org"
 "20200810135851-how_to_design_programs_with_if.org"
"20200905124405-construct_critique_improve_models_of_the_creative_process.org"
  "20200905125342-emacs_hyper_notebook.org"
  "20201027174427-hypernotebook_first_demo.org"
  "emacs_jupyter_remote_debugging.org"
  "arxana.org"
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
 "upstream.org"
 "grant_development.org"
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

;; This would be better done using some form of slicing, but for now
(defvar just-high-level-files '("20200810131435-hyperreal_enterprises.org"
"20200810132653-top.org"
"20200810135126-organisational_infrastructure.org"
"20200814210243-business_development.org"
"20200905124405-construct_critique_improve_models_of_the_creative_process.org"
"20200905124432-underlying_foundation.org"
"20200905124558-why_not_what.org"
"20200905125023-which_model_construction_process_works_as_a_whole.org"
"20200905134325-research_outputs.org"
"20200906003704-bottom.org"
"20201003205523-potential_products.org"))

(defvar just-writing '("20_april_2021_getting_starting_with_writing.org"
                       "27_april_2021_what_s_unwritten.org"
                       "21_april_2021_resonances.org"
                       "24_april_2021_consonances.org"
                       "25_april_2021_murmurations.org"
                       "29_april_2021_testament_of_youf.org"
                       "30_april_2021_fatigue_joy.org"
                       "01_may_2021_future.org"
                       "02_may_2021_sfumato.org"
                       "03_may_2021_collective_writing.org"
                       "04_may_2021_world_of_the_text.org"
                       "05_may_2021_breakdown_of_language.org"))

(defvar just-erg
  '(
"erg-2020-12-02.org"
"erg-2020-12-12.org"
"erg-2020-12-19.org"
"erg-2021-01-02.org"
"erg-2021-01-09.org"
"erg-2021-01-16.org"
"erg-2021-01-23.org"
"erg-2021-01-30.org"
"erg-2021-02-06.org"
"erg-2021-02-13.org"
"erg-2021-02-20.org"
"erg-2021-02-27.org"
"erg-2021-03-06.org"
"erg-2021-03-13.org"
"erg-2021-03-27.org"
"erg-2021-04-03.org"
"erg-2021-04-10.org"
"erg-2021-04-17.org"
"erg-2021-04-24.org"
"erg-2021-05-01.org"
"erg-2021-05-08.org"
"erg-2021-05-15.org"
"erg-2021-05-22.org"
"erg-2021-05-29.org"
"erg-2021-06-19.org"
"erg-2021-08-28.org"
"erg-2021-09-11.org"
"erg-2021-09-18.org"
"erg-2021-09-25.org"
"erg-2021-10-02.org"
"erg-2021-10-09.org"
"erg-2021-10-16.org"
"erg-2021-10-23.org"
"erg-2021-10-30.org"
"erg-2021-11-06.org"
"erg-2021-11-13.org"
"erg-2021-11-20.org"
"erg-2021-12-04.org"
"erg-2021-12-11.org"
"erg-2021-12-18.org"
"erg-2022-01-15.org"
"erg-2022-01-22.org"
"erg-2022-01-29.org"
"erg-2022-02-05.org"
"erg-2022-02-12.org"
"erg-2022-02-19.org"
"erg-2022-02-26.org"
"erg-2022-03-05.org"
"erg-2022-03-12.org"
"erg-2022-03-19.org"
"erg-2022-04-02.org"
"erg-2022-04-09.org"
"erg-2022-04-16.org"
"erg-2022-04-23.org"
"erg-2022-04-30.org"
"erg-2022-05-07.org"
"erg-2022-05-14.org"
"erg-2022-05-21.org"
"erg-2022-05-28.org"
"erg-2022-06-11.org"
"erg-2022-07-02.org"
"erg-2022-07-09.org"
"erg-2022-07-16.org"
"erg-2022-07-23.org"
"erg-2022-07-30.org"
"erg-2022-08-06.org"
"erg-2022-08-13.org"
"erg-2022-08-20.org"
"erg-2022-08-27.org"
"erg-2022-08-31-extra-meeting.org"
"erg-2022-09-02-meeting-judith.org"
"erg-2022-09-03.org"
"erg-2022-09-09-meeting-abby.org"
"erg-2022-09-10.org"
"erg-2022-09-17.org"
"erg-2022-09-24.org"
"erg-2022-09-29-meeting-abby.org"
"erg-2022-10-01.org"
"erg-2022-10-08.org"
"erg-2022-10-13-meeting-abby.org"
"erg-2022-10-15.org"
"erg-2022-10-22.org"
"erg-2022-10-27-meeting-abby.org"
"erg-2022-10-29.org"
"erg-2022-11-05.org"
"erg-2022-11-12.org"
"erg-2022-11-19.org"
"erg-2022-11-26.org"
))

(defvar just-workshop '(
                        "20221121185152-placard_workshop_introduction.org"
                        "20221121185625-workshop_management_checklist.org"
                        "20221121185656-workshop_frontstage_organisation.org"
                        "20221121185710-workshop_backstage_organisation.org"
                        "20221121185931-prior_to_the_workshop.org"
                        "20221121190006-during_the_workshop.org"
                        "20221121190030-after_the_workshop.org"
                        "20221121181525-open_future_design.org"
                        "20221121181616-participatory_scenario_planning.org"
                        "20221121181644-derive_comix.org"
                        "20221121181653-meaning_map.org"
                        "20221121181702-reinfuse_expertise.org"
                        "20221121181707-play_to_anticipate_the_future.org"
                        "20221121181715-kaiju_communicator.org"
                        "20221121181721-historian.org"
                        "20221121181726-analyst.org"
                        "20221121181731-designer.org"
                        "20221121183832-find_the_dots.org"
                        "20221121183858-advice_from_a_caterpillar.org"
                        "20221121183935-problem_indentification.org"
                        "20221121183951-dimension_analysis.org"
                        "20221121184028-build_scenarios.org"
                        "20221121184108-derive_comix_part_2.org"
                        "20221121184126-connections_from_kafka.org"
                        "20221121184158-a_path_forward.org"
                        "20221121184220-back_to_reality.org"
                        "20221121184341-new_patterns.org"
                        "20221121184522-project_action_preview.org"
                        "20221121184614-repeat_phase_ii.org"
                        "20221121184718-share_back.org"
                        "20221121181738-roadmap.org"
                        "20221121181745-project_action_review.org"
                        "20221129173158-causal_layered_analysis.org"
))

(defun indent-org-roam-export ()
  "Utility function to increase indention for selected trees."
  (org-map-entries (lambda ()
                     ;; don’t demote the top level items and their sub-items
                     (let ((tag (org-entry-get nil "tag")))
                       (if (and tag (string= (car (split-string (string-trim tag ":" ":") ":")) "HL"))
                           (progn (org-end-of-subtree)
                                  (setq org-map-continue-from (point)))
                         (org-do-demote))))
                   nil 'file))

;; In order to get it to work with broken links, I made a quick
;; change to ox.el [[file:~/org-mode/lisp/ox.el::(`mark (org-export-data]]
;; ... where, ideally, this would be done with advice
;; ... doing that properly and cleanly is a bit of a hassle!
;;
;; Also, this function should really take some arguments and then separate implementations should be called for the individual extracts we want to build
(defun rebuild-org-roam-pdf (filename &optional sources anonymous)
  "Build an org file and PDF compiling `files-to-combine'."
  (interactive)
  (shell-command (concat "cp " org-roam-directory "/../manual/hl.org "
                               org-roam-directory "/../manual/" filename))
  (save-excursion (find-file (concat org-roam-directory "/../manual/" filename))
    (goto-char (point-min))
    (search-forward "# IMPORT")
    (let ((beg (point)))
      (delete-region (point) (point-max))
      (insert "\n" (combine-org-roam-files (or sources files-to-combine)))
      (goto-char beg)
      (indent-org-roam-export)
      (when anonymous (goto-char beg)
            (flush-lines "#+AUTHOR:"))
      (org-latex-export-to-pdf))))

;;; org-roam-manual.el ends here
