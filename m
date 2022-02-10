Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A29D2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Feb 2022 15:24:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235764AbiBJPYA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Feb 2022 10:24:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243603AbiBJPX7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:59 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631DD1B3
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:24:00 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k3-20020a1ca103000000b0037bdea84f9cso4196886wme.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Feb 2022 07:24:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q1IT0Zx4eG+kfenTVvoJfj/dOVRCkZbDtjprEsbEM/A=;
        b=jJKc0KgDMb0vhGtzzJThJntP91cQ3gsh3uU1J4+9sNcBorgtuHXKcPsCIEtnXURjRl
         piMM2+t25rMAmACqVikX+ayQCKVFfphsBJISgpJrEamh0HH4RRXQr5eioOzopEVKq/PK
         RrTxySe0gzy8HOuziEchH2teIsWaxUFgdiLwnjTLcIjUzB9429e/aJOdLcm/pVGGkliC
         VfhJi5ISsutpjvmo+PK9ArdaN2HAagaRSpQG3gcv7ABuuyBPWuG5o/UZ1wgX2/BbaQLZ
         vqqJmUhU6F3e8NXol5uvQyJSnl7YT7y2NWenpyY1vv+v/grp2Rd9cYF4CdsuvediXKUs
         nh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q1IT0Zx4eG+kfenTVvoJfj/dOVRCkZbDtjprEsbEM/A=;
        b=tIHORZy/OMCkLQzOepdSFnmpvuFa6DCTzk2bk6AwvFyNIm4cY5S7DDd1Badq7VrpQo
         82YxWjFf1ChuWvu7JzcOt8leQ7p3FJvDPDgSbtAZigAX1g0kZ9Uw0A+IzG7x0I/AV4L0
         zF/v0Sz9wR20KcGZ3RISEk1AjLQ6WQpNNt9QN+RkZBCsfjVbX294reMw0iRhjkkcKwtT
         kGRd3dJDumek9Lvo6ZTIHHj/djcrH1N5TN0gqK9gB/hulUKrfq/XOeW/OKWSShDe+kvY
         kZr7evcJ3rXYqf+b/hBgUbDDdO35ICZhHlAnkQJajgrL1XqSMuwe66gIpGWozFzFKwzO
         MiAg==
X-Gm-Message-State: AOAM531MJ93IiVVa3aptcnI3+9YXZ10TOvSLGSa1aTWx/VFwgPp2mErh
        aYI716P9iCLaFmBz+txizPvDuZZyWMY=
X-Google-Smtp-Source: ABdhPJwyFPiv8Q2whJlG38xcTzX88RZwPNN62TUHhZb61++/bLqIqE0vzZUqwh51aptd0c+/SOZj5g==
X-Received: by 2002:a05:600c:1e2a:: with SMTP id ay42mr2601643wmb.131.1644506638806;
        Thu, 10 Feb 2022 07:23:58 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j15sm2245301wmq.19.2022.02.10.07.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 07:23:58 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 7/8] trace-cruncher: Check kernel support in the eprobe constructor
Date:   Thu, 10 Feb 2022 17:23:38 +0200
Message-Id: <20220210152339.363943-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220210152339.363943-1-y.karadz@gmail.com>
References: <20220210152339.363943-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

'eprobes' have been introduced in kernel version 5.15. Before trying to
create eprobe, we have to check if suport is avaiable. In the case of
using an older version of the kernel, an apropriate error message is
provided.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 48 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 47 insertions(+), 1 deletion(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 20f0cd9..85f5bbc 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -12,6 +12,7 @@
 // C
 #include <search.h>
 #include <string.h>
+#include <sys/utsname.h>
 #include <sys/wait.h>
 #include <signal.h>
 #include <time.h>
@@ -23,6 +24,47 @@ PyObject *TFS_ERROR;
 PyObject *TEP_ERROR;
 PyObject *TRACECRUNCHER_ERROR;
 
+static char *kernel_version()
+{
+	struct utsname uts;
+
+	if (uname(&uts) != 0) {
+		PyErr_SetString(TFS_ERROR, "Failed to get kernel version.");
+		return NULL;
+	}
+
+	return strdup(uts.release);
+}
+
+static bool check_kernel_support(const char *api, int major, int minor)
+{
+	char *buff, *this_kernel = kernel_version();
+	const char *dlm = ".";
+	bool ret = false;
+	int mj, mn;
+
+        buff = strtok(this_kernel, dlm);
+	mj = atoi(buff);
+	if (mj > major)
+		ret = true;
+
+	if (mj == major) {
+		buff = strtok(NULL, dlm);
+		mn = atoi(buff);
+		if (mn >= minor)
+			ret = true;
+	}
+
+	free(this_kernel);
+	if (!ret) {
+		PyErr_Format(TFS_ERROR,
+			     "Using \'%s()\' requires kernel versions >= %i.%i",
+			     api, major, minor);
+	}
+
+	return ret;
+}
+
 static const char *get_instance_name(struct tracefs_instance *instance);
 
 static char *tfs_error_log(struct tracefs_instance *instance, bool *ok)
@@ -2382,6 +2424,10 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 		return NULL;
 	}
 
+	/* 'eprobes' are introduced in kernel version 5.15. */
+	if (!check_kernel_support("eprobe", 5, 15))
+		return NULL;
+
 	eprobe = tracefs_eprobe_alloc(TC_SYS, event, target_system, target_event, fetchargs);
 	if (!eprobe) {
 		MEM_ERROR;
@@ -2395,7 +2441,7 @@ PyObject *PyFtrace_eprobe(PyObject *self, PyObject *args, PyObject *kwargs)
 	 * there is no need to 'destroy' this event at exit.
 	 */
 	set_destroy_flag(py_dyn, false);
-	return py_dyn;;
+	return py_dyn;
 }
 
 static PyObject *set_filter(PyObject *args, PyObject *kwargs,
-- 
2.32.0

