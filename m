Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3529CC76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbjC1PEo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:04:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233743AbjC1PEn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:04:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D15E1BE
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:27 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id er13so10000237edb.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680015803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLexE4hV5RcIMrtWhZ1iLaaKsSBFW1qEVRQhNP8XCcw=;
        b=FCf63UEOIlBnMpBDjV2TxUy5Q64Sk79hPTExKHuggXIzoAek5KNR1aF5dY6HVbIrlz
         iZdxm2mQdyF8ntBkOQvxttUaHr1/10/m5A3QBB7gVx5C7HPs+OEJXcSp7g1HVi1Em9Xp
         5U9rxDkrMFV81I1Y/UP7i3oJqc4LHDQEpeVNtwhQurbWvozWUZPAy1DaDib/uVZ44KYO
         6Z9jhFGTv2dEZqJOYGN4GgnO3YiVgEPKiPGwZNi0N7CpTOXbkFY7/H5mKDuUZMUOGw6i
         EXfQKSFqGD8msPQVGvDLCqra4T9kFE3Wkp55WAZEHZho4TxLhQ3xn0JqanM3auHGXmqM
         B0uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680015803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xLexE4hV5RcIMrtWhZ1iLaaKsSBFW1qEVRQhNP8XCcw=;
        b=K1bT4/1NhSdp/wPbrkPNvYbOVo4u/aJ7TNpM4OWR4Hmc/gnpA1eCbabdsRRUpT6i9O
         G1eXRdXb9xZ3F+4V/AhZavlrRNIwvDVkf03AbL8w8WwbzQedr5lr1JwOOLdracVX6+s1
         dXJTtdTjxncgagW/wtl3AOBZn5xRUQ9mK9sCQ0BF3W0TWuufxkzttYxaYITE7vaanAww
         KOjfzhv19pvonbYO57inG+KoZ7Lz9KPHM3YRZiUjmonKw6UiJYD9yQc9xQ4GqIPZdTvJ
         o78dso8w/nXd9ASIFwMqOpQu7Rhgwy/+HvYauObitG0dckPGnpZYFYs5RspSBxwFfQow
         dBrw==
X-Gm-Message-State: AAQBX9eFgrB012pEeiVAMt3QKeKwzRJO2uo7+eY49jzE2xTrpYk4RVKw
        c2JJsCnwITIBnCFYWXWDqePsbrotnnk=
X-Google-Smtp-Source: AKy350bj7d8BLfRKNp0trBLLfVTKZPk6ayyEOkA58vmzM44fQCfO6O68hyNJHgResxxt2Bys5Yj6Dw==
X-Received: by 2002:a17:906:641:b0:8b1:77bf:3bdd with SMTP id t1-20020a170906064100b008b177bf3bddmr17106359ejb.36.1680015803536;
        Tue, 28 Mar 2023 08:03:23 -0700 (PDT)
Received: from oberon.zico.biz (77-85-190-39.ip.btc-net.bg. [77.85.190.39])
        by smtp.gmail.com with ESMTPSA id q5-20020a50cc85000000b005024aff3bb5sm1440100edi.80.2023.03.28.08.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 08:03:23 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 1/2] libtracefs: New API to set synthetic event instance
Date:   Tue, 28 Mar 2023 18:03:20 +0300
Message-Id: <20230328150321.34808-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230328150321.34808-1-tz.stoyanov@gmail.com>
References: <20230328150321.34808-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The current implementation of tracefs_synth_create() API always creates
the synthetic event in the top trace instance - the "trigger" files of
the start and end events are updated in the context of the top instance.
Then the same synthetic event can be enabled and operates in any trace
instance. That logic works well in the most use cases, where there is a
single application, managing these events and the trace process.
However, there are use cases where multiple applications can run
different trace sessions, each in its own trace instance. For those use
cases, the default logic does not work well - the synthetic event can be
created by one application in the top instance, and cannot be reused
easily by any other applications in different trace instance.
The tracefs_synth structure already has an instance context, but there
is no way to set it to other than default top instance. That's why a new
API is introduced: tracefs_synth_set_instance(), which sets the instance
in the tracefs_synth structure. If that API is called before
tracefs_synth_create(), then the "trigger" files will be updated only in
the context of that user instance, instead of the default one. This
allows synthetic events to be more flexible and reduces the interference
between different trace instance.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 include/tracefs.h  |  1 +
 src/tracefs-hist.c | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/tracefs.h b/include/tracefs.h
index 3547b5a..9a53e0e 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -607,6 +607,7 @@ struct tracefs_hist *tracefs_synth_get_start_hist(struct tracefs_synth *synth);
 int tracefs_synth_create(struct tracefs_synth *synth);
 int tracefs_synth_destroy(struct tracefs_synth *synth);
 void tracefs_synth_free(struct tracefs_synth *synth);
+int tracefs_synth_set_instance(struct tracefs_synth *synth, struct tracefs_instance *instance);
 int tracefs_synth_echo_cmd(struct trace_seq *seq, struct tracefs_synth *synth);
 int tracefs_synth_raw_fmt(struct trace_seq *seq, struct tracefs_synth *synth);
 const char *tracefs_synth_show_event(struct tracefs_synth *synth);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index fb6231e..9141bbb 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -2178,6 +2178,25 @@ tracefs_synth_get_start_hist(struct tracefs_synth *synth)
 	return hist;
 }
 
+/**
+ * tracefs_synth_set_instance - Set the ftrace instance of the synthetic events
+ * @synth: The tracefs_synth descriptor
+ * @instance: ftrace instance
+ *
+ * Set the ftrace instance, in which the synthetic event will be created. By default,
+ * the top instance is used. This API must be called before the call to tracefs_synth_create(),
+ * in order to use the new instance when creating the event.
+ *
+ * Returns 0 on success and -1 on error.
+ */
+int tracefs_synth_set_instance(struct tracefs_synth *synth, struct tracefs_instance *instance)
+{
+	if (!synth)
+		return -1;
+	synth->instance = instance;
+	return 0;
+}
+
 /**
  * tracefs_synth_create - creates the synthetic event on the system
  * @synth: The tracefs_synth descriptor
-- 
2.39.2

