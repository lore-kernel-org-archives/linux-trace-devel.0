Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A6BC433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEFB6125F
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Nov 2021 08:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhKHIHC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Nov 2021 03:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbhKHIHC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Nov 2021 03:07:02 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FADC061570
        for <linux-trace-devel@vger.kernel.org>; Mon,  8 Nov 2021 00:04:18 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id x15so27689138edv.1
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Nov 2021 00:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XJvnvRjQV5WIu4vp2/wBSqNpB3fDsNCwh2Y+3NXJ7Ao=;
        b=jfuW9NGm14hS1bW/HYuNcafXnEaZXlQ7acAS6sp3uNiDqa0xqYyUoH9JxTNdVn/yve
         nQt92UA0Z9VEjAZfTGzik8qMVwIPV7lLGF1UvPmxBwUtyzGYxY9CwMc/8dFIc651ZvY1
         oKNUNZaKYNODMICwK5d7zDQdCPsimU3NTKuS+Qcmchcpee/1nQQuKo0rv1zt269RiYIm
         FwFxUYD3+5EBlUDgpmJ5iKSung2SMl7PsVqVq5losy+ZyDbjPp0VSfxBCMblRa9Q/6Pj
         aduQaRGOcTPbVne3lX5qhLNBG1qQe7j48JexbfyEdKCvYP28Tm7QqsX8mN98orsTMaGD
         S9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJvnvRjQV5WIu4vp2/wBSqNpB3fDsNCwh2Y+3NXJ7Ao=;
        b=zFVDWrpwlTcXw7PI2Xi4QUKFs6O9gAEnEa3MVL8/tC90G4UCuKOO23CNXrHZG6OvxB
         XqPtdA0AoOZ6cQf5cyJiD89WYhPh171AIjU06WI8IeevsgexVaMf11eUulGWVwSix/QY
         o2p1D5izxMHRWPLmDVKNZx0dmWAr5CrNcOaYzcMwjTbJZm4F+91JeaFQlRu8MpsWj3vd
         Qgb+VHA9tjQXi3RpGp4ka8lffOle4xt037gMACTjGapQuXDJgCaJxR+t486tTG0Xj2DO
         5hLtSll/ie4ATVq7dkCy163IyR5ZLrJnPjbcBnI3ARHYc3iOPSXysOlAqNU6W4yHfDHf
         nX4w==
X-Gm-Message-State: AOAM531aIEIoZwayxZflrRZK4ti4e5x+AIy55cYdFKqp1l/I6a1xZ8wH
        /NOgj5RoenizJ6c22p8eHNrxevxt1zFbHw==
X-Google-Smtp-Source: ABdhPJxnjPcTokHUACLdoooVP/8btbEjTpRoulfY5Y+69c5Qu/5K1OgjO31zOMCXMP0EmCxjsX5eTQ==
X-Received: by 2002:a50:e141:: with SMTP id i1mr105557567edl.157.1636358656929;
        Mon, 08 Nov 2021 00:04:16 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id mp5sm7962309ejc.68.2021.11.08.00.04.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 00:04:16 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 10/12] libtracefs: Update kprobes man pages
Date:   Mon,  8 Nov 2021 10:04:02 +0200
Message-Id: <20211108080404.55814-11-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211108080404.55814-1-tz.stoyanov@gmail.com>
References: <20211108080404.55814-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As there are a lot of changes in the libtracefs kprobes APIs, the
documentation of the library should be updated.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-kprobes.txt | 94 +++++++++++-----------------
 Documentation/libtracefs.txt         |  6 ++
 2 files changed, 41 insertions(+), 59 deletions(-)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index c10576e..4a4bf01 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -3,7 +3,8 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_get_kprobes, tracefs_kprobe_info, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
+tracefs_kprobe_alloc, tracefs_kretprobe_alloc, tracefs_kprobe_raw, tracefs_kretprobe_raw -
+Allocate, get, and create kprobes
 
 SYNOPSIS
 --------
@@ -11,18 +12,30 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
-int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
-char pass:[*]pass:[*]tracefs_get_kprobes(enum tracefs_kprobe_type type);
-enum tracefs_kprobe_type tracefs_kprobe_info(const char pass:[*]group, const char pass:[*]event,
-					     char pass:[*]pass:[*]type, char pass:[*]pass:[*]addr, char pass:[*]pass:[*]format);
-enum tracefs_kprobe_type tracefs_kprobe_type(const char pass:[*]group, const char pass:[*]event)
-int tracefs_kprobe_clear_all(bool force);
-int tracefs_kprobe_clear_probe(const char pass:[*]system, const char pass:[*]event, bool force);
+struct tracefs_dynevent pass:[*]
+*tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+		       const char pass:[*]_addr_, const char pass:[*]_format_);
+struct tracefs_dynevent pass:[*]
+*tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_,
+			  const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
+int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+			 const char pass:[*]_addr_, const char pass:[*]_format_);
+int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+			    const char pass:[*]_addr_, const char pass:[*]_format_);
 --
 
 DESCRIPTION
 -----------
+*tracefs_kprobe_alloc*() allocates a new kprobe context. The kbrobe is not configured in the system.
+The new kprobe will be in the _system_ group (or kprobes if _system_ is NULL) and have the name of
+_event_ (or _addr_ if _event_ is NULL). The kprobe will be inserted to _addr_ (function name, with
+or without offset, or a address), and the _format_ will define the format of the kprobe. See the
+Linux documentation file under: Documentation/trace/kprobetrace.rst
+
+*tracefs_kretprobe_alloc*() is the same as *tracefs_kprobe_alloc*, but allocates context for
+kretprobe. It has one additional parameter, which is optional, _max_ - maxactive count.
+See description of kretprobes in the Documentation/trace/kprobetrace.rst file.
+
 *tracefs_kprobe_raw*() will create a kprobe event. If _system_ is NULL, then
 the default "kprobes" is used for the group (event system). Otherwise if _system_
 is specified then the kprobe will be created under the group by that name. The
@@ -36,55 +49,17 @@ document.
 creates a kretprobe instead of a kprobe. The difference is also described
 in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
 
-*tracefs_get_kprobes*() returns an array of strings (char pass:[*]) that contain
-the registered kprobes and kretprobes depending on the given _type_. If _type_ is
-TRACEFS_ALL_KPROBES, then all kprobes found are returned. If _type_ is
-TRACEFS_KPROBE, then only normal kprobes are returned. If _type_ is
-TRACEFS_KRETPROBE, then only kretprobes are returned.
-The names are in the "system/event" format.
-That is, one string holds both the kprobe's name as well as the group it is
-defined under. These strings are allocated and may be modified with the
-*strtok*(3) and *strtok_r*(3) functions. The string returned must be freed with
-*tracefs_list_free*(3).
-
-*tracefs_kprobe_info*() returns the type of the given kprobe. If _group_ is
-NULL, then the default "kprobes" is used. If _type_ is non NULL, then it will
-hold an allocated string that holds the type portion of the kprobe in the
-kprobe_events file (the content before the ":"). If _addr_ is non NULL, it will
-hold the address or function that the kprobe is attached to. If _format_ is non
-NULL, it will hold the format string of the kprobe. Note, that the content in
-_type_, _addr_, and _format_ must be freed with free(3) if they are set. Even
-in the case of an error, as they may hold information of what caused the error.
-
-*tracefs_kprobe_clear_all*() will try to remove all kprobes that have been
-registered. If the @force flag is set, it will then disable those kprobe events
-if they are enabled and then try to clear the kprobes.
-
-*tracefs_kprobe_clear_probe*() will try to clear specified kprobes. If _system_
-is NULL, then it will only clear the default kprobes under the "kprobes" group.
-If _event_ is NULL, it will clear all kprobes under the given _system_. If the
-_force_ flag is set, then it will disable the given kprobe events before clearing
-them.
-
 RETURN VALUE
 ------------
 
-*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_clear_all*(),
-and *tracefs_kprobe_clear_probe*() return 0 on success, or -1 on error.
-
-If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*()
-then *tracefs_error_last*(3) may be used to retrieve the error message explaining
-the parsing issue.
-
-*tracefs_get_kprobes*() returns an allocate string list of allocated strings
-on success that must be freed with *tracefs_list_free*(3) and returns
-NULL on error.
+*tracefs_kprobe_raw*() and *tracefs_kretprobe_raw*() return 0 on success, or -1 on error.
+If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*() then
+*tracefs_error_last*(3) may be used to retrieve the error message explaining the parsing issue.
 
-*tracefs_kprobe_info*() returns the type of the given kprobe. It returns
-TRACEFS_KPROBE for normal kprobes, TRACEFS_KRETPROBE for kretprobes, and
-on error, or if the kprobe is not found TRACEFS_ALL_KPROBES is returned.
-If _type_, _addr_, or _format_ are non NULL, they will contain allocated
-strings that must be freed by free(3) even in the case of error.
+The *tracefs_kprobe_alloc*() and *tracefs_kretprobe_alloc*() APIs return a pointer to an allocated
+tracefs_dynevent structure, describing the probe. This pointer must be freed by
+*tracefs_dynevent_free*(3). Note, this only allocates a descriptor representing the kprobe. It does
+not modify the running system.
 
 ERRORS
 ------
@@ -96,9 +71,10 @@ The following errors are for all the above calls:
 
 *ENOMEM* Memory allocation error.
 
-*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() can fail with the following errors:
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_alloc*(),
+and *tracefs_kretprobe_alloc*() can fail with the following errors:
 
-*EBADMSG* Either _addr_ or _format_ are NULL.
+*EBADMSG* if _addr_ is NULL.
 
 *EINVAL*  Most likely a parsing error occurred (use *tracefs_error_last*(3) to possibly
           see what that error was).
@@ -217,7 +193,7 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
 
 	kprobe_create("open", "do_sys_openat2",
 		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
@@ -247,7 +223,7 @@ int main (int argc, char **argv, char **env)
 	} while (waitpid(pid, NULL, WNOHANG) != pid);
 
 	/* Will disable the events */
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_dynevent_destroy_all(TRACEFS_DYNEVENT_KPROBE | TRACEFS_DYNEVENT_KRETPROBE, true);
 	tracefs_instance_destroy(instance);
 	tep_free(tep);
 
@@ -293,5 +269,5 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 
 COPYING
 -------
-Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
 the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 2c9eabd..430d02e 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -63,6 +63,12 @@ Writing data in the trace buffer:
 
 Control library logs:
 	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
+
+Kprobes and Kretprobes:
+	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, unsigned int _max_);
+	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+	int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 --
 
 DESCRIPTION
-- 
2.31.1

