Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CE0C433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Dec 2021 14:28:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237848AbhLGOb4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Dec 2021 09:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237847AbhLGObz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Dec 2021 09:31:55 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACB8C061574
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Dec 2021 06:28:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id j3so29933792wrp.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Dec 2021 06:28:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dvXSG2Z8paPu1JORUilm+boErBzVId94/Fotl3zZJ8k=;
        b=Z08gErfRddGeTgeLQcKx5o8yvgJ7sOBfEySh0Js/2t5oEQLx6cosvdTI0ocOTyrKel
         I8x6hjnFvIwzrIw1h70SS/V57kLd3C5dGm8XyqsHw711TIEZR/BojKKRoM9CMbf4TSB7
         4PdLohllrpRio6Old+daEeFqM94YAoT4+1q9TTubU9GokDcc53gK/WcxwKaC7BIr51Ev
         yGta7DE2UpI4d9cvWDVQbuHxa06cQkzDNYV4QbqZQew8jZQLR8Jbsl+8684Oq1QKVM+U
         53wXuT4WvWaxIS/86acB8BdZDIwcjfpuaYWOhcrip6y0XZmP7UucaPOWkTk336dyd3vq
         +6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dvXSG2Z8paPu1JORUilm+boErBzVId94/Fotl3zZJ8k=;
        b=L+Z4Oo/oy5Nvm83YybR3krYTBJof4ES1muLEo02dk4YkAJ4ChWZmql7gdeREPN2Ahr
         EZb8IuKzggGWMdxaIvALFC/v41DFrTk81Uy2Bav45gIYyOk+B3Ng8egpx3jCWwY/va2H
         F4sT/Qw4cszw8Xln4v/JGAxOOXO0lIOMwuChUki8JBHW9KhF5aymcAav7lgcjmOkdwTH
         TL2p0M++oLqgwLxiV2IMgD8hEYs4vyTgeKSDZ04pxadlgjEjcIPzoVSRsbsgD/avhcbx
         lUSgB1XRAFBAiSf4Z0cFESHLNVuIogQyn6LYioh+mocKhFnkaeZd/d5GpMWJM+EPqydE
         7CqA==
X-Gm-Message-State: AOAM533Kx6vBEumhOjMhLt7Pfy6V+RIexTigho0Ew4qUQ/lxytjDe3QQ
        Grrk//1OnaDIbM3UTn6dj6Gsxjj8mwM=
X-Google-Smtp-Source: ABdhPJyMeK2fMAf+QCW6k9TkrAtyWQ0sorwxiLZHJ+nXdepdSevzUMebPSkN5yJ2gHhmREb4n24s1A==
X-Received: by 2002:adf:d1c2:: with SMTP id b2mr49710429wrd.369.1638887303412;
        Tue, 07 Dec 2021 06:28:23 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id l4sm14301428wrv.94.2021.12.07.06.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 06:28:23 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/5] trace-cruncher: Define Python type for trace histograms
Date:   Tue,  7 Dec 2021 16:28:07 +0200
Message-Id: <20211207142811.398929-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211207142811.398929-1-y.karadz@gmail.com>
References: <20211207142811.398929-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new Python type will be used to implement new APIs for working
with histograms.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 70e86ff..da31998 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -28,6 +28,8 @@ struct tracefs_dynevent;
 
 C_OBJECT_WRAPPER_DECLARE(tracefs_dynevent, PyDynevent);
 
+C_OBJECT_WRAPPER_DECLARE(tracefs_hist, PyTraceHist)
+
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
diff --git a/src/ftracepy.c b/src/ftracepy.c
index fcc69dd..0f06796 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -168,6 +168,14 @@ C_OBJECT_WRAPPER(tracefs_dynevent, PyDynevent,
 		 dynevent_destroy,
 		 tracefs_dynevent_free)
 
+static PyMethodDef PyTraceHist_methods[] = {
+	{NULL, NULL, 0, NULL}
+};
+
+C_OBJECT_WRAPPER(tracefs_hist, PyTraceHist,
+		 NO_DESTROY,
+		 tracefs_hist_free)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -387,6 +395,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyDyneventTypeInit())
 		return NULL;
 
+	if (!PyTraceHistTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -403,7 +414,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
 	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
 	PyModule_AddObject(module, "tracefs_dynevent", (PyObject *) &PyDyneventType);
-
+	PyModule_AddObject(module, "tracefs_hist", (PyObject *) &PyTraceHistType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.32.0

