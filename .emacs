(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;;Initialize use-package on non-linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package doom-themes)
(use-package cider)
(use-package swiper)
(use-package clojure-mode)
(use-package neotree)
(use-package elfeed)

(menu-bar-mode -1)

(global-set-key (kbd "C-x w") 'elfeed)

;; setup company mode
(use-package company
  :ensure t
  :demand t
  :hook ((emacs-lisp-mode
          lisp-mode
          slime-repl-mode
          clojure-mode
	  python-mode 
          cider-repl-mode) . company-mode)
  :bind (:map company-active-map
              ("C-p" . (lambda ()
                          (interactive)
                          (company-select-previous)))
              ("C-n" . (lambda ()
			  (interactive)
                          (company-select-next)))
              ("SPC" . (lambda ()
                         (interactive)
                         (company-abort)
                         (insert " ")))
              ("<return>" . nil)
              ("RET" . nil)
              ("<tab>" . company-complete))
  :config
  (setq company-minimum-prefix-length 2
        company-idle-delay 0.1
        company-flx-limit 20))

;;==========================================
;; COMMON LISP / SLIME
;;==========================================

;; `put' sets a global symbol property, so this only needs to run once.
(defun my/common-lisp-indent-setup ()
  "Indentation hints for macros `cl-indent' does not already know about."
  (dolist (spec '((with-gensyms . 1)
                  (when-let . 1)
                  (if-let . 1)))
    (put (car spec) 'common-lisp-indent-function (cdr spec))))

(defun my/slime-repl-setup ()
  "Enable paredit in the SLIME REPL without letting it steal RET."
  (enable-paredit-mode)
  (define-key slime-repl-mode-map (kbd "RET") #'slime-repl-return)
  (define-key slime-repl-mode-map (kbd "<return>") #'slime-repl-return))

(use-package slime-company
  :ensure t
  :demand t
  :after company
  :init
  (setq slime-company-completion 'fuzzy))

;; Loaded after slime-company so `slime-setup' can require the contrib.
(use-package slime
  :ensure t
  :demand t
  :after slime-company
  :config
  (setq inferior-lisp-program "sbcl"
        ;; REPL ergonomics
        slime-repl-history-file (expand-file-name "~/.slime-repl-history")
        slime-repl-history-size 10000
        slime-complete-symbol*-fancy t)
  ;; Single `slime-setup' call: it REPLACES `slime-contribs', it does not append.
  (slime-setup '(slime-fancy
                 slime-quicklisp
                 slime-asdf
                 slime-sbcl-exts
                 slime-xref-browser
                 slime-company))
  (my/common-lisp-indent-setup)
  (add-hook 'slime-repl-mode-hook #'my/slime-repl-setup))

;; Theme below

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes '(doom-outrun-electric))
 '(custom-safe-themes
   '("1f292969fc19ba45fbc6542ed54e58ab5ad3dbe41b70d8cb2d1f85c22d07e518" "4d5d11bfef87416d85673947e3ca3d3d5d985ad57b02a7bb2e32beaf785a100e" "5c8a1b64431e03387348270f50470f64e28dfae0084d33108c33a81c1e126ad6" "4594d6b9753691142f02e67b8eb0fda7d12f6cc9f1299a49b819312d6addad1d" "77fff78cc13a2ff41ad0a8ba2f09e8efd3c7e16be20725606c095f9a19c24d3d" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "e14289199861a5db890065fdc5f3d3c22c5bac607e0dbce7f35ce60e6b55fc52" "921f165deb8030167d44eaa82e85fcef0254b212439b550a9b6c924f281b5695" "9e5e0ff3a81344c9b1e6bfc9b3dcf9b96d5ec6a60d8de6d4c762ee9e2121dfb2" "e8ceeba381ba723b59a9abc4961f41583112fc7dc0e886d9fc36fa1dc37b4079" "3061706fa92759264751c64950df09b285e3a2d3a9db771e99bcbb2f9b470037" "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" "2ab8cb6d21d3aa5b821fa638c118892049796d693d1e6cd88cb0d3d7c3ed07fc" "0325a6b5eea7e5febae709dab35ec8648908af12cf2d2b569bedc8da0a3a81c1" "5c7720c63b729140ed88cf35413f36c728ab7c70f8cd8422d9ee1cedeb618de5" "b754d3a03c34cfba9ad7991380d26984ebd0761925773530e24d8dd8b6894738" "f253a920e076213277eb4cbbdf3ef2062e018016018a941df6931b995c6ff6f6" "2f7fa7a92119d9ed63703d12723937e8ba87b6f3876c33d237619ccbd60c96b9" "a6920ee8b55c441ada9a19a44e9048be3bfb1338d06fc41bce3819ac22e4b5a1" "d481904809c509641a1a1f1b1eb80b94c58c210145effc2631c1a7f2e4a2fdf4" "3613617b9953c22fe46ef2b593a2e5bc79ef3cc88770602e7e569bbd71de113b" "42a6583a45e0f413e3197907aa5acca3293ef33b4d3b388f54fa44435a494739" "8d3ef5ff6273f2a552152c7febc40eabca26bae05bd12bc85062e2dc224cde9a" "be0d9f0e72a4ebc4a59c382168921b082b4dc15844bdaf1353c08157806b3321" "e622620e5f31216fd71e492fc1476e1fe7c21b8dc5811bf9e640c4b1fd6cfac1" "19d62171e83f2d4d6f7c31fc0a6f437e8cec4543234f0548bad5d49be8e344cd" "c07f072a88bed384e51833e09948a8ab7ca88ad0e8b5352334de6d80e502da8c" "f6ea954a9544b0174a876d195387f444da441535ee88c7fb0fc346af08b0d228" "c9d837f562685309358d8dc7fccb371ed507c0ae19cf3c9ae67875db0c038632" "70c88c01b0b5fde9ecf3bb23d542acba45bb4c5ae0c1330b965def2b6ce6fac3" "38b43b865e2be4fe80a53d945218318d0075c5e01ddf102e9bec6e90d57e2134" "1f8bd4db8280d5e7c5e6a12786685a7e0c6733b0e3cf99f839fb211236fb4529" "088cd6f894494ac3d4ff67b794467c2aa1e3713453805b93a8bcb2d72a0d1b53" "f053f92735d6d238461da8512b9c071a5ce3b9d972501f7a5e6682a90bf29725" "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0" "df6dfd55673f40364b1970440f0b0cb8ba7149282cf415b81aaad2d98b0f0290" "c3c135e69890de6a85ebf791017d458d3deb3954f81dcb7ac8c430e1620bb0f1" "4b88b7ca61eb48bb22e2a4b589be66ba31ba805860db9ed51b4c484f3ef612a7" "f4d1b183465f2d29b7a2e9dbe87ccc20598e79738e5d29fc52ec8fb8c576fcfd" "e1df746a4fa8ab920aafb96c39cd0ab0f1bac558eff34532f453bd32c687b9d6" "a9eeab09d61fef94084a95f82557e147d9630fbbb82a837f971f83e66e21e5ad" "b7a09eb77a1e9b98cafba8ef1bd58871f91958538f6671b22976ea38c2580755" "f1e8339b04aef8f145dd4782d03499d9d716fdc0361319411ac2efc603249326" "599f72b66933ea8ba6fce3ae9e5e0b4e00311c2cbf01a6f46ac789227803dd96" "13096a9a6e75c7330c1bc500f30a8f4407bd618431c94aeab55c9855731a95e1" "7ec8fd456c0c117c99e3a3b16aaf09ed3fb91879f6601b1ea0eeaee9c6def5d9" "456697e914823ee45365b843c89fbc79191fdbaff471b29aad9dcbe0ee1d5641" "83550d0386203f010fa42ad1af064a766cfec06fc2f42eb4f2d89ab646f3ac01" "5244ba0273a952a536e07abaad1fdf7c90d7ebb3647f36269c23bfd1cf20b0b8" "9b9d7a851a8e26f294e778e02c8df25c8a3b15170e6f9fd6965ac5f2544ef2a9" "166a2faa9dc5b5b3359f7a31a09127ebf7a7926562710367086fcc8fc72145da" "7de64ff2bb2f94d7679a7e9019e23c3bf1a6a04ba54341c36e7cf2d2e56e2bcc" "720838034f1dd3b3da66f6bd4d053ee67c93a747b219d1c546c41c4e425daf93" "6963de2ec3f8313bb95505f96bf0cf2025e7b07cefdb93e3d2e348720d401425" "2f8af2a3a2fae6b6ea254e7aab6f3a8b5c936428b67869cef647c5f8e7985877" "4990532659bb6a285fee01ede3dfa1b1bdf302c5c3c8de9fad9b6bc63a9252f7" "0d2c5679b6d087686dcfd4d7e57ed8e8aedcccc7f1a478cd69704c02e4ee36fe" "0f1341c0096825b1e5d8f2ed90996025a0d013a0978677956a9e61408fcd2c77" "d97ac0baa0b67be4f7523795621ea5096939a47e8b46378f79e78846e0e4ad3d" "21d2bf8d4d1df4859ff94422b5e41f6f2eeff14dd12f01428fa3cb4cb50ea0fb" "87fa3605a6501f9b90d337ed4d832213155e3a2e36a512984f83e847102a42f4" "7771c8496c10162220af0ca7b7e61459cb42d18c35ce272a63461c0fc1336015" "7c3d62a64bafb2cc95cd2de70f7e4446de85e40098ad314ba2291fc07501b70c" "b99ff6bfa13f0273ff8d0d0fd17cc44fab71dfdc293c7a8528280e690f084ef0" "e4a702e262c3e3501dfe25091621fe12cd63c7845221687e36a79e17cf3a67e0" "e8bd9bbf6506afca133125b0be48b1f033b1c8647c628652ab7a2fe065c10ef0" "fffef514346b2a43900e1c7ea2bc7d84cbdd4aa66c1b51946aade4b8d343b55a" "d12b1d9b0498280f60e5ec92e5ecec4b5db5370d05e787bc7cc49eae6fb07bc0" "2b501400e19b1dd09d8b3708cefcb5227fda580754051a24e8abf3aff0601f87" "e14884c30d875c64f6a9cdd68fe87ef94385550cab4890182197b95d53a7cf40" "32f22d075269daabc5e661299ca9a08716aa8cda7e85310b9625c434041916af" "02d422e5b99f54bd4516d4157060b874d14552fe613ea7047c4a5cfa1288cf4f" "8c7e832be864674c220f9a9361c851917a93f921fedb7717b1b5ece47690c098" "aec7b55f2a13307a55517fdf08438863d694550565dee23181d2ebd973ebd6b8" "7964b513f8a2bb14803e717e0ac0123f100fb92160dcf4a467f530868ebaae3e" "6e33d3dd48bc8ed38fd501e84067d3c74dfabbfc6d345a92e24f39473096da3f" "ffafb0e9f63935183713b204c11d22225008559fa62133a69848835f4f4a758c" "10e5d4cc0f67ed5cafac0f4252093d2119ee8b8cb449e7053273453c1a1eb7cc" "dccf4a8f1aaf5f24d2ab63af1aa75fd9d535c83377f8e26380162e888be0c6a9" "b5fd9c7429d52190235f2383e47d340d7ff769f141cd8f9e7a4629a81abc6b19" "014cb63097fc7dbda3edf53eb09802237961cbb4c9e9abd705f23b86511b0a69" "dd4582661a1c6b865a33b89312c97a13a3885dc95992e2e5fc57456b4c545176" "e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "db3e80842b48f9decb532a1d74e7575716821ee631f30267e4991f4ba2ddf56e" "7d708f0168f54b90fc91692811263c995bebb9f68b8b7525d0e2200da9bc903c" "6084dce7da6b7447dcb9f93a981284dc823bab54f801ebf8a8e362a5332d2753" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "6b80b5b0762a814c62ce858e9d72745a05dd5fc66f821a1c5023b4f2a76bc910" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "711efe8b1233f2cf52f338fd7f15ce11c836d0b6240a18fffffc2cbd5bfe61b0" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "77113617a0642d74767295c4408e17da3bfd9aa80aaa2b4eeb34680f6172d71a" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "fce3524887a0994f8b9b047aef9cc4cc017c5a93a5fb1f84d300391fba313743" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "c086fe46209696a2d01752c0216ed72fd6faeabaaaa40db9fc1518abebaf700d" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "71e5acf6053215f553036482f3340a5445aee364fb2e292c70d9175fb0cc8af7" "d74c5485d42ca4b7f3092e50db687600d0e16006d8fa335c69cf4f379dbd0eee" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "5036346b7b232c57f76e8fb72a9c0558174f87760113546d3a9838130f1cdb74" "74ba9ed7161a26bfe04580279b8cad163c00b802f54c574bfa5d924b99daa4b9" "d6603a129c32b716b3d3541fc0b6bfe83d0e07f1954ee64517aa62c9405a3441" "4a8d4375d90a7051115db94ed40e9abb2c0766e80e228ecad60e06b3b397acab" "6c9cbcdfd0e373dc30197c5059f79c25c07035ff5d0cc42aa045614d3919dab4" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "188fed85e53a774ae62e09ec95d58bb8f54932b3fd77223101d036e3564f9206" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" default))
 '(fci-rule-color "#37474F")
 '(ispell-dictionary nil)
 '(jdee-db-active-breakpoint-face-colors (cons "#171F24" "#237AD3"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#171F24" "#579C4C"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#171F24" "#777778"))
 '(objed-cursor-color "#D16969")
 '(package-selected-packages
   '(slime slime-company pyvenv auto-package-update all-the-icons visual-fill-column org-bullets magit counsel-projectile general treemacs-all-the-icons ansible terraform-mode helpful ivy-rich which-key rainbow-delimiters doom-themes doom doom-modeline counsel swiper ivy use-package org paredit projectile clojure-mode-extra-font-locking cider))
 '(pdf-view-midnight-colors (cons "#d4d4d4" "#1e1e1e"))
 '(rustic-ansi-faces
   ["#1e1e1e" "#D16969" "#579C4C" "#D7BA7D" "#339CDB" "#C586C0" "#85DDFF" "#d4d4d4"])
 '(vc-annotate-background "#1e1e1e")
 '(vc-annotate-color-map
   (list
    (cons 20 "#579C4C")
    (cons 40 "#81a65c")
    (cons 60 "#acb06c")
    (cons 80 "#D7BA7D")
    (cons 100 "#d8ab79")
    (cons 120 "#d99c76")
    (cons 140 "#DB8E73")
    (cons 160 "#d38b8c")
    (cons 180 "#cc88a6")
    (cons 200 "#C586C0")
    (cons 220 "#c97ca3")
    (cons 240 "#cd7286")
    (cons 260 "#D16969")
    (cons 280 "#ba6c6c")
    (cons 300 "#a37070")
    (cons 320 "#8d7374")
    (cons 340 "#37474F")
    (cons 360 "#37474F")))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Install and configure paredit
(use-package paredit)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'clojure-mode-hook          'enable-paredit-mode)


;; Some basic visual seup below
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(setq inhibit-startup-message t)  ;; disable startup msg
(scroll-bar-mode -1)              ;; disable scrollbar
(tool-bar-mode -1)                ;; disable toolbar
(tooltip-mode -1)                 ;; disable tooltip mode
(set-fringe-mode 10)
(setq visible-bell t)

;; Set up font with icon support
(set-face-attribute 'default nil :font "Monospace-11")
(when (member "all-the-icons" (font-family-list))
  (set-fontset-font t '(#x2300 . #x27BF) "all-the-icons"))
(when (member "FontAwesome" (font-family-list))
  (set-fontset-font t '(#xf000 . #xf9ff) "FontAwesome"))

;; install and use ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
      	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; NOTE: The first time you load the configuration on new machine
;; you'll need to run the following command interactively so
;; that the mode line icons display correctly
;; M-x all-the-icons-install-fonts

;; Setup all-the-icons
(use-package all-the-icons
  :ensure t)

;; Configure doom-modeline with proper icon settings
(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-state-icon t
      doom-modeline-buffer-modification-icon t
      doom-modeline-time-icon t
      doom-modeline-enable-word-count nil)

;; Use the cool looking doom-modeline
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(column-number-mode)  ;; Show column number
(global-display-line-numbers-mode t)  ;; show line number

;; Disable line number for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook
		shell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Rainbow delimiter in programming mode
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))
;; Setup counsel
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Dont start searches with ^

;; Using helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-callable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package general)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch))

;; Org mode setup below
(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; Set faces for heading levels
(dolist (face '((org-level-1 . 1.2)
                (org-level-2 . 1.1)
                (org-level-3 . 1.05)
                (org-level-4 . 1.0)
                (org-level-5 . 1.1)
                (org-level-6 . 1.1)
                (org-level-7 . 1.1)
                (org-level-8 . 1.1)))
  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ...."
	org-hide-emphasis-markers t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-agenda-files
	'("/home/mrutyunjaya/Projects/Code/org-files/Birthdays.org"
	  "/home/mrutyunjaya/Projects/Code/org-files/Tasks.org"))
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-todo-keywords
	'((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)"))))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(global-set-key (kbd "C-x b") 'counsel-switch-buffer)
(electric-pair-mode 1)
(setq elfeed-feeds
      '("http://slackbuilds.org/rss/ChangeLog.rss"
	"http://nullprogram.com/feed/"
	"https://planet.emacslife.com/atom.xml"
	"https://xkcd.com/rss.xml"
	"https://distrowatch.com/news/dw.xml"))

(add-hook 'org-mode-hook
          (lambda () (face-remap-add-relative 'default :family "Monospace")))

;; Setup nerd-icons with proper configuration
(use-package nerd-icons
  :ensure t
  :config
  (setq nerd-icons-font-family "Nerd Font")
  ;; Auto-install nerd-fonts if they're missing
  (unless (member "FiraCode Nerd Font" (font-family-list))
    (message "Nerd fonts not found - please run: M-x nerd-icons-install-fonts")))

;; Configure doom-modeline to use nerd-icons
(setq doom-modeline-icon t
      doom-modeline-major-mode-icon t
      doom-modeline-major-mode-color-icon t
      doom-modeline-buffer-state-icon t
      doom-modeline-buffer-modification-icon t)
(show-paren-mode 1)
(require 'auto-package-update)
(auto-package-update-maybe)

;; (set-frame-parameter (selected-frame) 'alpha '(85 85))
;; (add-to-list 'default-frame-alist '(alpha 85 85))
(setq warning-minimum-level :error)

(add-hook 'clojure-mode-hook #'cider-mode)

;;==========================================
;; PYTHON DEVELOPMENT WORKSPACE
;; ==========================================

;; Enable virtualenv support for Python projects
(defun my/eglot-reconnect-python-buffers ()
  "Restart Eglot in every managed Python buffer after a virtualenv switch."
  (when (fboundp 'eglot-current-server)
    (dolist (buf (buffer-list))
      (with-current-buffer buf
        (when (and (derived-mode-p 'python-mode)
                   (eglot-current-server))
          (eglot-reconnect (eglot-current-server) t))))))

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1)
  ;; pyvenv's hook variable is plural, so use-package's `:hook' cannot target it.
  (add-hook 'pyvenv-post-activate-hooks #'my/eglot-reconnect-python-buffers))

;; Start Eglot for Python files and use pylsp for diagnostics
(use-package eglot
  :ensure t
  ;; Hooks run before the package loads to trigger auto-start
  :hook ((python-mode . eglot-ensure)
         (eglot-managed-mode . (lambda ()
                                 (flymake-mode 1)
                                 (add-to-list 'company-backends 'company-capf))))
  :config
  (add-to-list 'eglot-server-programs '(python-mode . ("pylsp")))
  (setq eglot-report-progress nil))

;; Python editing defaults and keybindings
(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-shell-interpreter "python3"
        python-indent-offset 4)
  :bind (:map python-mode-map
              ("C-c C-p" . run-python)
              ("C-c C-c" . python-shell-send-buffer)
              ("C-c d" . flymake-show-diagnostics-buffer)))

;; Configure flymake and eldoc for mini-buffer echo
(setq flymake-fringe-indicator-position 'left-fringe)

;; Tweak Eldoc behavior for cleaner mini-buffer echoing
(setq eldoc-idle-delay 0.1          ; Show errors almost instantly (default is 0.5)
      eldoc-echo-area-use-multiline-p t) ; Allow multi-line errors to show fully
