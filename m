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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DACAC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A6361164
	for <linux-trace-devel@archiver.kernel.org>; Fri, 17 Sep 2021 15:23:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhIQPYi (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 17 Sep 2021 11:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344243AbhIQPYY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 17 Sep 2021 11:24:24 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9F7C0613A9
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:21:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v22so27064720edd.11
        for <linux-trace-devel@vger.kernel.org>; Fri, 17 Sep 2021 08:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5iDb27AA1mUrq+X7sEclo0+MUulcbuU4r4C9WPy7Zjg=;
        b=Hs9d/CEe01xCa679copWzHX+54II53Io1MIIYQlVsDdQ5kQXFSHLRZFWjag65l2bOD
         2jGm87lZaEK6lUfVAKj1Z06EWjmicpkyPjing0r0erlIKyFKDBu3Frd4DKNbEGwa/oWI
         33Xa4O0w1HhmmnhdUAHr28kS9PYYiSIbo20P5BkcuKaWyYgYgJEIE4krp1P4KtPa3OER
         Y4rtIuX3G2xEnOaovw260wBSTBF0dZhT67fom32fkw1m5yAcEBnYLlDpm0tYU/icwtGd
         EPPkhljh/gU+DNvOYfaH7hUeGpX2Ipmj92Vk8naRe03ZcmBL5S5cEzs325wnyZrBrglt
         ib5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5iDb27AA1mUrq+X7sEclo0+MUulcbuU4r4C9WPy7Zjg=;
        b=GiVeBlP95nrX/6QutPm9iEj9fk6Oq+UjAUCpRzfeeRyDjfDLSv1dmXkn4NEwdgDu7q
         LnwMlR9LgLKA+6dMqyzJE4NklLTWciq9Xkw8qldWPDC1lmSu8O9BA+eTyl0HvGNQeDw9
         JoUKM/1w+VjsynLGXZpC1Cq7rBQhsrmgBrpbYtXFtxlIEy16BdV4ODjRKEbvu0w/2l7R
         borM7AhQUvUsyLJeoIDD8KLlae63tjTGb4ZUKUfR16Y2BXzzYgxc6Q4F9UhGOmbW9xhq
         s5cSpZQZ8MzTtbuF1gvLD8cmXGmG2LsxT5r10gIayqKdAlC3V1LZsflam+gBCUbYL5Y1
         VhzA==
X-Gm-Message-State: AOAM5310n4aw//jL9Nfi7cl9N6gO5tuB8eCq0iSITuY1h4VSJ4t53zxv
        OV3WdC+wxFc4S9iKUl0yuoxYaDaIV6s=
X-Google-Smtp-Source: ABdhPJzRtVIKgvaTjXpL8EOrgnejJmAq82s+GOUl2TSH4Ws92SmG8Bl+nHXl1aXbUx5+on65L4eSDg==
X-Received: by 2002:a17:906:369a:: with SMTP id a26mr12648052ejc.539.1631892110821;
        Fri, 17 Sep 2021 08:21:50 -0700 (PDT)
Received: from crow.. ([95.87.199.246])
        by smtp.gmail.com with ESMTPSA id p19sm2407464ejo.81.2021.09.17.08.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 08:21:50 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/2] trace-cruncher: More options for stopping data iteration
Date:   Fri, 17 Sep 2021 18:21:39 +0300
Message-Id: <20210917152139.574350-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917152139.574350-1-y.karadz@gmail.com>
References: <20210917152139.574350-1-y.karadz@gmail.com>
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
index 7b1ff1b..814e1d6 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -2101,21 +2101,36 @@ static int callback(struct tep_event *event, struct tep_record *record,
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
2.30.2

