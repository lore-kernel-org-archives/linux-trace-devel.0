Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EC76C433FE
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 08:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5612860E0C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Nov 2021 08:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhKOJAN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Nov 2021 04:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236509AbhKOI6e (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Nov 2021 03:58:34 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D35EC0613B9
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 00:55:33 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id m14so68810486edd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Nov 2021 00:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoUcuq8cO5IATbgbbbhGVOV+55jxqLTe7rLcCWeFTB8=;
        b=bG9VrXIbZif7sFSKrifmASvIcSCe4eml4HjwXN8z7VC+WqafkhHqzXpu2srXa3PRDJ
         1KBeip9VFNqS+1haQKNQBNm0u1/0SV2gWK0+sHG5FPs5MKmHuhoiizZ0zRWLYT5WGsk9
         TnRy5a3cMCo0IiIZx5HVJkYzyOd2KocMaKpJfW+k/Jg1SqX7AG0nXokvvC0bg8jYLwIv
         I4+lU1VmdEYecqJ7gWgOMllv4eWcgMkrm1y4NJhfDtAWMNbx07bSoMTiOyB/T/OQp3EE
         wBMGoOhVIlQGsgQmT9BLfjUQUffpaQkOoVbyKp3pfjoZi4k+4B87tdLcudhCtxLFO73o
         azpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EoUcuq8cO5IATbgbbbhGVOV+55jxqLTe7rLcCWeFTB8=;
        b=2tQ/awApDlJgIRiboeBQlGOIw3gIiLqoR3avqcvhVRksyFpJ4oZmPm9u7hqP4SzyDy
         iBiBMSXVdo+JLBzUf7j35ZoNcWTV5CQZ6kSXsLgQ6UepFj+pgnTVH2mZzQaJ8NWMdzOw
         xnjRGPLJm4VbwSxi8U3hJzRTRBWwifB/R3tGqLxJIxUSX8YWoEv6+HwTbqHZStGZhv+H
         bBZsDD/q3P0tXlq7GRkuxeUSpP0EYxiDemrm7cDICQJZbzCn78vcLC3Dzi72PN6qJFO+
         hfYtmQ7qs524ZvIY/yDUcOmryIZCU+3r7AYVnhLnMF/YNy6e6SpXxXGTJ40Jh7BCs+LD
         PV/A==
X-Gm-Message-State: AOAM533iwmJzUOxH4q7GAr8BbXnvwpP/0HF4tB4X5lu84zpjkgqOgz5n
        klWlAhaNnGky94HOWTXkb+ZlgG3P5wo=
X-Google-Smtp-Source: ABdhPJwS47iqsRGt5HZzIouOrtiz9XcLqOajeJdGOuyJo6mRW7xr0vUuBzTOzFiL0eJtrqLdAew19A==
X-Received: by 2002:a17:906:4fc8:: with SMTP id i8mr46626937ejw.342.1636966531526;
        Mon, 15 Nov 2021 00:55:31 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id f7sm7056709edl.33.2021.11.15.00.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 00:55:31 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/2] trace-cruncher: More options for stopping data iteration
Date:   Mon, 15 Nov 2021 10:55:17 +0200
Message-Id: <20211115085518.204852-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far the only option to stop the iteration over the tracing data
from the callback function was to call 'sys.exit()'. However, this
only stops the iteration without actually exiting. With this change
calling 'sys.exit()' will terminate (exit the module), while in
order to just stop the iteration, the callback should return nonzero
integer value.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index d25d873..8e803ee 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2046,21 +2046,36 @@ static int callback(struct tep_event *event, struct tep_record *record,
 	ret = PyObject_CallObject((PyObject *)ctx->py_callback, arglist);
 	Py_DECREF(arglist);
 
-	if (ret) {
-		Py_DECREF(ret);
-	} else {
+	if (!ret) {
 		if (PyErr_Occurred()) {
-			if (PyErr_ExceptionMatches(PyExc_SystemExit)) {
-				PyErr_Clear();
+			PyObject *err_type, *err_value, *err_traceback;
+
+			PyErr_Fetch(&err_type, &err_value, &err_traceback);
+			if (err_type == PyExc_SystemExit) {
+				if (PyLong_CheckExact(err_value))
+					Py_Exit(PyLong_AsLong(err_value));
+				else
+					Py_Exit(0);
 			} else {
+				PyErr_Restore(err_type, err_value, err_traceback);
 				PyErr_Print();
 			}
 		}
 
-		ctx->status = false;
+		goto stop;
+	}
+
+	if (PyLong_CheckExact(ret) && PyLong_AsLong(ret) != 0) {
+		Py_DECREF(ret);
+		goto stop;
 	}
 
+	Py_DECREF(ret);
 	return 0;
+
+ stop:
+	ctx->status = false;
+	return 1;
 }
 
 static bool notrace_this_pid(struct tracefs_instance *instance)
-- 
2.32.0

