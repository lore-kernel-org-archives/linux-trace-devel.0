Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D6A7C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC230610A8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhKAJLu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbhKAJLu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE51C061714
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z20so62429645edc.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wyFGG8j/G3UkyomEGA13QwUho5fIZPtNqmmfhjmEaWM=;
        b=aC3u03TM5AAvlRFhk4MYOZrcKgjZzjsTSpp4vt+30e9U6NVdLuKoCo8XA8t7c245+2
         wSA4SeGe5rvy4aVT/wfE5Tv1daM72+JDTZ3fjP7xefHT9/XvxytrDUAgXs3oPzls9c6j
         1TmaC8twKjAzi2kOKQh88R3MaEpDZiQh94F+PaAB8jy9GXWBengNNJLbEYiuIuADg1Wf
         GgoIsUnskh1K6buMtW2sMBQEdfGoO3xXq0Gbd5GJ/yFSg43V7Gy6Oo83DTqCdzpX3jSW
         lHPXbtr93MAvJcF90C3c12G4wb9y8jpSwgNVHhD5pvDb/CaHeAOfaorsgbUcpRVgZvYS
         s2fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wyFGG8j/G3UkyomEGA13QwUho5fIZPtNqmmfhjmEaWM=;
        b=R+LTT6evIxcn/lM3+KWtynDfxxTiYs2ew81OOxkkQS6srnJTAnjlJV9ubcK0WIounK
         24o/PMN+lZxYFQUIzuVc9W7la6YNkDrmwPKD6VaI2IvOC2bSGNHp7fYmDnX1a9C1mHwR
         lCkjQ3ICOYNLV64uUtF0LFksRydSj/8Yol8CwErJWQHBeB90PzYiuc8FoBQUhDZPfev/
         z69RWX2ZdNu9B94hPxCXsWW/pEb/HNCUzQEh0jCllRFVJxtAJ/zd9YcqIF/8UXF3L2IV
         RiL4SzlxJOc5cKvgKvIeN0b3mY2JG4smjG+Zz+HBmYH6EQH8967/suT9rhe34raBANM5
         0GYg==
X-Gm-Message-State: AOAM531sfYsmBWtKBarL1iKv+EtnS9HnBvoi5yRdOgBbrtwF89sWxAAv
        LnpSzP+ZZNlC5mPNLzL30FM=
X-Google-Smtp-Source: ABdhPJyXNBpZKEBjb0EQI/dupZl9D1tzO28bAUg1+2YFeeF42z8EfHg2Bex3ze5Fr2EcokpOdBnUIg==
X-Received: by 2002:a05:6402:1ac2:: with SMTP id ba2mr27084899edb.21.1635757755822;
        Mon, 01 Nov 2021 02:09:15 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:15 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 09/12] libtracefs: Update kprobes man pages
Date:   Mon,  1 Nov 2021 11:09:01 +0200
Message-Id: <20211101090904.81454-10-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

As there are a lot of changes in the libtracefs kprobes APIs, the
documentation of the library should be updated.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-kprobes.txt | 131 +++++++++++++++------------
 Documentation/libtracefs.txt         |  11 +++
 2 files changed, 86 insertions(+), 56 deletions(-)

diff --git a/Documentation/libtracefs-kprobes.txt b/Documentation/libtracefs-kprobes.txt
index ca48fa9..df9f2fa 100644
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
@@ -11,18 +14,64 @@ SYNOPSIS
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
+struct tracefs_dynevent pass:[*]pass:[*]*tracefs_kprobes_get*(enum tracefs_kprobe_type _type_);
+enum tracefs_kprobe_type *tracefs_kprobe_info*(struct tracefs_dynevent pass:[*]_kprobe_,
+					       char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_,
+					       char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_,
+					       char pass:[*]pass:[*]_format_);
+int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+			 const char pass:[*]_addr_, const char pass:[*]_format_);
+int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_,
+			    const char pass:[*]_addr_, const char pass:[*]_format_);
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
+*tracefs_kprobes_get*() return an array of pointers to kprobes and kretprobes in the system,
+depending on the given _type_. If _type_ is TRACEFS_ALL_KPROBES, then all kprobes found are
+returned. If _type_ is TRACEFS_KPROBE, then only normal kprobes are returned. If _type_ is
+TRACEFS_KRETPROBE, then only kretprobes are returned. The last element of the returned array is
+a NULL pointer. The array must be freed with *tracefs_dynevent_list_free*(3).
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
@@ -36,55 +85,24 @@ document.
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
+*tracefs_kprobes_get*() return an array of pointers to kprobes of the requested types, or NULL in
+case of an error. The last element is a NULL pointer. The array must be freed with
+*tracefs_dynevent_list_free*(3).
 
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
@@ -96,7 +114,8 @@ The following errors are for all the above calls:
 
 *ENOMEM* Memory allocation error.
 
-*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*() can fail with the following errors:
+*tracefs_kprobe_raw*(), *tracefs_kretprobe_raw*(), *tracefs_kprobe_alloc*(),
+*tracefs_kretprobe_alloc*() and *tracefs_kprobe_create*() can fail with the following errors:
 
 *EBADMSG* Either _addr_ or _format_ are NULL.
 
@@ -217,7 +236,7 @@ int main (int argc, char **argv, char **env)
 		exit(-1);
 	}
 
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_kprobe_destroy(NULL, true);
 
 	kprobe_create("open", "do_sys_openat2",
 		      "file=+0($arg2):ustring flags=+0($arg3):x64 mode=+8($arg3):x64\n");
@@ -247,7 +266,7 @@ int main (int argc, char **argv, char **env)
 	} while (waitpid(pid, NULL, WNOHANG) != pid);
 
 	/* Will disable the events */
-	tracefs_kprobe_clear_probe(mykprobe, NULL, true);
+	tracefs_kprobe_destroy(NULL, true);
 	tracefs_instance_destroy(instance);
 	tep_free(tep);
 
@@ -293,5 +312,5 @@ https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/
 
 COPYING
 -------
-Copyright \(C) 2020 VMware, Inc. Free use of this software is granted under
+Copyright \(C) 2021 VMware, Inc. Free use of this software is granted under
 the terms of the GNU Public License (GPL).
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 2c9eabd..4a356c8 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -63,6 +63,17 @@ Writing data in the trace buffer:
 
 Control library logs:
 	int *tracefs_set_loglevel*(enum tep_loglevel _level_);
+
+Kprobes and Kretprobes:
+	struct tracefs_dynevent pass:[*] *tracefs_kprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+	struct tracefs_dynevent pass:[*] *tracefs_kretprobe_alloc*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_, int _max_);
+	void *tracefs_kprobe_free*(struct tracefs_dynevent pass:[*]_kprobe_);
+	int *tracefs_kprobe_create*(struct tracefs_dynevent pass:[*]_kprobe_);
+	int *tracefs_kprobe_destroy*(struct tracefs_dynevent pass:[*]_kprobe_, bool _force_);
+	struct tracefs_dynevent pass:[*]pass:[*]*tracefs_kprobes_get*(enum tracefs_kprobe_type _type_);
+	enum tracefs_kprobe_type *tracefs_kprobe_info*(struct tracefs_dynevent pass:[*]_kprobe_, char pass:[*]pass:[*]_system_, char pass:[*]pass:[*]_event_, char pass:[*]pass:[*]_prefix_, char pass:[*]pass:[*]_addr_, char pass:[*]pass:[*]_format_);
+	int *tracefs_kprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
+	int *tracefs_kretprobe_raw*(const char pass:[*]_system_, const char pass:[*]_event_, const char pass:[*]_addr_, const char pass:[*]_format_);
 --
 
 DESCRIPTION
-- 
2.31.1

