Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3E2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB8B1610A8
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Nov 2021 09:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhKAJLy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Nov 2021 05:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231750AbhKAJLx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Nov 2021 05:11:53 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008C8C061764
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Nov 2021 02:09:19 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s1so62150708edd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Nov 2021 02:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5a3j78YMDZZe/qBYTVWWD4KXVFDReawqnya+THsiKWE=;
        b=Zy3YiWuOsaa5jdjDfml5BiX709aSS4nzG0GEk/nLPGtDLjj3fEYq8/KiNxMOkPi5vO
         cCOR9QmYjwRLhApFtssZNE3JL6aJ0DaOjZgr7S2z1nDGXUbBGEwuZ6pdQvPnTqfU2JFV
         O6+POc49qSY8WnzEd4pIJZpbLdZ4Ia5r1RLrseH1uAOmm61VERrpP471b095eu/K3Yty
         2t7haM1jpLsObFiudf/vF0z8DrbE5ZHdGGJe3s28265oquH6J9GoSIs0kRiSm1FWd1ni
         pFW4G2Y0cqT+JqbjuVSQo4gdtAFL/ZOu0oxHoEvOoU0Pzzr8cqQDUcwXzaLILntGHSEw
         /tJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5a3j78YMDZZe/qBYTVWWD4KXVFDReawqnya+THsiKWE=;
        b=rPBfjWXntcdqj7lk9/e6flVVMhAPyo5HSEMzjrSXL/YfM5RThl5T8z+E7xw/an1X23
         7zw0hHHh7lbRjatDKPqi/JEoYV9IJU8EVp5zbRog9aKD5xasDHxHgOxuAgMhtCuNmCS5
         UymBUk+S8FJ5AilI1rAufd3hlnOJyGIfzQmyM07VCRRf8PCN6ZgFADc7kCoQIhnSgSgx
         ZY1ALmRPuAKdA8p9AjiGtCqigREZmRi0DkUUoFS7YvJAcU4ZxIePcJXbc2XrOWNdHIvi
         JzFzlyVSZZ7XArhd9n+EhJHYwgpJpHl3RW1ZkzCpUtkf50ppexIrsHS4YeXrewdch4+Q
         pLbA==
X-Gm-Message-State: AOAM5319XnlYAzBnbOq+uKjLDQHBUWiK73i5jtFbeV4bCvcOLr+6OUSq
        L1o+3zoWdq9Ixy+jbK17sqeY7uUzMTVrYQ==
X-Google-Smtp-Source: ABdhPJygOkE/PhtTvez5rEl6wWcKrdG3D7GhdXasQfdcxmL+rfLn/b9UvJDTIXEYU03YU/IIeM5U4A==
X-Received: by 2002:a17:906:1db2:: with SMTP id u18mr34762940ejh.227.1635757758570;
        Mon, 01 Nov 2021 02:09:18 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i8sm9873222edc.10.2021.11.01.02.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 02:09:18 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org, y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 12/12] libtracefs: Document tracefs_dynevent_list_free() API
Date:   Mon,  1 Nov 2021 11:09:04 +0200
Message-Id: <20211101090904.81454-13-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211101090904.81454-1-tz.stoyanov@gmail.com>
References: <20211101090904.81454-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The newly added tracefs_dynevent_list_free() should be documented in the
library man pages.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-utils.txt | 6 +++++-
 Documentation/libtracefs.txt       | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/libtracefs-utils.txt b/Documentation/libtracefs-utils.txt
index 41544ab..3424673 100644
--- a/Documentation/libtracefs-utils.txt
+++ b/Documentation/libtracefs-utils.txt
@@ -3,7 +3,7 @@ libtracefs(3)
 
 NAME
 ----
-tracefs_tracers, tracefs_get_clock, tracefs_list_free -
+tracefs_tracers, tracefs_get_clock, tracefs_list_free, tracefs_dynevent_list_free -
 Helper functions for working with trace file system.
 
 SYNOPSIS
@@ -15,6 +15,7 @@ SYNOPSIS
 char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
 void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
+void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
 --
 
 DESCRIPTION
@@ -36,6 +37,9 @@ The _tracefs_list_free()_ function frees an array of strings, returned by
 _tracefs_event_systems()_, _tracefs_system_events()_ and _tracefs_tracers()_
 APIs.
 
+The _tracefs_dynevent_list_free()_ functions frees an array of pointers to dynamic event contexts,
+returned by_tracefs_kprobes_get()_ API.
+
 RETURN VALUE
 ------------
 The _tracefs_tracers()_ returns array of strings. The last element in that
diff --git a/Documentation/libtracefs.txt b/Documentation/libtracefs.txt
index 4a356c8..7889048 100644
--- a/Documentation/libtracefs.txt
+++ b/Documentation/libtracefs.txt
@@ -45,6 +45,7 @@ Trace helper functions:
 	void *tracefs_list_free*(char pass:[*]pass:[*]_list_);
 	char pass:[*]pass:[*]*tracefs_tracers*(const char pass:[*]_tracing_dir_);
 	char pass:[*]*tracefs_get_clock*(struct tracefs_instance pass:[*]_instance_);
+	void *tracefs_dynevent_list_free*(struct tracefs_dynevent pass:[*]pass:[*]_events_);
 	int *tracefs_trace_is_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_on*(struct tracefs_instance pass:[*]_instance_);
 	int *tracefs_trace_off*(struct tracefs_instance pass:[*]_instance_);
-- 
2.31.1

