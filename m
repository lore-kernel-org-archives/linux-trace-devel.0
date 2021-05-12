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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE82C43462
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A89D961927
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 May 2021 06:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbhELGjo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 May 2021 02:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhELGjm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 May 2021 02:39:42 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF43C061760
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:30 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id j26so22038132edf.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 23:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T9eIxjxaxhocZQRyjD0lWh0WnJn5g8jbP9shwgVRU1Y=;
        b=BCAzbXotzSF+7a10JtQdwFugKMdiYntY/WD3dnyET743+O8h1HEoPVcAOywSkidasK
         IC5M2kf7PvEt+XQiVKTNWbEyFCfQWjQHm7YjDjnqor1Hk1Awq2fWbwmLmbV1EKA9uSJ7
         VCopdxZy4i42zPSZAD8ToIa4sRE9EHg3OanoUoeBZjUPn0uE72X9OFwiH1T8cI09zQ0J
         hKnDLsZMiHeV+2pKyk/M3w+7MRTMVAn6ARWfO1AMvfRPyWzZgQDHM+OjW25sB5wlvUfL
         p5uNW3cfmCdOqJapRQ7LcZEAVAvGL1W0Ocss4GWbyQ/Kd0FkzbHffOKFCR5immybQTuf
         J1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T9eIxjxaxhocZQRyjD0lWh0WnJn5g8jbP9shwgVRU1Y=;
        b=TecYd9sY3Jp7xqK1IBpW6/G5phF4U4CaaOxMOv+t47POdytWPKF5wUdFwQOOxnkIi3
         Roz3rESs8RFtaewacNQHBujyY3ilHCQlAWGQVnmG9WWAS9Vrw5bWbYGQgDczW9aCbt99
         dcRTcgOSb59nrHoiHlrVWJ8wGBctqAea/cFcUfRyp9PxffKatCsjp/e1q2/y4cfi2hxW
         L4Wo7i5EWnBLleheawqMn9PDeyfnuxTN1xJsR+H6Z78xGodQyWgkG400bq5O2I+2RvJD
         eAqw5jnl/Ywqxa8RdgSoTFzjlmB6rOYDy7bVyAjEza02S81mVUI2YeqP3dblWWmOJqwW
         utlg==
X-Gm-Message-State: AOAM530uqqfshMlkWL4hv3Sqc0Obe1vs0GP0+xrIcW03CIyMcntI3IhO
        F4qzm65SFRUBCMoiiENzRtY=
X-Google-Smtp-Source: ABdhPJzzRD1ypwM9X6nNUIACR7uw5bLZFrI6mIhv+wESdU9YNNFuxEj/8jUUOw+NqPEygdGpXbkHkA==
X-Received: by 2002:aa7:c4d0:: with SMTP id p16mr42547532edr.102.1620801509638;
        Tue, 11 May 2021 23:38:29 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id h23sm13387723ejx.90.2021.05.11.23.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 23:38:29 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/25] trace-cmd library: Add new API to get file version of input handler
Date:   Wed, 12 May 2021 09:38:02 +0300
Message-Id: <20210512063823.324610-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512063823.324610-1-tz.stoyanov@gmail.com>
References: <20210512063823.324610-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 136057b4..6a211333 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index b095004d..9c9180d6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4046,6 +4046,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1

