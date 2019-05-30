Return-Path: <SRS0=Uv3S=T6=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0821CC28CC0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF8282596C
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 May 2019 13:16:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfE3NQZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 May 2019 09:16:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50364 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfE3NQZ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 May 2019 09:16:25 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so3974050wme.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 May 2019 06:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlPSX2f46myCSZN6xZyY1xUFxQFevAdG7+SpzfBhUK0=;
        b=q1LxMTYJpdhsIPFYUbGTNmG0b6sDIeKBTlH4bcw9MZwvuOn5TuOBnTHyFoW+k5xHOp
         3i7hiCQqRh6aPl7iuZu0oCUh/VZ8te3X4wXe+ecAC1zb/YhSGLt3LFHxLAup32GP1scp
         lNC2U6A+Wd8NijDS9LrHJULJiGLZtu+tpnjSNolYOdb1VrVRog8McV78kEVTdQcdCnPG
         5D1BTHrhejy8MPxriTqrk5ZKsaRiXJu75/BxfYX0xP30XOjJ8HGE+h34jo3fgmTojY/Z
         WO598R8uEiQDrKwzkDSUvuxbc0rXyUVjIbnF567mc7mGA67pp1rH9fLT2qey3Tsaru6A
         /zbg==
X-Gm-Message-State: APjAAAWarP/v+LFJOEdVsMGwKknA4bhCBNWX97JkhulqAtDOI5w9f222
        tc4INh9/bxEQ379fs+4za7Y=
X-Google-Smtp-Source: APXvYqzO92KwYkah/TiQmlTTph1bYYnhCGfq/5rBNEopI1L/UIt12HX8IWajg1AVQcEEG5qajnkruQ==
X-Received: by 2002:a1c:a7ca:: with SMTP id q193mr2418117wme.150.1559222183424;
        Thu, 30 May 2019 06:16:23 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id q15sm2334874wrr.19.2019.05.30.06.16.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 06:16:23 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 1/2] trace-cmd: Install public interface headers
Date:   Thu, 30 May 2019 16:15:55 +0300
Message-Id: <20190530131556.21832-2-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190530131556.21832-1-ykaradzhov@vmware.com>
References: <20190530131556.21832-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Installing the header files included in the public interfaces of
the trace-cmd libraries will make possible the libraries to be used
for development.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 Makefile | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/Makefile b/Makefile
index cde45f8..ac514b1 100644
--- a/Makefile
+++ b/Makefile
@@ -49,10 +49,18 @@ html_install = $(prefix)/share/kernelshark/html
 html_install_SQ = '$(subst ','\'',$(html_install))'
 img_install = $(prefix)/share/kernelshark/html/images
 img_install_SQ = '$(subst ','\'',$(img_install))'
-libdir ?= $(prefix)/lib
-libdir_SQ = '$(subst ','\'',$(libdir))'
-includedir = $(prefix)/include/trace-cmd
-includedir_SQ = '$(subst ','\'',$(includedir))'
+
+tcmd_libdir ?= $(prefix)/lib/trace-cmd
+tcmd_libdir_SQ = '$(subst ','\'',$(tcmd_libdir))'
+
+tevt_libdir ?= $(prefix)/lib/traceevent
+tevt_libdir_SQ = '$(subst ','\'',$(tevt_libdir))'
+
+tcmd_includedir = $(prefix)/include/trace-cmd
+tcmd_includedir_SQ = '$(subst ','\'',$(tcmd_includedir))'
+
+tevt_includedir = $(prefix)/include/traceevent
+tevt_includedir_SQ = '$(subst ','\'',$(tevt_includedir))'
 
 export man_dir man_dir_SQ html_install html_install_SQ INSTALL
 export img_install img_install_SQ
@@ -335,10 +343,12 @@ install_gui: install_cmd gui
 	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
 
 install_libs: libs
-	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
-	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ))
-	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
+	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(tcmd_libdir_SQ))
+	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(tevt_libdir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(tevt_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(tevt_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(tcmd_includedir_SQ))
+	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(tcmd_includedir_SQ))
 
 doc:
 	$(MAKE) -C $(src)/Documentation all
-- 
2.20.1

