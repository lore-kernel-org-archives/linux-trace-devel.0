Return-Path: <SRS0=4i+i=V6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D912C433FF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25C7C206A3
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Aug 2019 11:01:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SFD9rnrU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbfHBLBM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 07:01:12 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:46460 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729711AbfHBLBM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 07:01:12 -0400
Received: by mail-wr1-f52.google.com with SMTP id z1so76703360wru.13
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Aug 2019 04:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oQW3CapmXskHp+lUcyB/vJpUdC3NPHtv3CbqaaEHVtc=;
        b=SFD9rnrUsomKCVkCsPFZUkw6wp7Z02696iYEAXV+Y3p7lvjAGu7yolXbGeKQvkm2ae
         HGo4EP7r8lQU6SY0Bm9bGoNBExTfp6pw+aRPDW0SlxN05nA/aqRF+thCYzRcUl7IDG3s
         ni/9+WmWZr3Uxtb1++pjJEBAqSeJvuYgLwgwVzBB+8r81x14ESGl0Kq6shpHPhuDnPdO
         2d4qyrLRh48bCNw7w3BGitC3RzcAcJJwY14k1qcKEqQgo4+JLAvpVLFYXXRm6MPKJo6G
         HXt+EU3HipqD9AGqZCv2iAB1aJLI6JqbhgZB67S5phkuYRPLxSe+FUD2kexqr2Dc0Bzz
         fs8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oQW3CapmXskHp+lUcyB/vJpUdC3NPHtv3CbqaaEHVtc=;
        b=bpGA0UP6kbviYp0XM1Dihgr7mh2diNGDUTf2oD2k7lYMhJSsuhEfeiWgm6Bu+ANliK
         CjpFt/QhUlC/0zXbeISqmAfLHiwoErT92d2kEGcnWlhRM/sBiqbCvc4yjaoK6GPwkwHk
         HTcudVlmJbMzocjGCNWqTmUexEA0xLeKy9XL7u2lfV1LdKFRg5UBAnA6nKXbkRsCxkD1
         IGMO/pHnc+d6RwIJw7hQJKx6v2MuX22AqwwZTXbG0qNQ7i3JJAwfaUgcolqdOBeF1ore
         6Fw0GUFmYpThJH1TsxYqWRnzFZEYI3WErpfW9WRXaMTDdfdixjNhDuFEXSn9nKOs1s6B
         zJmQ==
X-Gm-Message-State: APjAAAXScQY0d5d8JhjHLwTjnfB6Mrg1v3sCPybGZfNtzgVj+esE05QM
        hBIc1xAycFpFGZXhq66zCvk=
X-Google-Smtp-Source: APXvYqwpALeTcDXmYYLf9Y1ScovH0Un+yR5SrTpRvw1gczVqwVFbyj3zuooq9DvbKeH/BzplmgA61Q==
X-Received: by 2002:a5d:4e8a:: with SMTP id e10mr9112290wru.26.1564743670077;
        Fri, 02 Aug 2019 04:01:10 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id r15sm79511433wrj.68.2019.08.02.04.01.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 04:01:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/6] trace-cmd: Move libtraceevent plugins in its own directory.
Date:   Fri,  2 Aug 2019 14:00:59 +0300
Message-Id: <20190802110101.14759-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190802110101.14759-1-tz.stoyanov@gmail.com>
References: <20190802110101.14759-1-tz.stoyanov@gmail.com>
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
 plugins/{ => traceevent}/Makefile             |  6 ++--
 plugins/{ => traceevent}/plugin_blk.c         |  0
 plugins/{ => traceevent}/plugin_cfg80211.c    |  0
 plugins/{ => traceevent}/plugin_function.c    |  0
 plugins/{ => traceevent}/plugin_futex.c       |  0
 plugins/{ => traceevent}/plugin_hrtimer.c     |  0
 plugins/{ => traceevent}/plugin_jbd2.c        |  0
 plugins/{ => traceevent}/plugin_kmem.c        |  0
 plugins/{ => traceevent}/plugin_kvm.c         |  0
 plugins/{ => traceevent}/plugin_mac80211.c    |  0
 plugins/{ => traceevent}/plugin_python.c      |  0
 .../{ => traceevent}/plugin_sched_switch.c    |  0
 plugins/{ => traceevent}/plugin_scsi.c        |  0
 plugins/{ => traceevent}/plugin_tlb.c         |  0
 plugins/{ => traceevent}/plugin_xen.c         |  0
 18 files changed, 18 insertions(+), 20 deletions(-)
 rename plugins/{ => traceevent}/Makefile (93%)
 rename plugins/{ => traceevent}/plugin_blk.c (100%)
 rename plugins/{ => traceevent}/plugin_cfg80211.c (100%)
 rename plugins/{ => traceevent}/plugin_function.c (100%)
 rename plugins/{ => traceevent}/plugin_futex.c (100%)
 rename plugins/{ => traceevent}/plugin_hrtimer.c (100%)
 rename plugins/{ => traceevent}/plugin_jbd2.c (100%)
 rename plugins/{ => traceevent}/plugin_kmem.c (100%)
 rename plugins/{ => traceevent}/plugin_kvm.c (100%)
 rename plugins/{ => traceevent}/plugin_mac80211.c (100%)
 rename plugins/{ => traceevent}/plugin_python.c (100%)
 rename plugins/{ => traceevent}/plugin_sched_switch.c (100%)
 rename plugins/{ => traceevent}/plugin_scsi.c (100%)
 rename plugins/{ => traceevent}/plugin_tlb.c (100%)
 rename plugins/{ => traceevent}/plugin_xen.c (100%)

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
index ad74a96..8b228f5 100644
--- a/Makefile
+++ b/Makefile
@@ -266,16 +266,16 @@ gui: force $(CMD_TARGETS) $(kshark-dir)/build/Makefile
 trace-cmd: force $(LIBTRACEEVENT_STATIC) $(LIBTRACECMD_STATIC)
 	$(Q)$(MAKE) -C $(src)/tracecmd $(obj)/tracecmd/$@
 
-$(LIBTRACEEVENT_SHARED): force
+$(LIBTRACEEVENT_SHARED): force $(obj)/plugins/traceevent/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACEEVENT_STATIC): force
+$(LIBTRACEEVENT_STATIC): force $(obj)/plugins/traceevent/traceevent_plugin_dir
 	$(Q)$(MAKE) -C $(src)/lib/traceevent $@
 
-$(LIBTRACECMD_STATIC): force $(obj)/plugins/trace_plugin_dir
+$(LIBTRACECMD_STATIC): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
-$(LIBTRACECMD_SHARED): force $(obj)/plugins/trace_plugin_dir
+$(LIBTRACECMD_SHARED): force
 	$(Q)$(MAKE) -C $(src)/lib/trace-cmd $@
 
 libtraceevent.so: $(LIBTRACEEVENT_SHARED)
@@ -285,14 +285,14 @@ libtracecmd.so: $(LIBTRACECMD_SHARED)
 
 libs: $(LIBTRACECMD_SHARED) $(LIBTRACEEVENT_SHARED)
 
-plugins: force $(obj)/plugins/trace_plugin_dir $(obj)/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/plugins
+plugins: force $(obj)/plugins/traceevent/traceevent_plugin_dir $(obj)/plugins/traceevent/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/plugins/traceevent
 
-$(obj)/plugins/trace_plugin_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+$(obj)/plugins/traceevent/traceevent_plugin_dir: force
+	$(Q)$(MAKE) -C $(src)/plugins/traceevent $@
 
-$(obj)/plugins/trace_python_dir: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+$(obj)/plugins/traceevent/trace_python_dir: force
+	$(Q)$(MAKE) -C $(src)/plugins/traceevent $@
 
 show_gui_make:
 	@echo "Note: to build the gui, type \"make gui\""
@@ -318,7 +318,7 @@ cscope: force
 	$(call find_tag_files) | cscope -b -q
 
 install_plugins: force
-	$(Q)$(MAKE) -C $(src)/plugins $@
+	$(Q)$(MAKE) -C $(src)/plugins/traceevent $@
 
 install_python: force
 	$(Q)$(MAKE) -C $(src)/python $@
@@ -356,7 +356,7 @@ clean:
 	$(RM) tags TAGS cscope*
 	$(MAKE) -C $(src)/lib/traceevent clean
 	$(MAKE) -C $(src)/lib/trace-cmd clean
-	$(MAKE) -C $(src)/plugins clean
+	$(MAKE) -C $(src)/plugins/traceevent clean
 	$(MAKE) -C $(src)/python clean
 	$(MAKE) -C $(src)/tracecmd clean
 	if [ -f $(kshark-dir)/build/Makefile ]; then $(MAKE) -C $(kshark-dir)/build clean; fi
@@ -405,8 +405,8 @@ python-gui: $(PYTHON_GUI)
 PHONY += python-plugin
 python-plugin: $(PYTHON_PLUGINS)
 
-plugin_python.so: force $(obj)/plugins/trace_python_dir
-	$(Q)$(MAKE) -C $(src)/plugins $(obj)/plugins/plugin_python.so
+plugin_python.so: force $(obj)/plugins/traceevent/trace_python_dir
+	$(Q)$(MAKE) -C $(src)/plugins/traceevent $(obj)/plugins/traceevent/plugin_python.so
 
 dist:
 	git archive --format=tar --prefix=trace-cmd-$(TRACECMD_VERSION)/ HEAD \
diff --git a/lib/trace-cmd/Makefile b/lib/trace-cmd/Makefile
index 44c1332..6f9a013 100644
--- a/lib/trace-cmd/Makefile
+++ b/lib/trace-cmd/Makefile
@@ -38,8 +38,6 @@ $(bdir)/libtracecmd.so: $(OBJS)
 $(bdir)/%.o: %.c
 	$(Q)$(call do_fpic_compile)
 
-$(bdir)/trace-util.o: $(obj)/plugins/trace_plugin_dir
-
 $(DEPS): $(bdir)/.%.d: %.c
 	$(Q)$(CC) -M $(CPPFLAGS) $(CFLAGS) $< > $@
 
diff --git a/plugins/Makefile b/plugins/traceevent/Makefile
similarity index 93%
rename from plugins/Makefile
rename to plugins/traceevent/Makefile
index 4598e83..8ed65d3 100644
--- a/plugins/Makefile
+++ b/plugins/traceevent/Makefile
@@ -1,6 +1,6 @@
 include $(src)/scripts/utils.mk
 
-bdir:=$(obj)/plugins
+bdir:=$(obj)/plugins/traceevent
 
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
diff --git a/plugins/plugin_blk.c b/plugins/traceevent/plugin_blk.c
similarity index 100%
rename from plugins/plugin_blk.c
rename to plugins/traceevent/plugin_blk.c
diff --git a/plugins/plugin_cfg80211.c b/plugins/traceevent/plugin_cfg80211.c
similarity index 100%
rename from plugins/plugin_cfg80211.c
rename to plugins/traceevent/plugin_cfg80211.c
diff --git a/plugins/plugin_function.c b/plugins/traceevent/plugin_function.c
similarity index 100%
rename from plugins/plugin_function.c
rename to plugins/traceevent/plugin_function.c
diff --git a/plugins/plugin_futex.c b/plugins/traceevent/plugin_futex.c
similarity index 100%
rename from plugins/plugin_futex.c
rename to plugins/traceevent/plugin_futex.c
diff --git a/plugins/plugin_hrtimer.c b/plugins/traceevent/plugin_hrtimer.c
similarity index 100%
rename from plugins/plugin_hrtimer.c
rename to plugins/traceevent/plugin_hrtimer.c
diff --git a/plugins/plugin_jbd2.c b/plugins/traceevent/plugin_jbd2.c
similarity index 100%
rename from plugins/plugin_jbd2.c
rename to plugins/traceevent/plugin_jbd2.c
diff --git a/plugins/plugin_kmem.c b/plugins/traceevent/plugin_kmem.c
similarity index 100%
rename from plugins/plugin_kmem.c
rename to plugins/traceevent/plugin_kmem.c
diff --git a/plugins/plugin_kvm.c b/plugins/traceevent/plugin_kvm.c
similarity index 100%
rename from plugins/plugin_kvm.c
rename to plugins/traceevent/plugin_kvm.c
diff --git a/plugins/plugin_mac80211.c b/plugins/traceevent/plugin_mac80211.c
similarity index 100%
rename from plugins/plugin_mac80211.c
rename to plugins/traceevent/plugin_mac80211.c
diff --git a/plugins/plugin_python.c b/plugins/traceevent/plugin_python.c
similarity index 100%
rename from plugins/plugin_python.c
rename to plugins/traceevent/plugin_python.c
diff --git a/plugins/plugin_sched_switch.c b/plugins/traceevent/plugin_sched_switch.c
similarity index 100%
rename from plugins/plugin_sched_switch.c
rename to plugins/traceevent/plugin_sched_switch.c
diff --git a/plugins/plugin_scsi.c b/plugins/traceevent/plugin_scsi.c
similarity index 100%
rename from plugins/plugin_scsi.c
rename to plugins/traceevent/plugin_scsi.c
diff --git a/plugins/plugin_tlb.c b/plugins/traceevent/plugin_tlb.c
similarity index 100%
rename from plugins/plugin_tlb.c
rename to plugins/traceevent/plugin_tlb.c
diff --git a/plugins/plugin_xen.c b/plugins/traceevent/plugin_xen.c
similarity index 100%
rename from plugins/plugin_xen.c
rename to plugins/traceevent/plugin_xen.c
-- 
2.21.0

