Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5A3DC433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 12:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98ED8216B7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 12:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EVNSZNv5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfHFMhe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 08:37:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55338 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfHFMhe (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 08:37:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so78024631wmj.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Aug 2019 05:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1tH/KCQExV3nxOz9/nSYKEBJPwWtQJQogL7M9j+Pt8=;
        b=EVNSZNv5LtBK+5lwZWUJ2Yuq2jyeNGtHGaYoOzGjVbtzIjS6Gq5NyzXukmnpjfjqsC
         uBi6+Yb9yjLpCN3J4mLfd4jreBTrQ0QtzC0diJtFU0Ss3XXZ2EwFCJ/CkXQDYv8gMnAe
         Jd0aV8PAmJPywr4ZhVZJOmKka/BZYC8cEhW64dR4HyBsC/kwFKH3FQGXFOUF8Jege5Mq
         seYX3oYrFQZcJQKZo9Q/9+X9Hho+z8fOwSovYTJOk20jo4Kg0WC/dDkJzMtKzYconMKn
         27v0bJ8trerX0vLGzC4HlgxBcbwlrLJ7rlYtdOncy84NiylG+ZSlg0UqhZ9c9sZY6Q7F
         2tFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B1tH/KCQExV3nxOz9/nSYKEBJPwWtQJQogL7M9j+Pt8=;
        b=oI5s9snyJ9G7bgfUj8Htj5JgtbaBj9qymlZORFplX5P/JKBJ0Vd4xBLHdRvGQYNZcP
         Zg9Vlq0dIv62IxXSpxaAd8KrHpXFMELVerEbWysTh3ZT+0xavyRYu5RFBv4RehmgOzvz
         YnWg6VEeXLpaOd+nujprQfLHeykjsICwarOux0ce5VWjd6upm5/67Z3dtqRr+ZdHfP2H
         N50zwctm0opx3SouMyyCOphbhfv5IlF7xBnaIsSNZCcrp9bQeCc9WTJ+kydnz3hmCxMR
         iHcTTTWWOKfhxXRD7Byj5gP164o1VWTqxZGGafqwPxC0a1wblvhX4DkutSpyazGSZb5Y
         LTuw==
X-Gm-Message-State: APjAAAXKArS5WVUsoOyfF9OgYkmDO3RZFqvYr3qr7HZ1VManP7xXOAW7
        exF49GOeE5efdp0nh/p1EzAJGSNYuEI=
X-Google-Smtp-Source: APXvYqz4fjxGXZKv8ofEalemtR/2YLZwzUrSk3sRI7aZEhdgseg0ew3PM6aaDxA0MQExxBbNS+M3fA==
X-Received: by 2002:a1c:ca06:: with SMTP id a6mr4761659wmg.48.1565095050109;
        Tue, 06 Aug 2019 05:37:30 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id e4sm2094586wrh.39.2019.08.06.05.37.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 05:37:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2] kernel-shark: Separate trace-cmd and kernelshark documentations.
Date:   Tue,  6 Aug 2019 15:37:27 +0300
Message-Id: <20190806123727.25705-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KernelShark is going to be a stand alone package, separate from trace-cmd.
The code is already in its own directory, but HTML and man page documents
are still not separated.
All KernelShark related documentation (HTML and the man page) is moved
from Documentation/ to kernel-shark/Documentation/ directory.
New targets are added to trace-cmd Makefile:
 doc_gui - build KernelShrak documentation
 doc_gui_clean - clean KernelShrak documentation
 install_doc_gui - install KernelShrak documentation
The existing Makefile targets:
 doc, doc_clean, install_doc
are modified to work only with trace-cmd documentation.
The new Makefile targets must be used to build and install KernelShark docs.

This change was requested by Bas van Dijk <v.dijk.bas@gmail.com>, to
simplify packaging trace-cmd and kernelshark for nixpkgs, as two
different packages.

The existing kernel-shark/doc directory is used when doxygen documentation
is generated. All doxygen related files - doxygen config and doxygen output
files are moved to kernel-shark/Documentation/doxygen.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
[
 v2 changes:
  - Renamed kernel-shark/doc/ kernel-shark/Documentation/
  - Moved kernel-shark doxygen files from kernel-shark/doc/ to
    kernel-shark/Documentation/doxygen/
]

 Documentation/Makefile                        |  20 +---
 Makefile                                      |   9 +-
 kernel-shark/CMakeLists.txt                   |   8 +-
 .../HTML/images/kernelshark-logo.svg          |   0
 .../HTML/images/kernelshark.jpg               | Bin
 .../HTML/images/kshark-advance-filter-01.png  | Bin
 .../HTML/images/kshark-advance-filter-02.png  | Bin
 .../images/kshark-advance-filter-delete.png   | Bin
 .../kshark-advance-filter-ext4-events.png     | Bin
 .../images/kshark-advance-filter-ext4.png     | Bin
 .../images/kshark-event-filter-dialog.png     | Bin
 .../HTML/images/kshark-event-filter.png       | Bin
 .../HTML/images/kshark-filter-menu.png        | Bin
 .../HTML/images/kshark-graph-control-left.png | Bin
 .../HTML/images/kshark-graph-control-line.png | Bin
 .../images/kshark-graph-control-minus.png     | Bin
 .../kshark-graph-control-minusminus.png       | Bin
 .../HTML/images/kshark-graph-control-plus.png | Bin
 .../images/kshark-graph-control-plusplus.png  | Bin
 .../images/kshark-graph-control-right.png     | Bin
 .../HTML/images/kshark-graph-info-line.png    | Bin
 .../HTML/images/kshark-graph-plot-area.png    | Bin
 .../HTML/images/kshark-graph-plot-title.png   | Bin
 .../HTML/images/kshark-list-adjust.png        | Bin
 .../HTML/images/kshark-list-graph-follow.png  | Bin
 .../HTML/images/kshark-list-info-area.png     | Bin
 .../HTML/images/kshark-open.png               | Bin
 .../HTML/images/kshark-plot-cpu-1.png         | Bin
 .../HTML/images/kshark-plot-cpu-2.png         | Bin
 .../HTML/images/kshark-plot-cpu-result.png    | Bin
 .../HTML/images/kshark-plot-menu.png          | Bin
 .../kshark-plot-task-measure-preempt.png      | Bin
 .../HTML/images/kshark-plot-task-measure.png  | Bin
 .../HTML/images/kshark-plot-task-result.png   | Bin
 .../HTML/images/kshark-plot-task-select.png   | Bin
 .../HTML/images/kshark-plot-task-zoom-1.png   | Bin
 .../HTML/images/kshark-select-a-1.png         | Bin
 .../HTML/images/kshark-select-b-1.png         | Bin
 .../HTML/images/kshark-task-filter-dialog.png | Bin
 .../HTML/images/kshark-task-filter.png        | Bin
 .../HTML/images/kshark-zoom-in-3.png          | Bin
 .../HTML/images/kshark-zoom-in-select.png     | Bin
 .../Documentation}/HTML/index.html            |   0
 kernel-shark/Documentation/Makefile           | 108 ++++++++++++++++++
 .../{doc => Documentation/doxygen}/dox_config |   0
 .../Documentation}/kernelshark.1.txt          |   0
 46 files changed, 121 insertions(+), 24 deletions(-)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kernelshark-logo.svg (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kernelshark.jpg (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-advance-filter-01.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-advance-filter-02.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-advance-filter-delete.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-advance-filter-ext4-events.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-advance-filter-ext4.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-event-filter-dialog.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-event-filter.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-filter-menu.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-left.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-line.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-minus.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-minusminus.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-plus.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-plusplus.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-control-right.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-info-line.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-plot-area.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-graph-plot-title.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-list-adjust.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-list-graph-follow.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-list-info-area.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-open.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-cpu-1.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-cpu-2.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-cpu-result.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-menu.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-task-measure-preempt.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-task-measure.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-task-result.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-task-select.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-plot-task-zoom-1.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-select-a-1.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-select-b-1.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-task-filter-dialog.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-task-filter.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-zoom-in-3.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/images/kshark-zoom-in-select.png (100%)
 rename {Documentation => kernel-shark/Documentation}/HTML/index.html (100%)
 create mode 100644 kernel-shark/Documentation/Makefile
 rename kernel-shark/{doc => Documentation/doxygen}/dox_config (100%)
 rename {Documentation => kernel-shark/Documentation}/kernelshark.1.txt (100%)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 21e42fd..f2c3264 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -90,25 +90,7 @@ $(MAN1_INSTALL): %.1.install : %.1 force
 $(MAN5_INSTALL): %.5.install : %.5 force
 	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man5)
 
-html_dir = $(src)/HTML
-image_dir = $(html_dir)/images
-
-HTML = $(wildcard $(html_dir)/*.html)
-IMGS = $(wildcard $(image_dir)/*.png)
-
-HTML_INSTALL = $(subst .html,.html.install,$(HTML))
-IMGS_INSTALL = $(subst .png,.png.install,$(IMGS))
-
-$(HTML_INSTALL): %.html.install : %.html force
-	$(Q)$(call do_install_data,$<,'$(html_install_SQ)')
-
-$(IMGS_INSTALL): %.png.install : %.png force
-	$(Q)$(call do_install_data,$<,'$(img_install_SQ)')
-
-
-GUI_INSTALL = $(HTML_INSTALL) $(IMGS_INSTALL)
-
-install: $(MAN1_INSTALL) $(MAN5_INSTALL) $(GUI_INSTALL)
+install: $(MAN1_INSTALL) $(MAN5_INSTALL)
 
 clean:
 	(cd $(obj); \
diff --git a/Makefile b/Makefile
index 3afd982..bcf96b7 100644
--- a/Makefile
+++ b/Makefile
@@ -174,7 +174,7 @@ obj		:= $(objtree)
 
 kshark-dir	= $(src)/kernel-shark
 
-export prefix bindir src obj
+export prefix bindir src obj kshark-dir
 
 LIBS = -ldl
 
@@ -356,12 +356,19 @@ install_libs: libs
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
+doc_gui:
+	$(MAKE) -C $(kshark-dir)/Documentation all
+
 
 doc_clean:
 	$(MAKE) -C $(src)/Documentation clean
+doc_gui_clean:
+	$(MAKE) -C $(kshark-dir)/Documentation clean
 
 install_doc:
 	$(MAKE) -C $(src)/Documentation install
+install_doc_gui:
+	$(MAKE) -C $(kshark-dir)/Documentation install
 
 clean:
 	$(RM) *.o *~ *.a *.so .*.d
diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
index 035ef5b..24c669f 100644
--- a/kernel-shark/CMakeLists.txt
+++ b/kernel-shark/CMakeLists.txt
@@ -92,12 +92,12 @@ if (_DOXYGEN_DOC AND DOXYGEN_FOUND)
     add_custom_target(doc ALL)
     add_custom_command(TARGET doc
                        COMMAND doxygen dox_config > dox_build.log
-                       WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/doc)
+                       WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/Documentation/doxygen)
 
     set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES
-                                          "${KS_DIR}/doc/dox_build.log"
-                                          "${KS_DIR}/doc/html"
-                                          "${KS_DIR}/doc/latex")
+                             "${KS_DIR}/Documentation/doxygen/dox_build.log"
+                             "${KS_DIR}/Documentation/doxygen/html"
+                             "${KS_DIR}/Documentation/doxygen/latex")
 
 endif ()
 
diff --git a/Documentation/HTML/images/kernelshark-logo.svg b/kernel-shark/Documentation/HTML/images/kernelshark-logo.svg
similarity index 100%
rename from Documentation/HTML/images/kernelshark-logo.svg
rename to kernel-shark/Documentation/HTML/images/kernelshark-logo.svg
diff --git a/Documentation/HTML/images/kernelshark.jpg b/kernel-shark/Documentation/HTML/images/kernelshark.jpg
similarity index 100%
rename from Documentation/HTML/images/kernelshark.jpg
rename to kernel-shark/Documentation/HTML/images/kernelshark.jpg
diff --git a/Documentation/HTML/images/kshark-advance-filter-01.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-01.png
similarity index 100%
rename from Documentation/HTML/images/kshark-advance-filter-01.png
rename to kernel-shark/Documentation/HTML/images/kshark-advance-filter-01.png
diff --git a/Documentation/HTML/images/kshark-advance-filter-02.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-02.png
similarity index 100%
rename from Documentation/HTML/images/kshark-advance-filter-02.png
rename to kernel-shark/Documentation/HTML/images/kshark-advance-filter-02.png
diff --git a/Documentation/HTML/images/kshark-advance-filter-delete.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-delete.png
similarity index 100%
rename from Documentation/HTML/images/kshark-advance-filter-delete.png
rename to kernel-shark/Documentation/HTML/images/kshark-advance-filter-delete.png
diff --git a/Documentation/HTML/images/kshark-advance-filter-ext4-events.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4-events.png
similarity index 100%
rename from Documentation/HTML/images/kshark-advance-filter-ext4-events.png
rename to kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4-events.png
diff --git a/Documentation/HTML/images/kshark-advance-filter-ext4.png b/kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4.png
similarity index 100%
rename from Documentation/HTML/images/kshark-advance-filter-ext4.png
rename to kernel-shark/Documentation/HTML/images/kshark-advance-filter-ext4.png
diff --git a/Documentation/HTML/images/kshark-event-filter-dialog.png b/kernel-shark/Documentation/HTML/images/kshark-event-filter-dialog.png
similarity index 100%
rename from Documentation/HTML/images/kshark-event-filter-dialog.png
rename to kernel-shark/Documentation/HTML/images/kshark-event-filter-dialog.png
diff --git a/Documentation/HTML/images/kshark-event-filter.png b/kernel-shark/Documentation/HTML/images/kshark-event-filter.png
similarity index 100%
rename from Documentation/HTML/images/kshark-event-filter.png
rename to kernel-shark/Documentation/HTML/images/kshark-event-filter.png
diff --git a/Documentation/HTML/images/kshark-filter-menu.png b/kernel-shark/Documentation/HTML/images/kshark-filter-menu.png
similarity index 100%
rename from Documentation/HTML/images/kshark-filter-menu.png
rename to kernel-shark/Documentation/HTML/images/kshark-filter-menu.png
diff --git a/Documentation/HTML/images/kshark-graph-control-left.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-left.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-left.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-left.png
diff --git a/Documentation/HTML/images/kshark-graph-control-line.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-line.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-line.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-line.png
diff --git a/Documentation/HTML/images/kshark-graph-control-minus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-minus.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-minus.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-minus.png
diff --git a/Documentation/HTML/images/kshark-graph-control-minusminus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-minusminus.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-minusminus.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-minusminus.png
diff --git a/Documentation/HTML/images/kshark-graph-control-plus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-plus.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-plus.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-plus.png
diff --git a/Documentation/HTML/images/kshark-graph-control-plusplus.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-plusplus.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-plusplus.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-plusplus.png
diff --git a/Documentation/HTML/images/kshark-graph-control-right.png b/kernel-shark/Documentation/HTML/images/kshark-graph-control-right.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-control-right.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-control-right.png
diff --git a/Documentation/HTML/images/kshark-graph-info-line.png b/kernel-shark/Documentation/HTML/images/kshark-graph-info-line.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-info-line.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-info-line.png
diff --git a/Documentation/HTML/images/kshark-graph-plot-area.png b/kernel-shark/Documentation/HTML/images/kshark-graph-plot-area.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-plot-area.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-plot-area.png
diff --git a/Documentation/HTML/images/kshark-graph-plot-title.png b/kernel-shark/Documentation/HTML/images/kshark-graph-plot-title.png
similarity index 100%
rename from Documentation/HTML/images/kshark-graph-plot-title.png
rename to kernel-shark/Documentation/HTML/images/kshark-graph-plot-title.png
diff --git a/Documentation/HTML/images/kshark-list-adjust.png b/kernel-shark/Documentation/HTML/images/kshark-list-adjust.png
similarity index 100%
rename from Documentation/HTML/images/kshark-list-adjust.png
rename to kernel-shark/Documentation/HTML/images/kshark-list-adjust.png
diff --git a/Documentation/HTML/images/kshark-list-graph-follow.png b/kernel-shark/Documentation/HTML/images/kshark-list-graph-follow.png
similarity index 100%
rename from Documentation/HTML/images/kshark-list-graph-follow.png
rename to kernel-shark/Documentation/HTML/images/kshark-list-graph-follow.png
diff --git a/Documentation/HTML/images/kshark-list-info-area.png b/kernel-shark/Documentation/HTML/images/kshark-list-info-area.png
similarity index 100%
rename from Documentation/HTML/images/kshark-list-info-area.png
rename to kernel-shark/Documentation/HTML/images/kshark-list-info-area.png
diff --git a/Documentation/HTML/images/kshark-open.png b/kernel-shark/Documentation/HTML/images/kshark-open.png
similarity index 100%
rename from Documentation/HTML/images/kshark-open.png
rename to kernel-shark/Documentation/HTML/images/kshark-open.png
diff --git a/Documentation/HTML/images/kshark-plot-cpu-1.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-1.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-cpu-1.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-cpu-1.png
diff --git a/Documentation/HTML/images/kshark-plot-cpu-2.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-2.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-cpu-2.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-cpu-2.png
diff --git a/Documentation/HTML/images/kshark-plot-cpu-result.png b/kernel-shark/Documentation/HTML/images/kshark-plot-cpu-result.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-cpu-result.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-cpu-result.png
diff --git a/Documentation/HTML/images/kshark-plot-menu.png b/kernel-shark/Documentation/HTML/images/kshark-plot-menu.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-menu.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-menu.png
diff --git a/Documentation/HTML/images/kshark-plot-task-measure-preempt.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure-preempt.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-task-measure-preempt.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-task-measure-preempt.png
diff --git a/Documentation/HTML/images/kshark-plot-task-measure.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-measure.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-task-measure.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-task-measure.png
diff --git a/Documentation/HTML/images/kshark-plot-task-result.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-result.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-task-result.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-task-result.png
diff --git a/Documentation/HTML/images/kshark-plot-task-select.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-select.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-task-select.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-task-select.png
diff --git a/Documentation/HTML/images/kshark-plot-task-zoom-1.png b/kernel-shark/Documentation/HTML/images/kshark-plot-task-zoom-1.png
similarity index 100%
rename from Documentation/HTML/images/kshark-plot-task-zoom-1.png
rename to kernel-shark/Documentation/HTML/images/kshark-plot-task-zoom-1.png
diff --git a/Documentation/HTML/images/kshark-select-a-1.png b/kernel-shark/Documentation/HTML/images/kshark-select-a-1.png
similarity index 100%
rename from Documentation/HTML/images/kshark-select-a-1.png
rename to kernel-shark/Documentation/HTML/images/kshark-select-a-1.png
diff --git a/Documentation/HTML/images/kshark-select-b-1.png b/kernel-shark/Documentation/HTML/images/kshark-select-b-1.png
similarity index 100%
rename from Documentation/HTML/images/kshark-select-b-1.png
rename to kernel-shark/Documentation/HTML/images/kshark-select-b-1.png
diff --git a/Documentation/HTML/images/kshark-task-filter-dialog.png b/kernel-shark/Documentation/HTML/images/kshark-task-filter-dialog.png
similarity index 100%
rename from Documentation/HTML/images/kshark-task-filter-dialog.png
rename to kernel-shark/Documentation/HTML/images/kshark-task-filter-dialog.png
diff --git a/Documentation/HTML/images/kshark-task-filter.png b/kernel-shark/Documentation/HTML/images/kshark-task-filter.png
similarity index 100%
rename from Documentation/HTML/images/kshark-task-filter.png
rename to kernel-shark/Documentation/HTML/images/kshark-task-filter.png
diff --git a/Documentation/HTML/images/kshark-zoom-in-3.png b/kernel-shark/Documentation/HTML/images/kshark-zoom-in-3.png
similarity index 100%
rename from Documentation/HTML/images/kshark-zoom-in-3.png
rename to kernel-shark/Documentation/HTML/images/kshark-zoom-in-3.png
diff --git a/Documentation/HTML/images/kshark-zoom-in-select.png b/kernel-shark/Documentation/HTML/images/kshark-zoom-in-select.png
similarity index 100%
rename from Documentation/HTML/images/kshark-zoom-in-select.png
rename to kernel-shark/Documentation/HTML/images/kshark-zoom-in-select.png
diff --git a/Documentation/HTML/index.html b/kernel-shark/Documentation/HTML/index.html
similarity index 100%
rename from Documentation/HTML/index.html
rename to kernel-shark/Documentation/HTML/index.html
diff --git a/kernel-shark/Documentation/Makefile b/kernel-shark/Documentation/Makefile
new file mode 100644
index 0000000..4bb4fe3
--- /dev/null
+++ b/kernel-shark/Documentation/Makefile
@@ -0,0 +1,108 @@
+
+obj := $(kshark-dir)/Documentation
+src := $(kshark-dir)/Documentation
+
+ifeq ($(VERBOSE),1)
+  Q =
+  print_asciidoc =
+  print_xsltproc =
+  print_install =
+  hide_xsltproc_output =
+else
+  Q = @
+  print_asciidoc =		echo '      ASCIIDOC            '`basename $@`;
+  print_xsltproc =		echo '      XSLTPROC            '`basename $@`;
+  print_install =		echo '      INSTALL             '`basename $1`'	to	$(DESTDIR_SQ)'$2;
+  hide_xsltproc_output = 2> /dev/null
+endif
+
+define manpage.xsl
+	if [ -z ${MANPAGE_DOCBOOK_XSL} ]; then 			\
+		echo "*********************************";	\
+		echo "** No docbook.xsl is installed **";	\
+		echo "** Can't make man pages        **";	\
+		echo "*********************************";	\
+		exit 1;						\
+	fi
+endef
+
+do_asciidoc_build =				\
+	($(print_asciidoc)			\
+	 asciidoc -d manpage -b docbook -o $@ $<)
+
+do_xsltproc_build =				\
+	($(print_xsltproc)			\
+	 xsltproc --nonet -o $@ ${MANPAGE_DOCBOOK_XSL} $< $(hide_xsltproc_output))
+
+#
+# asciidoc requires a synopsis, but file format man pages (5) do
+# not require them. This removes it from the file in the final step.
+define remove_synopsis
+	(sed -e '/^\.SH "SYNOPSIS"/,/ignore/d' $1 > $1.tmp;\
+	 mv $1.tmp $1)
+endef
+
+#
+# Most likely a docbook.xsl is already installed on the users system
+# instead of creating a new wheel, lets reuse what's already there.
+#
+FIND_MANPAGE_DOCBOOK_XSL :=  $(shell find /usr -name docbook.xsl 2>/dev/null | grep manpages | head -1)
+
+MANPAGE_DOCBOOK_XSL ?= ${FIND_MANPAGE_DOCBOOK_XSL}
+
+$(obj)/%.xsl: $(src)/%.txt
+	$(Q)mkdir -p $(obj)
+	$(Q)$(do_asciidoc_build)
+
+
+$(obj)/%.1: $(obj)/%.1.xsl
+	@$(call manpage.xsl)
+	$(Q)$(do_xsltproc_build)
+
+TEXT1 = $(wildcard *.1.txt)
+MAN1 = $(patsubst %.1.txt,$(obj)/%.1, ${TEXT1})
+
+all: $(MAN1)
+
+# Need to find out how to export a macro instead of
+# copying this from the main Makefile.
+define do_install_data
+	$(print_install)				\
+	if [ ! -d '$(DESTDIR_SQ)$2' ]; then		\
+		$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$2';	\
+	fi;						\
+	$(INSTALL) -m 644 $1 '$(DESTDIR_SQ)$2'
+endef
+
+
+MAN1_INSTALL = $(MAN1:%.1=%.1.install)
+
+$(MAN1_INSTALL): %.1.install : %.1 force
+	$(Q)$(call do_install_data,$<,$(man_dir_SQ)/man1)
+
+html_dir = $(src)/HTML
+image_dir = $(html_dir)/images
+
+HTML = $(wildcard $(html_dir)/*.html)
+IMGS = $(wildcard $(image_dir)/*.png)
+
+HTML_INSTALL = $(subst .html,.html.install,$(HTML))
+IMGS_INSTALL = $(subst .png,.png.install,$(IMGS))
+
+$(HTML_INSTALL): %.html.install : %.html force
+	$(Q)$(call do_install_data,$<,'$(html_install_SQ)')
+
+$(IMGS_INSTALL): %.png.install : %.png force
+	$(Q)$(call do_install_data,$<,'$(img_install_SQ)')
+
+
+GUI_INSTALL = $(HTML_INSTALL) $(IMGS_INSTALL)
+
+install: $(MAN1_INSTALL) $(GUI_INSTALL)
+
+clean:
+	(cd $(obj); \
+	 $(RM) *.xml *.xsl *.1)
+
+.PHONE: force
+force:
diff --git a/kernel-shark/doc/dox_config b/kernel-shark/Documentation/doxygen/dox_config
similarity index 100%
rename from kernel-shark/doc/dox_config
rename to kernel-shark/Documentation/doxygen/dox_config
diff --git a/Documentation/kernelshark.1.txt b/kernel-shark/Documentation/kernelshark.1.txt
similarity index 100%
rename from Documentation/kernelshark.1.txt
rename to kernel-shark/Documentation/kernelshark.1.txt
-- 
2.21.0

