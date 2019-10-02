Return-Path: <SRS0=PpJY=X3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CC78C35280
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59DBB21920
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Oct 2019 11:42:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="spnBnjd3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfJBLmA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 2 Oct 2019 07:42:00 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:37719 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726248AbfJBLmA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 2 Oct 2019 07:42:00 -0400
Received: by mail-wr1-f42.google.com with SMTP id i1so19285220wro.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 02 Oct 2019 04:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WRwdxbkoXQv7GO/PrgmAWRrVef7OWn2zVFHo3n/HC5o=;
        b=spnBnjd3u8ZnXPIHTVxN0mxU7axgpZ+m9s2cGm6LoAK/iKZ1qCYlIYLLyJttzYB+FM
         i3TCztE5zyq15Vrrw/zfYjj2VbbDdY8a1/B4PU5h1oFjokA4d13sm96nP5YUUMdCv17N
         5BYOhFKjsAIdcZtLFM9+aZhMTvMg1xVt0sg/wrcOn8Y7NJam6Mx/csJlvuHFJmGqSwba
         5sA7oHpomtuYmnIto0QkLyralvPLAm+4/yrFgaWtPaJcVYbtSD+/wC48rHzDpew2q3Yq
         LMwt4nwnl7p1a1FgBma4hEC2vvzqZRDId37LWzkhuYzKLU2jlIHbDOD7R/3Dfgdv2PLB
         geqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WRwdxbkoXQv7GO/PrgmAWRrVef7OWn2zVFHo3n/HC5o=;
        b=WBAY73RRZI/NYsdH5TxTOtx6krDfFgJikPnlOTo2+lCt0x7FGF9YHicl/BZ1HQXPq5
         r94UUeKwxq4hVtL1UTE78GPWHLx2GOdRrnFn8ozfxVKKAcS+W7wWAsIc2pCuxjiB6375
         kpGxVr4avZxDr8vQ7OfdTUgbww0JLnpCRfx/Ece+KKFn3XHr6MxOD0RPHOFIR0TdDogF
         Ndi4bx/y4/Ph6KoT8d7F6q6/ISBFTnWVY2R4WfoXMpKN2v9esqS9z5azmpNIZeoC32F5
         Lw/W02JnHL9KruCkMZ/d59JAC1zqIFSdmchxgtYkkp6iKsXZCkYTaFi0KuQGUe67yntr
         7ttw==
X-Gm-Message-State: APjAAAUSCoFktAuteWNpJYOXonAhZTelUoH4Y9UNtJUIFiKy7Y6NGcdv
        eyOon81zBofu3tSIM/mtxYqIG5sG
X-Google-Smtp-Source: APXvYqxpGOyx7MONVHyeqz0WmXcqo3wGLFEMNdMjupaw5mOZBjoEJmee0H5yzH45ytbfB7ZJegXq4A==
X-Received: by 2002:a5d:43c7:: with SMTP id v7mr1430250wrr.135.1570016516036;
        Wed, 02 Oct 2019 04:41:56 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id l4sm3004658wrw.6.2019.10.02.04.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 04:41:55 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/5] trace-cmd: Move libtraceevent plugins in its own directory.
Date:   Wed,  2 Oct 2019 14:41:48 +0300
Message-Id: <20191002114152.30048-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191002114152.30048-1-tz.stoyanov@gmail.com>
References: <20191002114152.30048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All existing plugins are moved from plugins/ to plugins/traceevent/
directory, as all of them (except plugin_python) are designed to be
used with the traceevent library. This change paves the way for
implementing trace-cmd specific plugins.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .gitignore                                    |  2 +-
 Makefile                                      | 28 +++++++++----------
 lib/trace-cmd/Makefile                        |  2 --
 {plugins => lib/traceevent/plugins}/Makefile  |  6 ++--
 .../traceevent/plugins}/plugin_blk.c          |  0
 .../traceevent/plugins}/plugin_cfg80211.c     |  0
 .../traceevent/plugins}/plugin_function.c     |  0
 .../traceevent/plugins}/plugin_futex.c        |  0
 .../traceevent/plugins}/plugin_hrtimer.c      |  0
 .../traceevent/plugins}/plugin_jbd2.c         |  0
 .../traceevent/plugins}/plugin_kmem.c         |  0
 .../traceevent/plugins}/plugin_kvm.c          |  0
 .../traceevent/plugins}/plugin_mac80211.c     |  0
 .../traceevent/plugins}/plugin_python.c       |  0
 .../traceevent/plugins}/plugin_sched_switch.c |  0
 .../traceevent/plugins}/plugin_scsi.c         |  0
 .../traceevent/plugins}/plugin_tlb.c          |  0
 .../traceevent/plugins}/plugin_xen.c          |  0
 18 files changed, 18 insertions(+), 20 deletions(-)
 rename {plugins => lib/traceevent/plugins}/Makefile (93%)
 rename {plugins => lib/traceevent/plugins}/plugin_blk.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_cfg80211.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_function.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_futex.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_hrtimer.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_jbd2.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_kmem.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_kvm.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_mac80211.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_python.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_sched_switch.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_scsi.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_tlb.c (100%)
 rename {plugins => lib/traceevent/plugins}/plugin_xen.c (100%)

diff --git a/.gitignore b/.gitignore
index b7b405f..20bb5a3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -18,5 +18,5 @@ ctracecmdgui_wrap.c
 tags
 TAGS
 cscope*
-trace_plugin_dir
+traceevent_plugin_dir
 trace_python_dir
diff --git a/Makefile b/Makefile
index dabdf8d..f336f7a 100644
--- a/Makefile
+++ b/Makefile
@@ -273,16 +273,16 @@ gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
-$(LIBTRACEEVENT_SHARED): force
+$(LIBTRACEEVENT_SHARED): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACEEVENT_STATIC): force
+$(LIBTRACEEVENT_STATIC): force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
+$(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
-$(LIBTRACECMD_SHARED): force $(obj)/plugins/trace_plugin_dir
+$(LIBTRACECMD_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
@@ -292,14 +292,14 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
-plugins: force $(obj)/plugins/trace_plugin_dir $(obj)/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/plugins
+plugins: force $(obj)/lib/traceevent/plugins/traceevent_plugin_dir $(obj)/lib/traceevent/plugins/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins
 
-$(obj)/plugins/trace_plugin_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+$(obj)/lib/traceevent/plugins/traceevent_plugin_dir: force
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
-$(obj)/plugins/trace_python_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+$(obj)/lib/traceevent/plugins/trace_python_dir: force
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
@@ -325,7 +325,7 @@ cscope: force
 	$(call find_tag_files) | cscope -b -q
 
 install_plugins: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $@
 
 install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
@@ -372,7 +372,7 @@ clean:
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
-	$(MAKE) -C $(src)/plugins clean
+	$(MAKE) -C $(src)/lib/traceevent/plugins clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
@@ -421,8 +421,8 @@ python-gui: $(PYTHON_GUI)
 PHONY += python-plugin
 python-plugin: $(PYTHON_PLUGINS)
 
-plugin_python.so: force $(obj)/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/plugins $(obj)/plugins/plugin_python.so
+plugin_python.so: force $(obj)/lib/traceevent/plugins/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/lib/traceevent/plugins $(obj)/lib/traceevent/plugins/plugin_python.so
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 78875e4..3b4b5aa 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -40,8 +40,6 @@ $(bdir)/libtracecmd.so: $(OBJS)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
-
 $(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
diff --git a/plugins/Makefile b/lib/traceevent/plugins/Makefile
similarity index 93%
rename from plugins/Makefile
rename to lib/traceevent/plugins/Makefile
index 4598e83..e0a7566 100644
--- a/plugins/Makefile
+++ b/lib/traceevent/plugins/Makefile
@@ -1,6 +1,6 @@
 include $(src)/scripts/utils.mk
 
-bdir:=$(obj)/plugins
+bdir:=$(obj)/lib/traceevent/plugins
 
 PLUGIN_OBJS =
 PLUGIN_OBJS += plugin_jbd2.o
@@ -61,7 +61,7 @@ install_plugins: $(PLUGINS_INSTALL)
 # and $(PYTHON_DIR) change. Without them, a full clean build would necessary
 # in order to get the binaries updated.
 
-$(bdir)/trace_plugin_dir: $(bdir) force
+$(bdir)/traceevent_plugin_dir: $(bdir) force
 	$(Q)$(N)$(call update_dir, 'PLUGIN_DIR=$(PLUGIN_DIR)')
 
 $(bdir)/trace_python_dir: $(bdir) force
@@ -75,7 +75,7 @@ ifneq ($(dep_includes),)
 endif
 
 clean:
-	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(bdir)/trace_plugin_dir $(bdir)/trace_python_dir
+	$(RM) -f $(bdir)/*.a $(bdir)/*.so $(bdir)/*.o $(bdir)/.*.d $(bdir)/traceevent_plugin_dir $(bdir)/trace_python_dir
 
 force:
 .PHONY: clean force
diff --git a/plugins/plugin_blk.c b/lib/traceevent/plugins/plugin_blk.c
similarity index 100%
rename from plugins/plugin_blk.c
rename to lib/traceevent/plugins/plugin_blk.c
diff --git a/plugins/plugin_cfg80211.c b/lib/traceevent/plugins/plugin_cfg80211.c
similarity index 100%
rename from plugins/plugin_cfg80211.c
rename to lib/traceevent/plugins/plugin_cfg80211.c
diff --git a/plugins/plugin_function.c b/lib/traceevent/plugins/plugin_function.c
similarity index 100%
rename from plugins/plugin_function.c
rename to lib/traceevent/plugins/plugin_function.c
diff --git a/plugins/plugin_futex.c b/lib/traceevent/plugins/plugin_futex.c
similarity index 100%
rename from plugins/plugin_futex.c
rename to lib/traceevent/plugins/plugin_futex.c
diff --git a/plugins/plugin_hrtimer.c b/lib/traceevent/plugins/plugin_hrtimer.c
similarity index 100%
rename from plugins/plugin_hrtimer.c
rename to lib/traceevent/plugins/plugin_hrtimer.c
diff --git a/plugins/plugin_jbd2.c b/lib/traceevent/plugins/plugin_jbd2.c
similarity index 100%
rename from plugins/plugin_jbd2.c
rename to lib/traceevent/plugins/plugin_jbd2.c
diff --git a/plugins/plugin_kmem.c b/lib/traceevent/plugins/plugin_kmem.c
similarity index 100%
rename from plugins/plugin_kmem.c
rename to lib/traceevent/plugins/plugin_kmem.c
diff --git a/plugins/plugin_kvm.c b/lib/traceevent/plugins/plugin_kvm.c
similarity index 100%
rename from plugins/plugin_kvm.c
rename to lib/traceevent/plugins/plugin_kvm.c
diff --git a/plugins/plugin_mac80211.c b/lib/traceevent/plugins/plugin_mac80211.c
similarity index 100%
rename from plugins/plugin_mac80211.c
rename to lib/traceevent/plugins/plugin_mac80211.c
diff --git a/plugins/plugin_python.c b/lib/traceevent/plugins/plugin_python.c
similarity index 100%
rename from plugins/plugin_python.c
rename to lib/traceevent/plugins/plugin_python.c
diff --git a/plugins/plugin_sched_switch.c b/lib/traceevent/plugins/plugin_sched_switch.c
similarity index 100%
rename from plugins/plugin_sched_switch.c
rename to lib/traceevent/plugins/plugin_sched_switch.c
diff --git a/plugins/plugin_scsi.c b/lib/traceevent/plugins/plugin_scsi.c
similarity index 100%
rename from plugins/plugin_scsi.c
rename to lib/traceevent/plugins/plugin_scsi.c
diff --git a/plugins/plugin_tlb.c b/lib/traceevent/plugins/plugin_tlb.c
similarity index 100%
rename from plugins/plugin_tlb.c
rename to lib/traceevent/plugins/plugin_tlb.c
diff --git a/plugins/plugin_xen.c b/lib/traceevent/plugins/plugin_xen.c
similarity index 100%
rename from plugins/plugin_xen.c
rename to lib/traceevent/plugins/plugin_xen.c
-- 
2.21.0

