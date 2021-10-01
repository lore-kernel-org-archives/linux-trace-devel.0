Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10772C433EF
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E817661A6F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353417AbhJANfp (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353457AbhJANfp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40C0C06177C
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:34:00 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id r18so34768458edv.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lqLfeCXW8Co0+lShPB+Fd57Z4uhlbTbc6z8AwLR/XZw=;
        b=SUlcB2sbgthDPH/giQg5bWAZHzaafkNOW+t6DuSpKLj7nXrs/TSSCze+BaiOh5kl+Z
         Ji/lxbipQmM0UpmiAhZI0C5KS1QFD44w36Fdf00+QSfESnmB3ljezeYodltgpK7RyW88
         QcQ3nNXVVjEPTipH532+76thH0JV8cHmeDjcX4eWa/9VmQNBcyhCtcuQoeMx1/mjd8a1
         094blY+vCpAlJoAmyFgRyGXbgYxnUvnGPIgweLcHztcYjKLdTXtLuL+2Nsbj2j7y/wHq
         WsrgPa6m4efr0XqEEWDbsRc9PdI+rDCzXYwngoM3KJWRMwR9pwZKHnOzl8GMc9NzGGwW
         itbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lqLfeCXW8Co0+lShPB+Fd57Z4uhlbTbc6z8AwLR/XZw=;
        b=UHYVCxThMNJMR885TNl/WNiTxNXvsrA0mR58Ol+L2rWZuuy9eOJHYx1qw+RDtfc0Ra
         cZ/ynE2q0M8N295J3AhSNxNH4Qcaxt6Ab1lblIIwXn3MFHNjWRyvuFBUEzWCEYAolSY1
         KmktrOEMDh5pL73AiYo+M8Ebh2Y31VBg1WvkEOzRyfsPIaY9pf/2zKBfHAm0S1qJnQx5
         rc1SFqKrnNmvy98DdXgQdlScLG3p01Z4biYWRejUWkfP9rVyw48amsV8n6BlIOrQWLt/
         qcNo2XPc+/I3HInsJB4/ICmXhYQPglzbhib4S0gdw/XRav1Rvcx5sM2dPqbVoXEZNplR
         IEHQ==
X-Gm-Message-State: AOAM531fTQMVo4Bn5sPmnZQJZ9pnorQ6hhaV2tJ19bfR+VJ8zXLlrIUy
        ALlx+YDwHUOSbHuLd0AXY+4RKgR4ec0=
X-Google-Smtp-Source: ABdhPJwyvRPG4vkXIOXPxOZWIhddbKLtfgCWL8Q5XhUOAHOGxjGebzu/xCMzng7kT3HDFvBln/PMuA==
X-Received: by 2002:a05:6402:713:: with SMTP id w19mr6572907edx.366.1633095238907;
        Fri, 01 Oct 2021 06:33:58 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:58 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 5/5] trace-cruncher: Proper labeling of non libtracefs errors
Date:   Fri,  1 Oct 2021 16:33:46 +0300
Message-Id: <20211001133346.8217-6-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211001133346.8217-1-y.karadz@gmail.com>
References: <20211001133346.8217-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Those particular errors are internal for trace-cruncher and have
nothing to do with libtracefs. The labels must indicate this.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 1a8a136..d8115f6 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2031,14 +2031,15 @@ static PyObject *get_callback_func(const char *plugin_name, const char * py_call
 	py_name = PyUnicode_FromString(plugin_name);
 	py_module = PyImport_Import(py_name);
 	if (!py_module) {
-		TfsError_fmt(NULL, "Failed to import plugin \'%s\'",
+		PyErr_Format(TRACECRUNCHER_ERROR,
+			     "Failed to import plugin \'%s\'",
 			     plugin_name);
 		return NULL;
 	}
 
 	py_func = PyObject_GetAttrString(py_module, py_callback);
 	if (!py_func || !PyCallable_Check(py_func)) {
-		TfsError_fmt(NULL,
+		PyErr_Format(TRACECRUNCHER_ERROR,
 			     "Failed to import callback from \'%s\'",
 			     plugin_name);
 		return NULL;
@@ -2169,7 +2170,7 @@ PyObject *PyFtrace_trace_shell_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		TfsError_setstr(instance, "Failed to fork");
+		PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
 		return NULL;
 	}
 
@@ -2215,7 +2216,8 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 		return NULL;
 
 	if (!PyList_CheckExact(py_argv)) {
-		TfsError_setstr(instance, "Failed to parse \'argv\' list");
+		PyErr_SetString(TRACECRUNCHER_ERROR,
+				"Failed to parse \'argv\' list");
 		return NULL;
 	}
 
@@ -2223,7 +2225,7 @@ PyObject *PyFtrace_trace_process(PyObject *self, PyObject *args,
 
 	pid = fork();
 	if (pid < 0) {
-		TfsError_setstr(instance, "Failed to fork");
+		PyErr_SetString(TRACECRUNCHER_ERROR, "Failed to fork");
 		return NULL;
 	}
 
-- 
2.30.2

