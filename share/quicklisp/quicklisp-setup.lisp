(in-package :maxima)
(defvar *maxima-quicklisp-path* "maxima-quicklisp/") ;; this is relative to home folder

(defun quicklisp-setup-file ()
  (merge-pathnames (merge-pathnames *maxima-quicklisp-path* "setup.lisp") (user-homedir-pathname)))

(defun $quicklisp_installed_p ()
  (let ((quicklisp-setup-file (quicklisp-setup-file)))
    (when (probe-file quicklisp-setup-file)
      t)))  ;; maxima wants t or nil in "if" expressions

(defun $load_installed_quicklisp ()
  #-(or gcl quicklisp)
  (with-output-to-string (s)
    (let ((*standard-output* s))
      (when ($quicklisp_installed_p)
	(let ((quicklisp-setup-file (quicklisp-setup-file)))
	  (when quicklisp-setup-file
	    (load quicklisp-setup-file)))))))

(defun $load_quicklisp_init ()
  ;;#-(or gcl quicklisp)
  ;; quicklisp is not installed yet, so install it
  (with-output-to-string (s)
    (let ((*standard-output* s))
     (let ((maxima-sharedir (probe-file *maxima-sharedir*)))
       (if maxima-sharedir
	   (let ((quicklisp-file (merge-pathnames "quicklisp/quicklisp-init.lisp" maxima-sharedir)))
	     (if (probe-file quicklisp-file)
		 (load quicklisp-file)
		 (merror (intl:gettext "Couldn't initialize quicklisp"))))
	   (merror (intl:gettext "Couldn't initialize quicklisp"))))))
  #+gcl(merror (intl:gettext "gcl not yet supported")))

(defun $install_quicklisp ()
  (funcall (find-symbol "INSTALL" (find-package :quicklisp-quickstart)) :path (merge-pathnames *maxima-quicklisp-path* (user-homedir-pathname))))

(defun $quickload (package-name)
  (progn
    (funcall (find-symbol "QUICKLOAD" (find-package :ql)) package-name)
    '$done))
