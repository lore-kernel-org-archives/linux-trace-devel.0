Return-Path: <SRS0=L246=YS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C17ECCA9EA0
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9568720578
	for <linux-trace-devel@archiver.kernel.org>; Fri, 25 Oct 2019 06:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNsa7d8G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405209AbfJYGmH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 25 Oct 2019 02:42:07 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:57160 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405128AbfJYGmH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 25 Oct 2019 02:42:07 -0400
Received: by mail-pl1-f202.google.com with SMTP id bb3so870347plb.23
        for <linux-trace-devel@vger.kernel.org>; Thu, 24 Oct 2019 23:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=H0Y4KMySF9HHFl3PeG5Im4oEDqcG0H2luMTu3w3wsBs=;
        b=kNsa7d8GZPViHnTdOxC9aKqqyJqXDbu9FPoQCZrHy3ZrMQEl2CM45koRcTFPzplZTZ
         rzstxfcw4OBcJB53xgZdhXOK+IaOvRVpHWWpLlAvj3hWYspulnHVCpnPaGnYOOz4CrXU
         7RVIzZSQUFczT+U4lOOzsV0VUljBJYgtSn8xeap3/V5zNaKT5gR6sjIY61VlP99jry2m
         /DFnCigf45jaeDc7rRSEULnMRSvTlYdqCh5uVmsh7iRA1wJ9i3pXHvR/PiVQqiJW5j/L
         rOX0b1vPeotISUDpB7my6kYBYCpAIwGd6OpTVXCcuuE5snEGGenBfftOcXB42pqKmw0d
         gpaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=H0Y4KMySF9HHFl3PeG5Im4oEDqcG0H2luMTu3w3wsBs=;
        b=It+iTLFz/NhtbSR57caD5JuBzFERzhrC8MEd0MYq9K5RUCM7b0ga1+/TPd/TIMtu7l
         YQadGGZrjkYGkaun8jzuEOJCDuV5OX3+red0GkzDTvjE2PFBaPfEyNiq7+NZQaWU9plO
         c6zQqay7MZu6ai+hP09VQ+7SCb2YlkgZcEM3FdVXWOXEEHRra4SrhhW5h7MzWcBTsVoc
         AeH7g1Ddq/KfidBwBEY8vqi5noUFktEFIrB8n3x37Tmx0B9JMtkddtqIN/Q9lAKlfLaI
         UrHrJHBCiHiPdvsGT5uioQInyCqUo7pk+cG6yrFm5A1MbLiiQVZWkPrO+2zBJ2gOWzwM
         NXFw==
X-Gm-Message-State: APjAAAVdBLFdunrfFMoQrU3G8rQc8cq76Ad8LOxhuuD/45piSZ/HO4aI
        uXng1ouKBOsyJu6Y0s6e0Tz89dppoec/
X-Google-Smtp-Source: APXvYqxj2KrJSfCupPAVnHsgx4WyP4kx8+qYfNrmyNCZ8bC6T5YG62hBLn2J3jssM57DFF+JgnEc4YU7H+LU
X-Received: by 2002:a63:f916:: with SMTP id h22mr2219870pgi.423.1571985724881;
 Thu, 24 Oct 2019 23:42:04 -0700 (PDT)
Date:   Thu, 24 Oct 2019 23:39:57 -0700
In-Reply-To: <20191025063957.21558-1-gthelen@google.com>
Message-Id: <20191025063957.21558-2-gthelen@google.com>
Mime-Version: 1.0
References: <20191025063957.21558-1-gthelen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 2/2] trace-cmd: respect -s/--silent
From:   Greg Thelen <gthelen@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Keep make -s,--silent from printing any progress messages.  Only show
warnings and errors.  By default (without -s), there's no change.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Makefile         | 4 +++-
 scripts/utils.mk | 9 +++++++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index bbdf15ea7af6..8f9eb0203c01 100644
--- a/Makefile
+++ b/Makefile
@@ -101,6 +101,8 @@ ifndef VERBOSE
   VERBOSE = 0
 endif
 
+SILENT := $(if $(findstring s,$(filter-out --%,$(MAKEFLAGS))),1)
+
 SWIG_DEFINED := $(shell if command -v swig; then echo 1; else echo 0; fi)
 ifeq ($(SWIG_DEFINED), 0)
 BUILD_PYTHON := report_noswig
@@ -188,7 +190,7 @@ export LIBTRACEEVENT_DIR LIBTRACECMD_DIR
 export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
 export LIBTRACEEVENT_STATIC LIBTRACEEVENT_SHARED
 
-export Q VERBOSE EXT
+export Q SILENT VERBOSE EXT
 
 # Include the utils
 include scripts/utils.mk
diff --git a/scripts/utils.mk b/scripts/utils.mk
index 8e4e4b5f3a4a..d1d5135063fc 100644
--- a/scripts/utils.mk
+++ b/scripts/utils.mk
@@ -15,6 +15,13 @@ endif
 ifeq ($(VERBOSE),1)
   Q =
   S =
+else
+  Q = @
+  S = -s
+endif
+
+# Use empty print_* macros if either SILENT or VERBOSE.
+ifeq ($(findstring 1,$(SILENT)$(VERBOSE)),1)
   print_compile =
   print_app_build =
   print_fpic_compile =
@@ -24,8 +31,6 @@ ifeq ($(VERBOSE),1)
   print_install =
   print_update =
 else
-  Q = @
-  S = -s
   print_compile =		echo '  $(GUI)COMPILE            '$(GOBJ);
   print_app_build =		echo '  $(GUI)BUILD              '$(GOBJ);
   print_fpic_compile =		echo '  $(GUI)COMPILE FPIC       '$(GOBJ);
-- 
2.24.0.rc0.303.g954a862665-goog

