;;; all-the-icons-nerd-fonts.el --- Nerd font integration for all-the-icons -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Mohsin Kaleem

;; Author: Mohsin Kaleem <mohkale@gmail.com>
;; Keywords: convenience, lisp
;; Package-Requires: ((emacs "28.0") (all-the-icons "5.0") (nerd-fonts "0.1"))
;; Version: 0.1

;; Copyright (C) 2021 Mohsin Kaleem

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

;;; Commentary:

;; Set up `nerd-fonts' for use with `all-the-icons'.
;;
;; This involves creating several all-the-icons font families for the
;; various nerd-font families (each prefixed with "nerd-") and allowing
;; users to convert any references to an all-the-icons icon to an
;; equivalent or similair nerd-fonts icon.

;;; Code:

(require 'cl-lib)
(require 'all-the-icons)
(require 'nerd-fonts-data)

(defgroup all-the-icons-nerd-fonts nil
  "Nerd font integration for all-the-icons."
  :prefix "all-the-icons-nerd-fonts-"
  :group 'all-the-icons)

(defcustom all-the-icons-nerd-fonts-family "Symbols Nerd Font"
  "The font-family to use with `nerd-fonts' icons."
  :type 'string)

(defvar all-the-icons-nerd-fonts-families
  (seq-uniq
   (cl-loop for icon in (mapcar #'car nerd-fonts-alist)
            collect (intern (substring icon 0 (cl-position ?- icon))))))

;; Define new `all-the-icons' families for available nerd fonts.
(defmacro all-the-icons-nerd-fonts-family (family)
  "Define a `all-the-icons' font for the nerd-font family FAMILY."
  (let* ((nerd-family (concat "nerd-" family))
         (font-alist (intern (concat "all-the-icons-data/" nerd-family "-alist")))
         (name (intern nerd-family)))
    `(progn
       (defvar ,font-alist
         (eval-when-compile
           (cl-loop for (name . icon) in nerd-fonts-alist
                    when (string-prefix-p ,family name)
                      collect (cons (substring name ,(1+ (length family)))
                                    icon))))

       (all-the-icons-define-icon ,name ,font-alist ,all-the-icons-nerd-fonts-family))))

(dolist (it all-the-icons-nerd-fonts-families)
  (eval
   `(all-the-icons-nerd-fonts-family ,(symbol-name it))))

;; Replace any none nerd-font lookups with nerd-font lookups.
(defcustom all-the-icons-nerd-fonts-convert-families
  '((mdi . material)
    (fa . faicon)
    (oct . octicon)
    (weather . wicon))
  "Alist of `all-the-icons' to `nerd-fonts' families to convert.
The key value should be a non-nerd entry in `all-the-icons-font-families'.
The value type should be an entry in `all-the-icons-nerd-fonts-families'.

When `all-the-icons-nerd-fonts-prefer-nerd' is true, each reference to the
key-family in any all-the-icons configuration will be made to reference the
value family."
  :type '(alist :key-type symbol :value-type symbol))

(defcustom all-the-icons-nerd-fonts-convert-icons
  '(((all-the-icons-alltheicon . "aws")              .    (all-the-icons-nerd-fa     . "amazon"))
    ((all-the-icons-fileicon   . "bib")              .    (all-the-icons-nerd-fa     . "book"))
    ((all-the-icons-alltheicon . "c-line")           .    (all-the-icons-nerd-custom . "c"))
    ((all-the-icons-fileicon   . "cljs")             .    (all-the-icons-nerd-dev    . "clojure"))
    ((all-the-icons-alltheicon . "clojure-line")     .    (all-the-icons-nerd-dev    . "clojure"))
    ((all-the-icons-alltheicon . "cplusplus-line")   .    (all-the-icons-nerd-custom . "cpp"))
    ((all-the-icons-alltheicon . "csharp-line")      .    (all-the-icons-nerd-mdi    . "language-csharp"))
    ((all-the-icons-fileicon   . "dockerfile")       .    (all-the-icons-nerd-linux  . "docker"))
    ((all-the-icons-fileicon   . "elisp")            .    (all-the-icons-nerd-custom . "emacs"))
    ((all-the-icons-alltheicon . "elixir")           .    (all-the-icons-nerd-custom . "elixir"))
    ((all-the-icons-fileicon   . "emacs")            .    (all-the-icons-nerd-custom . "emacs"))
    ((all-the-icons-alltheicon . "erlang")           .    (all-the-icons-nerd-dev    . "erlang"))
    ((all-the-icons-alltheicon . "git")              .    (all-the-icons-nerd-mdi    . "git"))
    ((all-the-icons-fileicon   . "gnu")              .    (all-the-icons-nerd-dev    . "gnu"))    
    ((all-the-icons-fileicon   . "go")               .    (all-the-icons-nerd-dev    . "go"))
    ((all-the-icons-alltheicon . "google-drive")     .    (all-the-icons-nerd-mdi    . "google-drive"))
    ((all-the-icons-alltheicon . "gulp")             .    (all-the-icons-nerd-seti   . "gulp"))
    ((all-the-icons-alltheicon . "haskell")          .    (all-the-icons-nerd-seti   . "haskell"))
    ((all-the-icons-alltheicon . "html5")            .    (all-the-icons-nerd-fa     . "html5"))
    ((all-the-icons-alltheicon . "java")             .    (all-the-icons-nerd-fae    . "java"))
    ((all-the-icons-alltheicon . "javascript")       .    (all-the-icons-nerd-mdi    . "language-javascript"))
    ((all-the-icons-fileicon   . "kotlin")           .    (all-the-icons-nerd-custom . "kotlin"))
    ((all-the-icons-fileicon   . "lisp")             .    (all-the-icons-nerd-custom . "emacs"))    
    ((all-the-icons-fileicon   . "lua")              .    (all-the-icons-nerd-seti   . "lua"))
    ((all-the-icons-alltheicon . "nodejs")           .    (all-the-icons-nerd-mdi    . "nodejs"))
    ((all-the-icons-fileicon   . "npm")              .    (all-the-icons-nerd-mdi    . "npm"))
    ((all-the-icons-fileicon   . "org")              .    (all-the-icons-nerd-custom . "orgmode"))
    ((all-the-icons-fileicon   . "php")              .    (all-the-icons-nerd-mdi    . "language-php"))
    ((all-the-icons-fileicon   . "powershell")       .    (all-the-icons-nerd-cod    . "terminal-powershell"))
    ((all-the-icons-alltheicon . "prolog")           .    (all-the-icons-nerd-dev    . "prolog"))
    ((all-the-icons-alltheicon . "python")           .    (all-the-icons-nerd-dev    . "python"))
    ((all-the-icons-fileicon   . "R")                .    (all-the-icons-nerd-mdi    . "language-r"))
    ((all-the-icons-fileicon   . "racket")           .    (all-the-icons-fileicon    . "lisp"))
    ((all-the-icons-alltheicon . "react")            .    (all-the-icons-nerd-mdi    . "react"))
    ((all-the-icons-octicon    . "ruby")             .    (all-the-icons-nerd-fae    . "ruby"))    
    ((all-the-icons-alltheicon . "rust")             .    (all-the-icons-nerd-dev    . "rust"))
    ((all-the-icons-alltheicon . "sass")             .    (all-the-icons-nerd-dev    . "sass"))
    ((all-the-icons-alltheicon . "scala")            .    (all-the-icons-nerd-dev    . "scala"))
    ((all-the-icons-alltheicon . "script")           .    (all-the-icons-nerd-seti   . "html"))
    ((all-the-icons-alltheicon . "svg")              .    (all-the-icons-nerd-mdi    . "file-image"))
    ((all-the-icons-alltheicon . "swift")            .    (all-the-icons-nerd-dev    . "swift"))
    ((all-the-icons-alltheicon . "terminal")         .    (all-the-icons-nerd-fa     . "terminal"))
    ((all-the-icons-fileicon   . "test-dir")         .    (all-the-icons-nerd-cod    . "beaker"))
    ((all-the-icons-fileicon   . "test-js")          .    (all-the-icons-nerd-seti   . "javascript"))
    ((all-the-icons-fileicon   . "test-typescript")  .    (all-the-icons-nerd-seti   . "typescript"))
    ((all-the-icons-fileicon   . "test-ruby")        .    (all-the-icons-nerd-dev    . "ruby"))
    ((all-the-icons-fileicon   . "tex")              .    (all-the-icons-nerd-oct    . "text-size"))
    ((all-the-icons-fileicon   . "typescript")       .    (all-the-icons-nerd-mdi    . "language-typescript"))
    ((all-the-icons-fileicon   . "vue")              .    (all-the-icons-nerd-mdi    . "vuejs")))
  "Conversion configuration between `all-the-icons' icons and `nerd-fonts' icons."
  :type '(alist :key-type (alist :key-type (symbol :tag "All the icons font family.")
                                 :value-type (string :tag "All the icons font name."))
                :value-type (alist :key-type (symbol :tag "Nerd fonts font-family.")
                                   :value-type (string :tag "Nerd fonts font-name."))))

(defvar extra-all-the-icons-extension-icon-alist
  '(
    ("cson"         all-the-icons-nerd-mdi "json"             :v-adjust 0.0 :face all-the-icons-yellow)
    ("gz"           all-the-icons-nerd-cod "archive"          :v-adjust 0.0 :face all-the-icons-lmaroon)
    ("json"         all-the-icons-nerd-mdi "json"             :height 1.2  :v-adjust 0.0 :face all-the-icons-green)
    ("midi" all-the-icons-nerd-mdi "music-note" :face all-the-icons-blue-alt)
    ("toml"         all-the-icons-nerd-mdi "settings"         :v-adjust 0.0 :face all-the-icons-orange)
    ("vim"          all-the-icons-nerd-custom   "vim"         :face all-the-icons-green)
    ))

(defvar extra-all-the-icons-regexp-icon-alist
  '(
    ("^poetry.lock$"     all-the-icons-nerd-mdi   "language-python-text" :face all-the-icons-yellow)
    ("^pyproject.toml$"   all-the-icons-nerd-mdi  "language-python-text" :face all-the-icons-lblue)
    ))

(defvar extra-all-the-icons-mode-icon-alist
  '(
    (dashboard-mode            all-the-icons-nerd-fa  "dashboard"          :face all-the-icons-purple)
    (dired-mode                all-the-icons-nerd-mdi "apple-finder"       :height 1.1 :v-adjust 0.0 :face all-the-icons-blue-alt)
    (debugger-mode             all-the-icons-nerd-cod "debug"              :height 1.1 :v-adjust 0.0 :face all-the-icons-red)
    (Man-mode                  all-the-icons-nerd-fa  "book"               :face all-the-icons-blue)    
    (messages-buffer-mode      all-the-icons-nerd-mdi "message"            :v-adjust 0.0 :face all-the-icons-green)
    (package-menu-mode         all-the-icons-nerd-fa  "shopping-bag"       :height 1.2 :v-adjust 0.0 :face all-the-icons-pink)
    ))

(defvar extra-all-the-icons-dir-icon-alist
  '(
    ("^node_modules$"   all-the-icons-nerd-custom "folder-npm"  :height 1.2)
    ("^src$"            all-the-icons-nerd-oct  "code"          :height 1.1)
    ("^doc[s]?$"        all-the-icons-nerd-mdi  "book-open"     :height 1.2)
    ("^target$"         all-the-icons-nerd-oct  "file-binary"   :height 1.2)
    ("^image[s]?$"      all-the-icons-nerd-mdi "folder-image"   :height 1.2)
    ))

(defun all-the-icons-extension-icon-alist-refresh ()
  (dolist (icon-config extra-all-the-icons-extension-icon-alist)
    (push icon-config all-the-icons-extension-icon-alist)
    ))

(defun all-the-icons-mode-icon-alist-refresh ()
  (dolist (icon-config extra-all-the-icons-mode-icon-alist)
    (push icon-config all-the-icons-mode-icon-alist)
    ))

(defun all-the-icons-regexp-icon-alist-refresh ()
  (dolist (icon-config extra-all-the-icons-regexp-icon-alist)
    (push icon-config all-the-icons-regexp-icon-alist)
    ))

(defun all-the-icons-dir-icon-alist-refresh ()
  (dolist (icon-config extra-all-the-icons-dir-icon-alist)
    (push icon-config all-the-icons-dir-icon-alist)
    ))

(defun all-the-icons-nerd-fonts-prefer ()
  "Replace any `all-the-icons' associations with `nerd-fonts'."
  (let ((family-subs (cl-loop for (family . ati-family) in all-the-icons-nerd-fonts-convert-families
                              when (member family all-the-icons-nerd-fonts-families)
                              collect (cons (intern (concat "all-the-icons-" (symbol-name ati-family)))
                                            (intern (concat "all-the-icons-nerd-" (symbol-name family))))))
        (match-subs all-the-icons-nerd-fonts-convert-icons))
    ;; For each variable all-the-icons uses to lookup contextual icons.
    (dolist (var '(all-the-icons-icon-alist
                   all-the-icons-dir-icon-alist
                   all-the-icons-weather-icon-alist
                   all-the-icons-mode-icon-alist
                   all-the-icons-url-alist
                   all-the-icons-extension-icon-alist))
      ;; For each entry in those lists do key-value substitution with `subs'.
      (dolist (assoc (symbol-value var))
        (if-let ((new-icon-func (alist-get (nth 1 assoc) family-subs)))
            (setcar (cdr assoc) new-icon-func)
          (when-let ((new-assoc (alist-get (cons (nth 1 assoc) (nth 2 assoc))
                                           match-subs nil nil
                                           (lambda (a b)
                                             (and (eq    (car a) (car b))
                                                  (equal (cdr a) (cdr b)))))))
            (setcar (cdr assoc)       (car new-assoc))
            (setcar (cdr (cdr assoc)) (cdr new-assoc)))))))
  (all-the-icons-extension-icon-alist-refresh)
  (all-the-icons-regexp-icon-alist-refresh)
  (all-the-icons-mode-icon-alist-refresh)
  (all-the-icons-dir-icon-alist-refresh))

(provide 'all-the-icons-nerd-fonts)
;;; all-the-icons-nerd-fonts.el ends here
