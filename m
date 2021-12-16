Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EF10C4321E
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Dec 2021 21:40:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241639AbhLPVkC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 16:40:02 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39060 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241577AbhLPVkB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 16:40:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E2DB82655
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Dec 2021 21:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF04C36AEE;
        Thu, 16 Dec 2021 21:39:58 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.95)
        (envelope-from <rostedt@rostedt.homelinux.com>)
        id 1mxyTl-0003dQ-RE;
        Thu, 16 Dec 2021 16:39:57 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 04/10] libtraceevent: Move installed headers into their own directory
Date:   Thu, 16 Dec 2021 16:39:50 -0500
Message-Id: <20211216213956.13934-5-rostedt@goodmis.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211216213956.13934-1-rostedt@goodmis.org>
References: <20211216213956.13934-1-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

It was noted that it is confusing that the headers that get installed and
are API are in the same directory as the source code. Create a
include/traceevent directory and move the headers that get installed onto
the system into that directory.

Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 Makefile                                  | 14 ++++++++------
 {src => include/traceevent}/event-parse.h |  0
 {src => include/traceevent}/event-utils.h |  0
 {src => include/traceevent}/kbuffer.h     |  0
 {src => include/traceevent}/trace-seq.h   |  0
 plugins/Makefile                          |  2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)
 rename {src => include/traceevent}/event-parse.h (100%)
 rename {src => include/traceevent}/event-utils.h (100%)
 rename {src => include/traceevent}/kbuffer.h (100%)
 rename {src => include/traceevent}/trace-seq.h (100%)

diff --git a/Makefile b/Makefile
index 8b3b5cc1ea35..965eb56a8ea0 100644
--- a/Makefile
+++ b/Makefile
@@ -117,9 +117,11 @@ N		=
 LIBTRACEEVENT_STATIC = $(bdir)/libtraceevent.a
 LIBTRACEEVENT_SHARED = $(bdir)/libtraceevent.so.$(EVENT_PARSE_VERSION)
 
-INCLUDES = -I. -I $(srctree)/include $(CONFIG_INCLUDES)
+EP_HEADERS_DIR = $(src)/include/traceevent
 
-export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
+INCLUDES = -I. -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
+
+export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED EP_HEADERS_DIR
 
 # Set compile option CFLAGS
 ifdef EXTRA_CFLAGS
@@ -334,10 +336,10 @@ install_pkgconfig: $(PKG_CONFIG_FILE)
 	$(Q)$(call do_install_pkgconfig_file,$(prefix))
 
 install_headers:
-	$(Q)$(call do_install,src/event-parse.h,$(includedir_SQ),644);
-	$(Q)$(call do_install,src/event-utils.h,$(includedir_SQ),644);
-	$(Q)$(call do_install,src/trace-seq.h,$(includedir_SQ),644);
-	$(Q)$(call do_install,src/kbuffer.h,$(includedir_SQ),644)
+	$(Q)$(call do_install,$(EP_HEADERS_DIR)/event-parse.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,$(EP_HEADERS_DIR)/event-utils.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,$(EP_HEADERS_DIR)/trace-seq.h,$(includedir_SQ),644);
+	$(Q)$(call do_install,$(EP_HEADERS_DIR)/kbuffer.h,$(includedir_SQ),644)
 
 install: install_libs
 
diff --git a/src/event-parse.h b/include/traceevent/event-parse.h
similarity index 100%
rename from src/event-parse.h
rename to include/traceevent/event-parse.h
diff --git a/src/event-utils.h b/include/traceevent/event-utils.h
similarity index 100%
rename from src/event-utils.h
rename to include/traceevent/event-utils.h
diff --git a/src/kbuffer.h b/include/traceevent/kbuffer.h
similarity index 100%
rename from src/kbuffer.h
rename to include/traceevent/kbuffer.h
diff --git a/src/trace-seq.h b/include/traceevent/trace-seq.h
similarity index 100%
rename from src/trace-seq.h
rename to include/traceevent/trace-seq.h
diff --git a/plugins/Makefile b/plugins/Makefile
index 8b1dbf68757c..4c8cb177b668 100644
--- a/plugins/Makefile
+++ b/plugins/Makefile
@@ -62,7 +62,7 @@ CONFIG_FLAGS   =
 OBJ            = $@
 N              =
 
-INCLUDES = -I. -I.. -I../src -I $(srctree)/include $(CONFIG_INCLUDES)
+INCLUDES = -I. -I.. -I../src -I $(srctree)/include -I $(EP_HEADERS_DIR) $(CONFIG_INCLUDES)
 
 # Set compile option CFLAGS
 ifdef EXTRA_CFLAGS
-- 
2.33.0

