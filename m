Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA11EC433B4
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C93DD6139E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Apr 2021 03:48:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348437AbhDGDsk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 23:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbhDGDsk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 23:48:40 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AACC06174A
        for <linux-trace-devel@vger.kernel.org>; Tue,  6 Apr 2021 20:48:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x7so16315059wrw.10
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Apr 2021 20:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTrrOjheyODyYOoClyjpDFGkqyffXuRBbUQv0pwSG5M=;
        b=R/rwfHHlzm4DR0F0KMY84yVIqF+rkl5mOefakP8tsnJvP6q7sGj1EydbMGZqdVUtqo
         SyioozOJOa6o0yO8oIF8WPyNkn3m6YtlO1ht0+dq3GPFAEGiOtIvIGnBnkJF/hpvHs4e
         tjHzJ8olpD95y8rNUzC8PwAOifgEiDl4aCuTrAd8KClpkvQMivwhfmAALTpajSV/9dih
         FMwTW18xf62SFbZRYDH6uG478Xlej6oebm8mOdI2Z4kpRaR5Q9Q0n2O64IKNHBiyZdAk
         sXckazCRHmH+Bbj2H+4dmQC3R2zscjZMELi9sEM+ZpK6TQPKjaEyLCAS4lkwQyVi6GSl
         BR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTrrOjheyODyYOoClyjpDFGkqyffXuRBbUQv0pwSG5M=;
        b=HQUjfaI7vMQdzNly3pXz45Bm4hYZ+XcYy2j1LYHcIHeNtU9ysKBCAKa9LduDDtupH5
         EYTnPyVcEk6ErEinDGjBeLHZ6yz8GSSur0n6e/oPTj/PuSt3OYwd5AZFDffoyEW8UCqA
         YqQ/0+XMBvmURvlPt1dBPl97SjW9EQLYhwBX3m7ZBVOQFRdRszeVQgbsANmMTTU7OQ49
         2ZYYBKoOWKNyyTstVQRQFtmNvcd8Tf+IzqQhdfG1tnCIiWwFWYYyX6WFhmwFlhWUGDK7
         mMllA6lIoRFvjXHIeWXR8iW95DpOoEbQJVPznkOWalD9gY09n6g9HKfelZ0tn6ifLtGo
         N//Q==
X-Gm-Message-State: AOAM532lMI+AfSpw/IS2k0vTvtEEdTvG1GAr3Q/R8Nw/LU2x8sHvDket
        Ys+bs1vuWXKFZMdjCI8SSME=
X-Google-Smtp-Source: ABdhPJw1+t0+VTE5Z1KgR5NvsAqB/97l2JikYhGdagXaCDI9/kThLjqCfKigCHnLBW71Wo9Vsmerpw==
X-Received: by 2002:a05:6000:1209:: with SMTP id e9mr1654027wrx.36.1617767308453;
        Tue, 06 Apr 2021 20:48:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id l21sm5684973wmg.41.2021.04.06.20.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 20:48:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] libtracefs: tracefs_iterate_raw_events() documentation update
Date:   Wed,  7 Apr 2021 06:48:22 +0300
Message-Id: <20210407034822.2373958-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
References: <20210407034822.2373958-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Updated the man page of tracefs_iterate_raw_events() API:
 - Fixed a typo in the function name.
 - Added a new sentence, describing the iteration in sorted order.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 Documentation/libtracefs-events.txt | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/libtracefs-events.txt b/Documentation/libtracefs-events.txt
index 9608a12..78c9834 100644
--- a/Documentation/libtracefs-events.txt
+++ b/Documentation/libtracefs-events.txt
@@ -37,14 +37,14 @@ local machine, or it may be a path to a copy of the tracefs directory
 from another machine. The last entry in the array as a NULL pointer.
 The array must be freed with _tracefs_list_free()_ API.
 
-The _tracefs_interate_raw_events()_ function will read the tracefs raw
+The _tracefs_iterate_raw_events()_ function will read the tracefs raw
 data buffers and call the specified _callback_ function for every event it
-encounters. An initialized _tep_ handler is required (See
-_tracefs_local_events_(3)). If _instance_ is NULL, then the toplevel
-tracefs buffer is used, otherwise the buffer for the corresponding
-_instance_ is read. To filter only on a subset of CPUs, _cpus_ and
-_cpu_size_ may be set to only call _callback_ with events that occurred on
-the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
+encounters. Events are iterated in sorted order: oldest first. An initialized
+_tep_ handler is required (See _tracefs_local_events_(3)). If _instance_ is
+NULL, then the toplevel tracefs buffer is used, otherwise the buffer for
+the corresponding _instance_ is read. To filter only on a subset of CPUs,
+_cpus_ and _cpu_size_ may be set to only call _callback_ with events that
+occurred on the CPUs specified, otherwise if _cpus_ is NULL then the _callback_
 function will be called for all events, and _cpu_size_ is ignored. The
 _callback_ function will be called with the following parameters: A
 pointer to a struct tep_event that corresponds to the type of event the
-- 
2.30.2

