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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95842C432BE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75B116103D
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbhHaMzH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHaMzG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:55:06 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD54C061575
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:11 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a25so38434455ejv.6
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h/VSd1nH2U2Cl4ryJMRlfcYTXhgdbJH9ossr08otlLk=;
        b=hqWPQ4Z1hAZQW9YMWk0Y29SWv+EGE92Ndsk3Ssbwm8Nja7p4HMBZ0wPdEmEq1+rV/F
         ykMECIuLMLPETNKvd9LNV7PRB+5+bLwwyM4AJENsacVMZhHpeY30n15zYShijYkkqwDX
         Yh9hHOYmqnm1QjjZbhikE1dbyZsM6l0oiSv12UqKyT6CI+5JKZfuk5VugiY7VAP70tZG
         Dv+lZg2YSX+3hj7mRkYVeqk0jwFputSG1z/smw4DHUAylrR6xf1dKPuSHm515wdcoq87
         6O0WTgdNUP9GbM/XQMBKEuXzd9Ayc2oDFtuTM/uAXcex08++VKz3qhj+JBCQphKg5n83
         5+DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h/VSd1nH2U2Cl4ryJMRlfcYTXhgdbJH9ossr08otlLk=;
        b=T5ohtJHFZTuxyhaRkRE9/RTWUO5Z1GW18r/x4lITv2PAR7+LILdPafV2v11Azdv93E
         jnTsJFgS1eC1kxlheEz+2K6zFnhJ3MVAVufwswBuU6Ry9eNMybhgydPjS/pZbQ/5fOXJ
         oqym9vFCYevs+0UFFXzxYhGVriUl2ccvGb/Vetb8CKZkZ/6MMbn8i2t1+zKW3foXQJaE
         Fx0UMh/jHbAfxjLW3TlN2uBb7YTcddarvmWtNFMmNL9U2owQJYOKvZcPdt837ENJyihc
         SRLAv1vIjeVSEXQyQzUtJWCx8zWQo906DVoDpAKU75RKhvRBeRC//J6zRfGXwUONd5We
         Yn1Q==
X-Gm-Message-State: AOAM532lefzKFLbR7jvPCmy+OlN1UG+TQt0bs6y0vsn6At0m03nO5cVs
        VkyeWDOz20zqm0OhjGQsTCefx0ib/uc=
X-Google-Smtp-Source: ABdhPJycEZXEYJBUE7qz5/oH6TzxX/cujxN71BIscUqahkz+NVAxAjjDDTgOk6xA2rhwCxL8zqdAkg==
X-Received: by 2002:a17:906:2441:: with SMTP id a1mr31231728ejb.550.1630414449655;
        Tue, 31 Aug 2021 05:54:09 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id be5sm9346976edb.57.2021.08.31.05.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:54:09 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/4] trace-cruncher: Add optional sort to tfs_list2py_list()
Date:   Tue, 31 Aug 2021 15:53:54 +0300
Message-Id: <20210831125357.56862-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This helper function is used to convert the NULL-terminated array
of strings returned by the APIs of libtracefs into a Python list
of strings. Here we add an option the returned string to be sorted
in alphabetical order.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 53fc95f..0fcadd8 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -475,7 +475,7 @@ static bool write_to_file_and_check(struct tracefs_instance *instance,
 	return ret == 0 ? true : false;
 }
 
-static PyObject *tfs_list2py_list(char **list)
+static PyObject *tfs_list2py_list(char **list, bool sort)
 {
 	PyObject *py_list = PyList_New(0);
 	int i;
@@ -483,6 +483,9 @@ static PyObject *tfs_list2py_list(char **list)
 	for (i = 0; list && list[i]; i++)
 		PyList_Append(py_list, PyUnicode_FromString(list[i]));
 
+	if (sort)
+		PyList_Sort(py_list);
+
 	tracefs_list_free(list);
 
 	return py_list;
@@ -636,7 +639,7 @@ PyObject *PyFtrace_available_tracers(PyObject *self, PyObject *args,
 	if (!list)
 		return NULL;
 
-	return tfs_list2py_list(list);
+	return tfs_list2py_list(list, false);
 }
 
 PyObject *PyFtrace_set_current_tracer(PyObject *self, PyObject *args,
@@ -724,7 +727,7 @@ PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
 	if (!list)
 		return NULL;
 
-	return tfs_list2py_list(list);
+	return tfs_list2py_list(list, false);
 }
 
 PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
@@ -750,10 +753,11 @@ PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
 
 	list = tracefs_system_events(tracefs_instance_get_dir(instance),
 				     system);
+
 	if (!list)
 		return NULL;
 
-	return tfs_list2py_list(list);
+	return tfs_list2py_list(list, false);
 }
 
 bool get_event_enable_file(struct tracefs_instance *instance,
-- 
2.30.2

