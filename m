Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934C9C433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 09:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E20321D79
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 09:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhADJKZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 04:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADJKZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 04:10:25 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1F9C061574
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 01:09:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id q75so18599691wme.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 01:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d1Vk3mUV3OWgnFdb6gZh3ZNHopBMWJQC9YWHNQev5eY=;
        b=JDABWYUx5yZLLbXZbpFSMdN5cM/rY3ochheLJ5Wx0NMRsjQVGTJ4KSGpwvRYHxofsC
         864hTQSe8jC6AnXPWdEfD3Jdjmb/4bnYYpRKoQHmiW4WuF7ICU2eACR3vdHX10QVm6zr
         q6FOB18JvcaIw/vYM717Tbe0jihMgPuZZ40XqIxoEQxneWJyBqeC/30Z9Hvvua1prZNl
         XU36WfIMCdngNlOBc6oDQ0srjYKO9ze3thhk70CYx2n3BnAPzaJ0kX79h+GeN8N4LPCR
         +BcThaf+JHDg37s0hpl31w4WKxinHbE6S1b7455kY3v+OtQmwnsxabUcGh5bCbR5O2nr
         4aEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d1Vk3mUV3OWgnFdb6gZh3ZNHopBMWJQC9YWHNQev5eY=;
        b=I55ApmOS20FkSP5LZlKh8PAENcKk1nW5BQ64uB/QFvoP2YumC9JYJFgvot6Inry87H
         83GR/psX8P/u99O+DT23piIK9x4oeEA4W8/8/jh56IaeqBZx4NoL/SNIfUEWHu9iX2MQ
         0fIJntt/VGvTFaCB95DKCBO8qoM5bqDP4YF+BO0bXGpv2ZqlRGoXac7A7VDBr67+q3/k
         cSobMHANf9donURfDwRnCPUsfLowpC99tnphH9ovBYHFwR4lSDTY9V0atG9fMpmGryN6
         Yl4GP1ZdTY/uhfhx+7xiIxsD4qcrhzvq40qTOnwj5GyaL0KyoELVMxi4zfrEY+iILock
         k8HA==
X-Gm-Message-State: AOAM532Zvr456Jga9Hx7pLd1GfqP0Oo/dlTCfMa0q+CrvN0I9iTo/VtG
        OGJXLqklc2QcJrrSP0whvU0=
X-Google-Smtp-Source: ABdhPJxy8kQyAxt4ycgBsekah3pSNYRjokqnh23Lgl1oaMHnQIrrTndexQFAxSmFPi5Q5hvXsRn+cQ==
X-Received: by 2002:a1c:2155:: with SMTP id h82mr25722387wmh.132.1609751383929;
        Mon, 04 Jan 2021 01:09:43 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id 138sm35041840wma.41.2021.01.04.01.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 01:09:43 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sudipm.mukherjee@gmail.com, linux-trace-devel@vger.kernel.org
Subject: [PATCH] libtracefs: Fix Documentation Makefile
Date:   Mon,  4 Jan 2021 11:09:41 +0200
Message-Id: <20210104090941.424254-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The libtracefs documentation install failes due to missing functions
used in the Makefile. It was coppied from libtraceevent/Documentation,
but not all of the required functions exist in the tracefs build
scripts.

Reported-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/Makefile | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/Documentation/Makefile b/Documentation/Makefile
index e9212df..72b6939 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -45,19 +45,16 @@ ASCIIDOC_EXTRA += -a mansource="libtracefs" -a manmanual="libtracefs Manual"
 ASCIIDOC_HTML = xhtml5
 endif
 
-XMLTO=xmlto
-
-_tmp_tool_path := $(call get-executable,$(ASCIIDOC))
-ifeq ($(_tmp_tool_path),)
-	missing_tools = $(ASCIIDOC)
+ASCIIDOC_INSTALLED := $(shell command -v $(ASCIIDOC) 2> /dev/null)
+ifndef ASCIIDOC_INSTALLED
+	missing_tools += $(ASCIIDOC)
 endif
 
-ifndef USE_ASCIIDOCTOR
-_tmp_tool_path := $(call get-executable,$(XMLTO))
-ifeq ($(_tmp_tool_path),)
+XMLTO=xmlto
+XMLTO_INSTALLED := $(shell command -v $(XMLTO) 2> /dev/null)
+ifndef XMLTO_INSTALLED
 	missing_tools += $(XMLTO)
 endif
-endif
 
 #
 # For asciidoc ...
@@ -132,7 +129,7 @@ ifneq ($(V),1)
 endif
 endif
 
-all: html man
+all: check-man-tools html man
 
 man: man3
 man3: $(DOC_MAN3)
@@ -141,7 +138,7 @@ html: $(MAN_HTML)
 
 $(MAN_HTML) $(DOC_MAN3): asciidoc.conf
 
-install: install-man install-html
+install: check-man-tools install-man install-html
 
 check-man-tools:
 ifdef missing_tools
@@ -149,28 +146,22 @@ ifdef missing_tools
 endif
 
 do-install-man: man
-	$(call QUIET_INSTALL, Documentation-man) \
-		$(INSTALL) -d -m 755 $(DESTDIR)$(man3dir); \
-		$(INSTALL) -m 644 $(OUTPUT)*.3 $(DESTDIR)$(man3dir);
+	$(Q)$(call do_install,$(OUTPUT)*.3,$(DESTDIR)$(man3dir),644);
 
-install-man: check-man-tools man do-install-man
+install-man: man do-install-man
 
 do-install-html: html
-	$(call QUIET_INSTALL, Documentation-html) \
-		$(INSTALL) -d -m 755 $(DESTDIR)$(htmldir); \
-		$(INSTALL) -m 644 $(OUTPUT)*.html $(DESTDIR)$(htmldir);
+	$(Q)$(call do_install,$(OUTPUT)*.html,$(DESTDIR)$(htmldir),644);
 
-install-html: check-man-tools html do-install-html
+install-html: html do-install-html
 
 uninstall: uninstall-man uninstall-html
 
 uninstall-man:
-	$(call QUIET_UNINST, Documentation-man) \
-		$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(man3dir)/,$(DOC_MAN3))
 
 uninstall-html:
-	$(call QUIET_UNINST, Documentation-html) \
-		$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
+	$(Q)$(RM) $(addprefix $(DESTDIR)$(htmldir)/,$(MAN_HTML))
 
 ifdef missing_tools
   DO_INSTALL_MAN = $(warning Please install $(missing_tools) to have the man pages installed)
@@ -184,7 +175,7 @@ CLEAN_FILES =					\
 	$(DOC_MAN3) *.3
 
 clean:
-	$(call QUIET_CLEAN, Documentation) $(RM) $(CLEAN_FILES)
+	$(Q) $(RM) $(CLEAN_FILES)
 
 ifdef USE_ASCIIDOCTOR
 $(OUTPUT)%.3 : $(OUTPUT)%.txt
-- 
2.29.2

