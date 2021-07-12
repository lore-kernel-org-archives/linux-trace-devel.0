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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8BE6C07E9C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 894586023F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 12 Jul 2021 12:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhGLMfq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 12 Jul 2021 08:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhGLMfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 08:35:45 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E605C0613E8
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:56 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ca14so10846478edb.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 12 Jul 2021 05:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rSz6mrPqwJsEnJmiYaSEC1iXC3vlmtFLYEes6zINfZU=;
        b=gVa3c+06fkxNfmprF9br2mBScfnbY1s3KnYzGJdg2h68/J0nrh0h9JL+4/pyvBdqB8
         4xvFeKdDF0MuMeghuFZQZY2IUXlNUaTQWe/F8kufzg5Df6CgqM6L0qS4mh4GZOSIfFV4
         MZAFUZ+HBgSxvvnnk+QmesingsDix6/vCwGMWWZ0oNy4tvYZfJf9q9mbpk7uPoU1No67
         yKtbqbQPns13LLOGMBdT2QUuuxYQ4dJRZse6M7PhvjEaMvA20yb9C4mxoAOVq+oxj1h8
         ohrUYFwrKwcHytOpsbb6TQQtD9h8zw8hvROo16x1/yTBqL1g5Yy+FVR4ZpZOb4l88BGw
         jeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rSz6mrPqwJsEnJmiYaSEC1iXC3vlmtFLYEes6zINfZU=;
        b=kknFimeOtC3siGIUCPfChwG8PFCWP8m2Mq9QJfCEfH/rTZwYWRa0BcDBq0+9vWtLht
         HpqiJ2TU0SYJ6lfkp93qLjIRd3hcAWJAOeCWCP6FZ03v8LOxgmHGrBdYhh1liqbuJ0hO
         J57B/MZhu8DOn0eMSjJuS2XZtudaiJRIRLnThtbNW8d8qdc2SELhEWLxOsy8HfiICiL/
         QCM92Jex1hncQqCyWcZEgGmwbvFN8m2p0VQ53Em1s1qMKlr0ywsmdvYYXYUTvdc8iRUl
         pKJvJES0du3g36UDwzUsdZO/JbmozlP4dJuFFgAgAjuHpL+I05z6e7BM35e0LoAU+lzA
         7gQw==
X-Gm-Message-State: AOAM533o91u+MOAy+0t6X+o9vchO2W1nVqFrrqCceZzWnvFnUyFVV2+2
        eGsxiNsuYc0qew8Iw+f1WWuWN1waCRE=
X-Google-Smtp-Source: ABdhPJz92rFXZ8uEglA50I3FC6zCNeuLbCI0nvi5z6LF6JFb0GHql0vz+SJRieM5ox2PbrQfG9js6g==
X-Received: by 2002:a05:6402:33a:: with SMTP id q26mr12453592edw.369.1626093175060;
        Mon, 12 Jul 2021 05:32:55 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.98])
        by smtp.gmail.com with ESMTPSA id z5sm6477473ejn.65.2021.07.12.05.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:32:54 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] trace-cruncher: Allow for detachable instances
Date:   Mon, 12 Jul 2021 15:32:41 +0300
Message-Id: <20210712123242.223500-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210712123242.223500-1-y.karadz@gmail.com>
References: <20210712123242.223500-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

 If the instance is created with "detached=True", the Python module is
 no longer responsible for destroying it when exiting. It is therefore
 up to the user free it explicitly, or to keep it active.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8f4b50c..d061817 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -421,6 +421,12 @@ static PyObject *tfs_list2py_list(char **list)
 
 struct instance_wrapper {
 	struct tracefs_instance *ptr;
+	bool detached;
+
+	/*
+	 * This name will be used only for searching. The actual name of
+	 * the instance is owned by the "tracefs_instance" object.
+	 */
 	const char *name;
 };
 
@@ -451,10 +457,12 @@ void instance_wrapper_free(void *ptr)
 
 	iw = ptr;
 	if (iw->ptr) {
-		if (tracefs_instance_destroy(iw->ptr) < 0)
-			fprintf(stderr,
-				"\ntfs_error: Failed to destroy instance '%s'.\n",
-				get_instance_name(iw->ptr));
+		if (!iw->detached) {
+			if (tracefs_instance_destroy(iw->ptr) < 0)
+				fprintf(stderr,
+					"\ntfs_error: Failed to destroy instance '%s'.\n",
+					get_instance_name(iw->ptr));
+		}
 
 		free(iw->ptr);
 	}
@@ -569,14 +577,16 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 	struct tracefs_instance *instance;
 	const char *name = NO_ARG;
 	int tracing_on = true;
+	int detached = false;
+	static char *kwlist[] = {"name", "tracing_on", "detached", NULL};
 
-	static char *kwlist[] = {"name", "tracing_on", NULL};
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "|sp",
+					 "|spp",
 					 kwlist,
 					 &name,
-					 &tracing_on)) {
+					 &tracing_on,
+					 &detached)) {
 		return NULL;
 	}
 
@@ -600,6 +610,11 @@ PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
 	}
 
 	iw->ptr = instance;
+	if (detached) {
+		printf("detached instance: %s\n", name);
+		iw->detached = detached;
+	}
+
 	iw_ptr = tsearch(iw, &instance_root, instance_compare);
 	if (!iw_ptr || !(*iw_ptr) || !(*iw_ptr)->ptr ||
 	    strcmp(tracefs_instance_get_name((*iw_ptr)->ptr), name) != 0) {
-- 
2.27.0

