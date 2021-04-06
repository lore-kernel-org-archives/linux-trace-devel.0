Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D94C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297B9613B7
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Apr 2021 04:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhDFEUR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhDFEUQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 00:20:16 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C74C06174A
        for <linux-trace-devel@vger.kernel.org>; Mon,  5 Apr 2021 21:20:08 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v11so12635952wro.7
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Apr 2021 21:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTrrOjheyODyYOoClyjpDFGkqyffXuRBbUQv0pwSG5M=;
        b=VAfyNftp9VlZQKu9lHBz4mmxTVQSKagCPErsNlZZNPYE3G/+HH1AxKyJBoDNAfWaOw
         Z2IvjNz3BlVq3oDW/n+hCAdzVRBaDs8jsDbSxFl++1LPuvl2bugSnCxY84i+YyugRxX5
         2P817ACEPDa/M7HfdQPRM6AldX5RyrMl/b1LFvB2Pcr968qMD9GGith3eKNm6beD+Psy
         kdBFfc7tre8TKePa2BHLypX5PbWiO8l7QZcuf7nWMAq08zaroS/qoA19zNV0VykfP2Zn
         UAAkvtahWg0OzuJefLpZXVEVdOupsCwHqYGvPlIJpbXQwIeu2o+3816qZnAx+dAeUFkL
         rpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTrrOjheyODyYOoClyjpDFGkqyffXuRBbUQv0pwSG5M=;
        b=fjVRKCCKlmVa93WFZsFWLqVhmA5v4hPWSh9vD41djilsESqOfaPKm/72K8tzlZvdeB
         HzfJ8QCUt+0FrjbECWR+5FWiLvkM51DwSGvZl22ID8058Yf2pCd/vf+SzpkLYQL/+AQ9
         GORObEgIG2b6Sg6/av8+QfhsOwsFrJT8gKkm3x0qgud+TfhjO1v+SFl/MsjhsrNguQLR
         Nn5qyHxx+itLewOiiQYOVOxGaYQbpwCAZaybRTrn0MP0yYT0KDfUJ8jq1H/D53gubnj3
         bdYY6jtlk/Fv2fCi8GmdFUh9ioMpsVzJq46hWzwEG/j9Ygw7/VPEjfGVU6v/DWofJzmq
         HrYA==
X-Gm-Message-State: AOAM533aPUSOZvzPyicgnJ3Qv7gsu++yEkD53N3zSIeG9reF7MFBUAXA
        gEEhqDLMVM/qXZV/v8ZEqUk=
X-Google-Smtp-Source: ABdhPJz3AJNIHaqBckVWdcrnun4P9kwZBwSKvjR9TvXWxF/Wr4jd053lNXTax40QEargjK3iDs7zcg==
X-Received: by 2002:a05:6000:14f:: with SMTP id r15mr8088363wrx.166.1617682806997;
        Mon, 05 Apr 2021 21:20:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id j23sm1325337wmo.33.2021.04.05.21.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:20:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] libtracefs: tracefs_iterate_raw_events() documentation update
Date:   Tue,  6 Apr 2021 07:20:01 +0300
Message-Id: <20210406042001.912544-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406042001.912544-1-tz.stoyanov@gmail.com>
References: <20210406042001.912544-1-tz.stoyanov@gmail.com>
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

