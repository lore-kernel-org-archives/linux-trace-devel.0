Return-Path: <SRS0=90v9=TK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C18C04A6B
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01E04217F4
	for <linux-trace-devel@archiver.kernel.org>; Fri, 10 May 2019 20:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfEJUDG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 10 May 2019 16:03:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727670AbfEJUBJ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 10 May 2019 16:01:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CECCE2182B;
        Fri, 10 May 2019 20:01:07 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.92)
        (envelope-from <rostedt@goodmis.org>)
        id 1hPBha-0006dt-2S; Fri, 10 May 2019 16:01:06 -0400
Message-Id: <20190510200105.966709757@goodmis.org>
User-Agent: quilt/0.65
Date:   Fri, 10 May 2019 15:56:07 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/27] tools lib traceevent: Remove hard coded install paths from pkg-config
 file
References: <20190510195606.537643615@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Tzvetomir Stoyanov <tstoyanov@vmware.com>

Install directories of header and library files are hard coded in
pkg-config template file.

They must be configurable, the Makefile should set them on the
compilation / install stage.

Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20190418211556.5a12adc3@oasis.local.home
Link: http://lkml.kernel.org/r/20190329144546.5819-1-tstoyanov@vmware.com
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile                  | 13 +++++++++----
 tools/lib/traceevent/libtraceevent.pc.template |  4 ++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 941761d9923d..34cf33a4f001 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -50,6 +50,9 @@ man_dir = $(prefix)/share/man
 man_dir_SQ = '$(subst ','\'',$(man_dir))'
 pkgconfig_dir ?= $(word 1,$(shell $(PKG_CONFIG) 		\
 			--variable pc_path pkg-config | tr ":" " "))
+includedir_relative = traceevent
+includedir = $(prefix)/include/$(includedir_relative)
+includedir_SQ = '$(subst ','\'',$(includedir))'
 
 export man_dir man_dir_SQ INSTALL
 export DESTDIR DESTDIR_SQ
@@ -279,6 +282,8 @@ define do_install_pkgconfig_file
 		cp -f ${PKG_CONFIG_FILE}.template ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|INSTALL_PREFIX|${1}|g" ${PKG_CONFIG_FILE}; 		\
 		sed -i "s|LIB_VERSION|${EVENT_PARSE_VERSION}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|LIB_DIR|${libdir}|g" ${PKG_CONFIG_FILE}; \
+		sed -i "s|HEADER_DIR|$(includedir)|g" ${PKG_CONFIG_FILE}; \
 		$(call do_install,$(PKG_CONFIG_FILE),$(pkgconfig_dir),644); 	\
 	else 									\
 		(echo Failed to locate pkg-config directory) 1>&2;		\
@@ -300,10 +305,10 @@ install_pkgconfig:
 
 install_headers:
 	$(call QUIET_INSTALL, headers) \
-		$(call do_install,event-parse.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,event-utils.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,trace-seq.h,$(prefix)/include/traceevent,644); \
-		$(call do_install,kbuffer.h,$(prefix)/include/traceevent,644)
+		$(call do_install,event-parse.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,event-utils.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,trace-seq.h,$(DESTDIR)$(includedir_SQ),644); \
+		$(call do_install,kbuffer.h,$(DESTDIR)$(includedir_SQ),644)
 
 install: install_lib
 
diff --git a/tools/lib/traceevent/libtraceevent.pc.template b/tools/lib/traceevent/libtraceevent.pc.template
index 42e4d6cb6b9e..86384fcd57f1 100644
--- a/tools/lib/traceevent/libtraceevent.pc.template
+++ b/tools/lib/traceevent/libtraceevent.pc.template
@@ -1,6 +1,6 @@
 prefix=INSTALL_PREFIX
-libdir=${prefix}/lib64
-includedir=${prefix}/include/traceevent
+libdir=LIB_DIR
+includedir=HEADER_DIR
 
 Name: libtraceevent
 URL: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
-- 
2.20.1


