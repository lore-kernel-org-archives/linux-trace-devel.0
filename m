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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49827C432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CF0B60FD9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 17 Aug 2021 16:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhHQQmV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 17 Aug 2021 12:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhHQQmT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 17 Aug 2021 12:42:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958D0C0613CF
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:45 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qk33so39791153ejc.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 17 Aug 2021 09:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cUXOAd3UwL3ba5bajTmLLYoNhzK48AfPGaXJbynwjvs=;
        b=MibvHmPw0oew2AOZyHdeix9jyH2SODQXzkBg/UKV9Ol8w/Nl9mryupiCtsYlA+tZJm
         +nNM1/ef3ij2Gi1Oscta4JAa1z1IK2Tv9QpMY1fMG5bhmpge42cUCR2/EUoPd+HdxBSQ
         2WwaDXiEUffAgSzmXebOvJnX7lcEBFjFKcNYYuwWsO9q7B317sEJGA/8H8tLGGcj6V0k
         uW/RnaenP/+0iF76qrpxEgjO96S+BP5C1xqna7QwVGEtVfixxhyhyKCvtFg1H8C85kSE
         kQ978H23hVlGLnjEOGxbpnnaOggWuo+O3FsHCOy/cjZxqLtNRD/pBfuK689T7c3DHb/k
         p/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cUXOAd3UwL3ba5bajTmLLYoNhzK48AfPGaXJbynwjvs=;
        b=L44txU2eq49IeXyRh24y5zioqlmLjBJ+EIlTbLs4Gs7RkJMNi9sr6pS2Mvr1+dEITg
         wFx7ktD6o5VJCnzTv0lfE03fYh/lUiFD8i9SeOSHZiW7ykTyiDqdEHqR0sc8o0pKhTef
         dB39hpSExk45UY7j8J3PevL5O7l7LXSuHVyA0b69G511oLUvHKjYSVegoecsimMO56M2
         Z+TKYOJ/C6ZIOtKnWk/ho62Z3wVIXO729MHbrYNudZA9oEMxMarb0bVlQqD0JBGYvxvJ
         oQB36naIw1VWlT2I6sA4y5w4WtF9Rx8QGglqDbhxeZ43epTdj2wUIt20ZV8aORhJH9dy
         aBvA==
X-Gm-Message-State: AOAM533+m54kwXuR557bxe8wXFTcD16ItfEQfCtAnFkxWEMksZua7+0I
        x7UONj/ZzGYxexoMAT6syaXPBbdEd1g=
X-Google-Smtp-Source: ABdhPJx0kZQYxkEwuoBBX2pqRJjcl6HKX8H6AvOvozwPTttrxELcrUrWaBWTECxZYhl08PDmUbBp5Q==
X-Received: by 2002:a17:907:7615:: with SMTP id jx21mr4834114ejc.505.1629218503954;
        Tue, 17 Aug 2021 09:41:43 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id i16sm968283ejx.78.2021.08.17.09.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 09:41:43 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/4] trace-cruncher: Define Python type for instances
Date:   Tue, 17 Aug 2021 19:41:09 +0300
Message-Id: <20210817164110.152016-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817164110.152016-1-y.karadz@gmail.com>
References: <20210817164110.152016-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

We add a custom Python type that wraps the 'tracefs_instance' object,
defined in libtracefs. This is a preparation for a general refactorung
of the way libtracefs instances are handled by trace-cruncher.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c |  5 +++++
 src/ftracepy-utils.h |  4 ++++
 src/ftracepy.c       | 15 +++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 6739db7..6b2f879 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -531,6 +531,11 @@ bool get_instance_from_arg(PyObject *args, PyObject *kwargs,
 	return true;
 }
 
+PyObject *PyTfsInstance_dir(PyTfsInstance *self)
+{
+	return PyUnicode_FromString(tracefs_instance_get_dir(self->ptrObj));
+}
+
 PyObject *PyFtrace_dir(PyObject *self)
 {
 	return PyUnicode_FromString(tracefs_tracing_dir());
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 5d7c19c..cf75e0b 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -22,6 +22,8 @@ C_OBJECT_WRAPPER_DECLARE(tep_event, PyTepEvent)
 
 C_OBJECT_WRAPPER_DECLARE(tep_handle, PyTep)
 
+C_OBJECT_WRAPPER_DECLARE(tracefs_instance, PyTfsInstance)
+
 PyObject *PyTepRecord_time(PyTepRecord* self);
 
 PyObject *PyTepRecord_cpu(PyTepRecord* self);
@@ -44,6 +46,8 @@ PyObject *PyTep_init_local(PyTep *self, PyObject *args,
 PyObject *PyTep_get_event(PyTep *self, PyObject *args,
 				       PyObject *kwargs);
 
+PyObject *PyTfsInstance_dir(PyTfsInstance *self);
+
 PyObject *PyFtrace_dir(PyObject *self);
 
 PyObject *PyFtrace_create_instance(PyObject *self, PyObject *args,
diff --git a/src/ftracepy.c b/src/ftracepy.c
index e3fec7b..628a53a 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -73,6 +73,17 @@ static PyMethodDef PyTep_methods[] = {
 
 C_OBJECT_WRAPPER(tep_handle, PyTep, tep_free)
 
+static PyMethodDef PyTfsInstance_methods[] = {
+	{"dir",
+	 (PyCFunction) PyTfsInstance_dir,
+	 METH_NOARGS,
+	 "Get the absolute path to the instance directory."
+	},
+	{NULL, NULL, 0, NULL}
+};
+
+C_OBJECT_WRAPPER(tracefs_instance, PyTfsInstance, tracefs_instance_destroy)
+
 static PyMethodDef ftracepy_methods[] = {
 	{"dir",
 	 (PyCFunction) PyFtrace_dir,
@@ -321,6 +332,9 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	if (!PyTepRecordTypeInit())
 		return NULL;
 
+	if (!PyTfsInstanceTypeInit())
+		return NULL;
+
 	TFS_ERROR = PyErr_NewException("tracecruncher.ftracepy.tfs_error",
 				       NULL, NULL);
 
@@ -335,6 +349,7 @@ PyMODINIT_FUNC PyInit_ftracepy(void)
 	PyModule_AddObject(module, "tep_handle", (PyObject *) &PyTepType);
 	PyModule_AddObject(module, "tep_event", (PyObject *) &PyTepEventType);
 	PyModule_AddObject(module, "tep_record", (PyObject *) &PyTepRecordType);
+	PyModule_AddObject(module, "tracefs_instance", (PyObject *) &PyTfsInstanceType);
 
 	PyModule_AddObject(module, "tfs_error", TFS_ERROR);
 	PyModule_AddObject(module, "tep_error", TEP_ERROR);
-- 
2.30.2

