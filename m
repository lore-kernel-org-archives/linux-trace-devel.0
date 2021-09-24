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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8E9C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FB8C6103D
	for <linux-trace-devel@archiver.kernel.org>; Fri, 24 Sep 2021 09:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245440AbhIXJ6v (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 05:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245366AbhIXJ6u (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 05:58:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF5DC061574
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:17 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id g8so33953997edt.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 24 Sep 2021 02:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4odmzpDi60uR+rmTTCdS/sgV65qAvxbWzIa/TiYa5NM=;
        b=qIYyvmHeNNnWJrz38CiIPL/0gJm8mdNT+wrmRHPsNNGLBcOa1IOOCmrLt9JmQUYm8B
         9n/tlV+aao1bzDbIYcZyYOXY+eS9NR2Q0Wn2DpBa0UswhS4K0EMmnmtwiBWQCY0lt90H
         kS9Rzrh5twIynLq8qB+tavSmCaev1p1e3aEYsnumLbfadvesfRYOLI7VJD5TII4cy983
         1Nm8T1za/fXEpgs4RPlhO/fcfqU6hdG0ArrHCOBpFiUsh4xK5UqVS7e2LlQ9Wdxz3V5T
         JvQKQFaI7Na3CEx1Pehs/S46aQaEdI+P8ak458L47Kr24hIcxgrob/JZtCUgz6YyV+A7
         sP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4odmzpDi60uR+rmTTCdS/sgV65qAvxbWzIa/TiYa5NM=;
        b=ZZcZzoUNrdRMABW70Vi/mQGNQOc1YitL/+eB0QRYlZPdrrl1SWjuL8AmuBmQIWOlD0
         6p6M1sEVxiFIXeN6LioF4YS8LOQUdugFpjIxLHt0BcY1s5uz97cZirFnIfY0f89S/9bh
         F+MnZNRKPmSZmXkPoFWV1NlGUCFtXq4ZtSnUGKrPeFRNUx2BD+vLqmHgUegSUEpGFmp6
         6ZsFq0GRsIwAtmWusn4DSrxVxCQGgCW1NTbaPUI29r7MfL85wLohwTZXDmiHm2OorM7f
         tVz8dtkKW3htopeNTddRf01D4E2xHszeqWzC0JxsjM9ALGcemYHoymwztngbdxyKeZaT
         Bkng==
X-Gm-Message-State: AOAM530ehuzaH4wsPE5r7PuAf9EV2mdoIOu9H61GZXTBpPQOqgjESDIX
        j26iI4pKxObceGIDmTf6q4/lg/P7n9k=
X-Google-Smtp-Source: ABdhPJxBsXlHDIlJ2jHRrmgBfsMxYl7Ylcmb7F/m+JdQhJO2+lYVw0Jxt5TWtLIZnBSDDbgoGtLEjA==
X-Received: by 2002:a50:cfc3:: with SMTP id i3mr3843475edk.36.1632477436278;
        Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id n13sm4635907ejk.97.2021.09.24.02.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:57:16 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 3/4] libtracefs: Add new 'hist' APIs
Date:   Fri, 24 Sep 2021 12:57:01 +0300
Message-Id: <20210924095702.151826-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210924095702.151826-1-y.karadz@gmail.com>
References: <20210924095702.151826-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new APIs will be valuable in a number of different scenarios.
For example if the user wants to implement a function that does
the readout of a histogram, the only argument that will have to
be passed to this function is the histogram descriptor. The same
applies for the case when the user wants to print an adequate
error message in a case of a failure.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h  |  3 +++
 src/tracefs-hist.c | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 230bc41..ebe83fe 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -329,6 +329,9 @@ struct tracefs_hist *
 tracefs_hist_alloc(struct tep_handle *tep,
 		   const char *system, const char *event_name,
 		   struct tracefs_hist_axis *axes);
+const char *tracefs_get_hist_name(struct tracefs_hist *hist);
+const char *tracefs_get_hist_event(struct tracefs_hist *hist);
+const char *tracefs_get_hist_system(struct tracefs_hist *hist);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index a7c20de..27bab00 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -39,6 +39,21 @@ struct tracefs_hist {
 	unsigned int		filter_state;
 };
 
+const char *tracefs_get_hist_name(struct tracefs_hist *hist)
+{
+	return hist ? hist->name : NULL;
+}
+
+const char *tracefs_get_hist_event(struct tracefs_hist *hist)
+{
+	return hist ? hist->event_name : NULL;
+}
+
+const char *tracefs_get_hist_system(struct tracefs_hist *hist)
+{
+	return hist ? hist->system : NULL;
+}
+
 static void add_list(struct trace_seq *seq, const char *start,
 		     char **list)
 {
-- 
2.30.2

