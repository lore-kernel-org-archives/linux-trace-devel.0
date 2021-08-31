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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE6EC4320A
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A886360FC0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 31 Aug 2021 12:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhHaMzH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 31 Aug 2021 08:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhHaMzH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 31 Aug 2021 08:55:07 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0C7C061575
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:12 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id x11so38589861ejv.0
        for <linux-trace-devel@vger.kernel.org>; Tue, 31 Aug 2021 05:54:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0wkIf+NaX+AdnH7XiJUXOr4HCirVQw2nQxwwFX+IM7c=;
        b=rtkTEC7bGm5D4iYU3zqiGptIb2G8Uvd7/TJXc2QJtCDUcJCLLZNG+tMhU6LmPT1sWu
         MYY+pEtASBJs0u5KC7GeAE4y9W+G8eEBFhFLSmKIrSQOJq6x/ltTqELgh5y4eujwkHAR
         DGZSJHBapODgrxFyh/q/ksw7SuJn5c5Cj7thanD6Nu1DDP5Pm+ilP78DyhQEidU+Vbb9
         wTlsMTzdyjdYs64Ue9Lr3o9Lx3fS2Uf8NDgcI+qhT8MoHVxCxFI2Z43wnjoY+S1Tl7BF
         aTYRrMF/U3IEiEn7oE3ELa85bdyCs63A2t5gPul+6bV49vdGD1jvzL4yY6tloln34BAf
         l9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0wkIf+NaX+AdnH7XiJUXOr4HCirVQw2nQxwwFX+IM7c=;
        b=XKbIPtSkz4hkptyEVyBnUXbAo/2xyFTPJgSb8DsuQKa8OtIGPLSl3HRJfmHzBzGUgZ
         K3UsEZ14bDhgYKS9LgXFfqfzvgowECIIHE6wibmHFzo7xqVOKe14EOiqMtoffggYvLz5
         0q+qVMbIL6GZJavFMAPNWB1mmwzXhxzTki07gpfyR+zd5nutmie+XAU2UXX9HoETEtUe
         rpbi4HexfdkaNPG5iD5eywdKRd5Pp6MClBCzcDq4E6NEBip1y+6tEpWKX9jA8qFnbiNY
         n++9wwho3+dyIYm1e9rLBrddUqC+tMeMbklNwCgax52LUlLfx/NezaRWzBVE1tBTghGf
         eRlw==
X-Gm-Message-State: AOAM531l2dbINXmRZV+BmOr1kfKjd6FKvMPGTuupD/6DAuweoHJq1RHT
        12Y8sPlniPboJlvlb7E4C4/A4ebJXmo=
X-Google-Smtp-Source: ABdhPJxJQTGC0w1kVatibhuieRLMYYNCaSBvfOfuxWwSi+FZLi8yVX0HTQXGrY33h7aXB8zkRDKPMQ==
X-Received: by 2002:a17:907:7844:: with SMTP id lb4mr19275799ejc.381.1630414450534;
        Tue, 31 Aug 2021 05:54:10 -0700 (PDT)
Received: from crow.. ([95.87.199.93])
        by smtp.gmail.com with ESMTPSA id be5sm9346976edb.57.2021.08.31.05.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 05:54:10 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/4] trace-cruncher: Add optional sort to available_system_events()
Date:   Tue, 31 Aug 2021 15:53:55 +0300
Message-Id: <20210831125357.56862-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210831125357.56862-1-y.karadz@gmail.com>
References: <20210831125357.56862-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

An optional parameter 'sort' is added. If set to True, the returned
list of event names is sorted in alphabetical order. The default
value of 'sort' is False.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 0fcadd8..f884106 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -733,18 +733,20 @@ PyObject *PyFtrace_available_event_systems(PyObject *self, PyObject *args,
 PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
 							   PyObject *kwargs)
 {
-	static char *kwlist[] = {"system", "instance", NULL};
+	static char *kwlist[] = {"system", "instance", "sort", NULL};
 	struct tracefs_instance *instance;
 	PyObject *py_inst = NULL;
 	const char *system;
+	int sort = false;
 	char **list;
 
 	if (!PyArg_ParseTupleAndKeywords(args,
 					 kwargs,
-					 "s|O",
+					 "s|Op",
 					 kwlist,
 					 &system,
-					 &py_inst)) {
+					 &py_inst,
+					 &sort)) {
 		return NULL;
 	}
 
@@ -757,7 +759,7 @@ PyObject *PyFtrace_available_system_events(PyObject *self, PyObject *args,
 	if (!list)
 		return NULL;
 
-	return tfs_list2py_list(list, false);
+	return tfs_list2py_list(list, sort);
 }
 
 bool get_event_enable_file(struct tracefs_instance *instance,
-- 
2.30.2

