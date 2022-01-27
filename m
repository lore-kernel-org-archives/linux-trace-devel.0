Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E239CC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 07:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiA0HBR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 02:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237028AbiA0HBQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 02:01:16 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D834C061714
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id p12so2258074edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 23:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gvUm1vMVMOle4NmzvmM/AB+u9q/Lv/ZKTMKXzLSz9zI=;
        b=EfLaTJzoUvmYpZBiJIfjcyOiRjel9vYu0mHiGWypIGrg2nYMw1Dv6kTzTzsxDWE1Sw
         ncdzpfOqNPQFxIAjhsrJvy9tBye3rdRnUmuEvnWnepknig5zmKJn8KMjwkk4cX9SXvrW
         Mn2Luk74Styn75WDgGF9ZTjjQ37zJ5s4z+OejPOi0Loghjif+kTxEGLjhTt89dbsTIcf
         sEEzLfxDkDPqRTHjXZBbCskbCHvdm3x8xyLcsQjNkU2Ap2q2OZf4qBzfQczNrmv5lP64
         HE6mWPik+3O9dUWC4CalLdAq823ShkOHVC2LBUCfzQ/lZgAKBi7F3c/uveb9vwv4le25
         2o3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gvUm1vMVMOle4NmzvmM/AB+u9q/Lv/ZKTMKXzLSz9zI=;
        b=wW+aTefA1u0CJcLPq/3PC4l1Jncl87kc1t4dhQmNoxuEhZQ7TimAg6Jwbr9fjo6+wV
         Kj+nJ3sXZOHJsWMGSTGF7x9Z6ahmlGzpdj13HfTfSdUXgwLfiytL7ct3baBEMCfzlVzl
         2/ssAM/sWKfWCAHleuyRgGTllS6LJf5pl6C+vZtqOBm1B4KOHbIp3DyYHXNB6P8tWAR6
         pAGgv9eAGl3rdcLztoAMuM6uQl6dQvONFE7iedoV+tfgfszRLigHMj3hGWtS1RRmNqbW
         7N9fA1QZieOfRl0PsPI3pzRqS4UdPPS7HZyMLGTngRa7uT6nr3cTnDJgjBu29Q1YqJR+
         Kqfw==
X-Gm-Message-State: AOAM5337+bpFvt835AFcocYdvcLE5MnIM1YFnX4Sx3QqbfqXxkOuqSdN
        H8PWT2KLFyih1okaUtbBpEpS2HLxk+k=
X-Google-Smtp-Source: ABdhPJyv5LCDPWHBRX6mKphzxr1cNx4L4WFnLpBkOsSDAqY8AR24bcbEoqeiA642RrIX7Bg4MOYyaA==
X-Received: by 2002:a05:6402:5248:: with SMTP id t8mr2402688edd.14.1643266874604;
        Wed, 26 Jan 2022 23:01:14 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id i17sm8317079ejp.60.2022.01.26.23.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:01:14 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 1/3] trace-cruncher: Add support for event probes
Date:   Thu, 27 Jan 2022 09:01:09 +0200
Message-Id: <20220127070111.27529-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127070111.27529-1-tz.stoyanov@gmail.com>
References: <20220127070111.27529-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Event probe (eprobe) is a new type of ftrace dynamic events, introduced
in the Linux kernel 5.15 version. It is useful to have support for it in
trace-cruncher, as it allows more flexibility when printing event's
data.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 src/ftracepy-utils.c | 32 ++++++++++++++++++++++++++++++++
 src/ftracepy-utils.h |  2 ++
 src/ftracepy.c       |  5 +++++
 3 files changed, 39 insertions(+)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 8c46590..053b659 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2315,6 +2315,38 @@ struct tep_event *dynevent_get_event(PyDynevent *event,
 	return tep_evt;
 }
 
+PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
+{
+	static char *kwlist[] = {"event", "target_system", "target_event", "fetchargs", NULL};
+	const char *event, *target_system, *target_event, *fetchargs;
+	struct tracefs_dynevent *eprobe;
+
+	if (!PyArg_ParseTupleAndKeywords(args,
+					 kwargs,
+					 "ssss",
+					 kwlist,
+					 &event,
+					 &target_system,
+					 &target_event,
+					 &fetchargs)) {
+		return NULL;
+	}
+
+	eprobe = tracefs_eprobe_alloc(TC_SYS, event, target_system, target_event, fetchargs);
+	if (!eprobe) {
+		MEM_ERROR;
+		return NULL;
+	}
+
+	if (tracefs_dynevent_create(eprobe) < 0) {
+		TfsError_fmt(NULL, "Failed to create eprobe '%s'", event);
+		tracefs_dynevent_free(eprobe);
+		return NULL;
+	}
+
+	return PyDynevent_New(eprobe);
+}
+
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
 			    struct tep_handle *tep,
 			    struct tep_event *event)
diff --git a/src/ftracepy-utils.h b/src/ftracepy-utils.h
index 7612df6..c96fd85 100644
--- a/src/ftracepy-utils.h
+++ b/src/ftracepy-utils.h
@@ -251,6 +251,8 @@ PyObject *PyFtrace_register_kprobe(PyObject *self, PyObject *args,
 PyObject *PyFtrace_register_kretprobe(PyObject *self, PyObject *args,
 						      PyObject *kwargs);
 
+PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs);
+
 PyObject *PyFtrace_hist(PyObject *self, PyObject *args,
 					PyObject *kwargs);
 
diff --git a/src/ftracepy.c b/src/ftracepy.c
index 3f71b5e..464e8d3 100644
--- a/src/ftracepy.c
+++ b/src/ftracepy.c
@@ -460,6 +460,11 @@ static PyMethodDef ftracepy_methods[] = {
 	 METH_VARARGS | METH_KEYWORDS,
 	 "Define a kretprobe."
 	},
+	{"eprobe",
+	 (PyCFunction) PyFtrace_eprobe,
+	 METH_VARARGS | METH_KEYWORDS,
+	 "Define an eprobe."
+	},
 	{"hist",
 	 (PyCFunction) PyFtrace_hist,
 	 METH_VARARGS | METH_KEYWORDS,
-- 
2.34.1

