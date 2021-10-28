Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC14C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5A76610CA
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Oct 2021 12:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbhJ1MLw (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhJ1MLv (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Oct 2021 08:11:51 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC97C061570
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:24 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r4so23323556edi.5
        for <linux-trace-devel@vger.kernel.org>; Thu, 28 Oct 2021 05:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LLgu0pTh5aNZXI0VMzPHrVqAeNkE6vx4RGu3/+0aF3E=;
        b=cwrHMaS0maLfNIJvIGQi4qVrP4Gkp+82eOc6KmGElkLGdOyHoBHhY7Thv/m0wo0JRz
         L0OnDmuybwo9sh1EOppXj1HW/kVsvBjZsqHBUuu3SRMPx8TNTA9Cxel/86/wCEy/4mLs
         BohdpocsQJ4v/0vrZ3ZX6Wta6pFpKWFJ88lCGeWqWLrxsNPouKE4hPskLYIRig8wie74
         31yTuNu5AUbO3ti4qDw7d1RxyUtfztt+y8OOO+jD+9P5JJbpOcvgRYEPUZ3+pPzWK2D8
         DgTVK0QiED/mHXIptiJDEl5GILrkiVRfUZRJvOb35yx2OZu8Wrwitm5yUVvhb938lvuO
         pafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LLgu0pTh5aNZXI0VMzPHrVqAeNkE6vx4RGu3/+0aF3E=;
        b=nLKB043FMHx4EpFuyEvNWUxG+T0ZfG3elp5d/HoUKh4Wv9ctyStIuYAeipd4wavW0w
         wjtciltfDKKKuUwCsh/cFargeimlNIoIs0alUiEKD8yoY+GDh8TWiNR9u84XFDq1WKWS
         djH+WiPW5VLvCPbyWWJxu/oqjb1fLlLXGrHsrAFeEvaDacqbemdXhZScBGqmkn3i1E1Z
         2kQuDEIsi8zWkoWH3T+a4QCxLrhF/1X7MnQwe4Jc8Axs8VPFN+OKStyzCQiG0/prcDCz
         aZdOOYYo5PEP0s3sr5HrPDoUcRBaaQZV7kW4oPjhAI2jyfYClXiP04cnmOKEk1Hl0tyf
         OJmQ==
X-Gm-Message-State: AOAM5316YrM2EwwTWXwUHCFq/Ip0rHuwuHYAOudvjKCg4Ynsg5cUm+Ga
        czZIQ8qrKyiGpCZaABbJT1qF3TRxZIzkyw==
X-Google-Smtp-Source: ABdhPJyYZXWKM41xbtv2wHWXl8kRfJJ3e0d76bMRG6XsPkkV5Eksq9tctUbhH4NLUKgrkbxrrvNaNQ==
X-Received: by 2002:a05:6402:438f:: with SMTP id o15mr5358965edc.301.1635422959263;
        Thu, 28 Oct 2021 05:09:19 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id v6sm1803003edc.52.2021.10.28.05.09.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 05:09:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 09/12] libtracefs: Update kprobes man pages
Date:   Thu, 28 Oct 2021 15:09:04 +0300
Message-Id: <20211028120907.101847-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211028120907.101847-1-tz.stoyanov@gmail.com>
References: <20211028120907.101847-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As there are a lot of changes in the libtracefs kprobes APIs, the
documentation of library should be updated.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-kprobes.txt | 135 ++++++++++++++++-----------
 1 file changed, 79 insertions(+), 56 deletions(-)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index ca48fa9..c11cd5c 100644
--- a/Documentation/libtracefs-kprobes.txt
+++ b/Documentation/libtracefs-kprobes.txt
@@ -3,7 +3,10 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_kprobe_raw, tracefs_kretprobe_raw, tracefs_kprobes_get, tracefs_kprobe_info, tracefs_kprobe_clear_all, tracefs_kprobe_clear_probe - Create, list, and destroy kprobes
+tracefs_kprobe_alloc, tracefs_kretprobe_alloc, tracefs_kprobe_create,
+tracefs_kprobe_destroy, tracefs_kprobe_free, tracefs_kprobes_get,
+tracefs_kprobe_info, tracefs_kprobe_raw, tracefs_kretprobe_raw - Create, get, and destroy kprobes
+
 
 SYNOPSIS
 --------
@@ -11,18 +14,67 @@ SYNOPSIS
 --
 *#include <tracefs.h>*
 
-int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
-int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event, const char pass:[*]addr, const char pass:[*]format);
-char pass:[*]pass:[*]tracefs_kprobes_get(enum tracefs_kprobe_type type);
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
+			  const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
+void *tracefs_kprobe_free*(struct tracefs_dynevent pass:[*]_kprobe_);
+int *tracefs_kprobe_create*(struct tracefs_dynevent pass:[*]_kprobe_);
+int *tracefs_kprobe_destroy*(struct tracefs_dynevent pass:[*]_kprobe_, bool _force_);
+int *tracefs_kprobes_get*(enum tracefs_kprobe_type _type_,
+			  struct tracefs_dynevent pass:[*]pass:[*]pass:[*]_kprobes_);
+enum tracefs_kprobe_type *tracefs_kprobe_info*(struct tracefs_dynevent pass:[*]_kprobe_,
+					       char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_,
+					       char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_,
+					       char pass:[*]pass:[*]_format_);
+int tracefs_kprobe_raw(const char pass:[*]system, const char pass:[*]event,
+		       const char pass:[*]addr, const char pass:[*]format);
+int tracefs_kretprobe_raw(const char pass:[*]system, const char pass:[*]event,
+			  const char pass:[*]addr, const char pass:[*]format);
 --
 
 DESCRIPTION
 -----------
+*tracefs_kprobe_alloc*() allocates a new kprobe context. The kbrobe is not configured in the system.
+The new kprobe will be in the _system_ group (or kprobes if _system_ is NULL). Have the name of
+_event_ (or _addr_ if _event_ is NULL). Will be inserted to _addr_ (function name, with or without
+offset, or a address). And the _format_ will define the format of the kprobe. See the Linux
+documentation file under: Documentation/trace/kprobetrace.rst
+
+*tracefs_kretprobe_alloc*() is the same as *tracefs_kprobe_alloc*, but allocates context for
+kretprobe. It has one additional parameter, which is optional, _max_ - maxactive count.
+See description of kretprobes in the Documentation/trace/kprobetrace.rst file.
+
+*tracefs_kprobe_free*() frees a kprobe context, allocated with *tracefs_kprobe_alloc*() or
+*tracefs_kretprobe_alloc*(). The kprobe is not removed from the system.
+
+*tracefs_kprobe_create*() creates a kprobe or kretprobe in the system. The probe is described by the
+given _kprobe_ context.
+
+*tracefs_kprobe_destroy*() will try to remove the specified _kprobe_ from the system. If _kprobe_
+is NULL, all kprobes and kretprobes in the system will be removed. If the _force_ flag is set, then
+it will disable the given kprobe events before removing them.
+
+*tracefs_kprobes_get*() returns the count of the registered kprobes and kretprobes in the system,
+depending on the given _type_. If _type_ is TRACEFS_ALL_KPROBES, then all kprobes found are
+counted. If _type_ is TRACEFS_KPROBE, then only normal kprobes are counted. If _type_ is
+TRACEFS_KRETPROBE, then only kretprobes are counted. If the _kprobes_ parameter in not NULL, then
+an array of pointers to kprobe contexts is allocated and passed back via _kprobes_. The size of this
+array is the returned count + 1, as the last element is a NULL pointer. The array must be freed with
+*tracefs_dynevent_list_free*(3).
+
+*tracefs_kprobe_info*() returns the type and information of a given _kprobe_. If any of the
+_system_, _event_, _prefix_, _addr_ or _format_ arguments are not NULL, then strings are allocated
+and returned back via these arguments. The _system_ and _event_ holds the system and the name of the
+kprobe. If _prefix_ is non NULL, then it will hold an allocated string that holds the prefix portion
+of the kprobe in the kprobe_events file (the content up to the ":", including it). Note that for
+kretprobes, the max active count is encoded in the prefix srting. If _addr_ is non NULL, it will
+hold the address or function that the kprobe is attached to. If _format_ is non NULL, it will hold
+the format string of the kprobe. Note, that the content in _group_, _event_, _prefix_, _addr_, and
+_format_ must be freed with free(3) if they are set.
+
 *tracefs_kprobe_raw*() will create a kprobe event. If _system_ is NULL, then
 the default "kprobes" is used for the group (event system). Otherwise if _system_
 is specified then the kprobe will be created under the group by that name. The
@@ -36,55 +88,25 @@ document.
 creates a kretprobe instead of a kprobe. The difference is also described
 in the Linux kernel source in the Documentation/trace/kprobetrace.rst file.
 
-*tracefs_kprobes_get*() returns an array of strings (char pass:[*]) that contain
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
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_create*(),
+and *tracefs_kprobe_destroy*() return 0 on success, or -1 on error.
 
-If a parsing error occurs on *tracefs_kprobe_raw*() or *tracefs_kretprobe_raw*()
-then *tracefs_error_last*(3) may be used to retrieve the error message explaining
-the parsing issue.
+If a parsing error occurs on *tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() or
+*tracefs_kprobe_create*() then *tracefs_error_last*(3) may be used to retrieve the error message
+explaining the parsing issue.
 
-*tracefs_kprobes_get*() returns an allocate string list of allocated strings
-on success that must be freed with *tracefs_list_free*(3) and returns
-NULL on error.
+*tracefs_kprobes_get*() returns a count of the requested krpobe types, or -1 in case of an error.
+If the _kprobes_ parameter in not NULL, then an array of pointers to kprobe contexts is allocated
+and passed back via _kprobes_. The size of this array is the returned count + 1, as the last element
+is a NULL pointer. The array must be freed with *tracefs_dynevent_list_free*(3).
 
-*tracefs_kprobe_info*() returns the type of the given kprobe. It returns
-TRACEFS_KPROBE for normal kprobes, TRACEFS_KRETPROBE for kretprobes, and
-on error, or if the kprobe is not found TRACEFS_ALL_KPROBES is returned.
-If _type_, _addr_, or _format_ are non NULL, they will contain allocated
-strings that must be freed by free(3) even in the case of error.
+*tracefs_kprobe_info*() returns the type of the given kprobe. It returns TRACEFS_KPROBE for normal
+kprobes, TRACEFS_KRETPROBE for kretprobes or TRACEFS_ALL_KPROBES on error. If _system_, _event_,
+_prefix_, _addr_, or _format_ are non NULL, they will contain allocated strings that must be freed
+by free(3).
 
 ERRORS
 ------
@@ -96,7 +118,8 @@ The following errors are for all the above calls:
 
 *ENOMEM* Memory allocation error.
 
-*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() can fail with the following errors:
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_alloc*(),
+*tracefs_kretprobe_alloc*() and *tracefs_kprobe_create*() can fail with the following errors:
 
 *EBADMSG* Either _addr_ or _format_ are NULL.
 
@@ -217,7 +240,7 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_kprobe_destroy(NULL, true);
 
 	kprobe_create("open", "do_sys_openat2",
 		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
@@ -247,7 +270,7 @@ int main (int argc, char **argv, char **env)
 	} while (waitpid(pid, NULL, WNOHANG) != pid);
 
 	/* Will disable the events */
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_kprobe_destroy(NULL, true);
 	tracefs_instance_destroy(instance);
 	tep_free(tep);
 
@@ -293,5 +316,5 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 
 COPYING
 -------
-Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
 the terms of the GNU Public License (GPL).
-- 
2.31.1

