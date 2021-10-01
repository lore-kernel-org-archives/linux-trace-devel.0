Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02A4C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A49461A57
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJANYx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbhJANYw (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:24:52 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7437EC061775
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:23:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id r18so34650083edv.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldnhqF/ZuZRsH9AzDvGqSt+Byj1WP5UHUu7KAEfhsOA=;
        b=aUBLthF2QdRmuBiZj0lA9UK5OY2oRk0BNlMDw6dqKjHHgDQbgJOWJqoERZUKdPfJCo
         4CKvxrQwUqwzFGIDDL5KFwpnc0VYSV1VKTaR9kWt29yjxHH4zqbQYUgwIIFuMBOupKyV
         aq0jnJQX6wgw7zMkx7NaYA7LO6AoC3A+EBe+4fg1URQN+thk12qx8UxpVzBX4W6n2m9W
         C49W8uqaLvigL8Km8h8NeA+Pb5XoNLVm3D+KXdfIRf+D1vnJXz70ZZik2yI38hLc3uaW
         yRb/jiRrJTkQvsnklHcXteMZdFcprPR7zAmFz94pNgLezeUY3gJ+ehBG57NKgDNOPwP9
         mavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldnhqF/ZuZRsH9AzDvGqSt+Byj1WP5UHUu7KAEfhsOA=;
        b=JMNUEzh3IdDikjC6qGO0Scx6yQ9n2RT/3U3sWfJJUHOTMkq+37baKFubIx9JABGt0u
         a7Ur1bHycnyJRrwkmNnQJcVPHxeHgqX0JwbCIMPejokrYzTPwwEDEG7ldNFkNjAI4s6+
         GEY7rg3WQ5EbNXkRoqYiHcMV/Vp3I+7mwSxyRlENXGSrBb1+bjPAVCkaWDu4xzeSMpj/
         5e5F1f0c7P4pxH3WqJDjVWtgy7ysbWwD++0KTT9LnBFrNeq2GzFVzESjYTqeVAQkoxwv
         rlHCBCr6KO1DHjQ7eoWsOwErj4vX0BTIfdgLP6aoseqIyi6dtGSBBSc+i3HHy3io24LY
         l2dA==
X-Gm-Message-State: AOAM531gCH0j3sZ4V79lH/cepksucNLNgEHBWwh6YJEApuWWmZdIsvjk
        F7TjsE1TPB+i37WyKkRKG27i8thUe3I=
X-Google-Smtp-Source: ABdhPJyynjm40i0Lgi9Z09dDNda8UOLbYtQZd10ffyE4VDO/Kj9TqA/pNMZAgZORU4751YqzQbCrYg==
X-Received: by 2002:a17:906:314e:: with SMTP id e14mr6174773eje.165.1633094586868;
        Fri, 01 Oct 2021 06:23:06 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id lb20sm2977785ejc.40.2021.10.01.06.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:23:06 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH] trace-cruncher: Always use get_instance_from_arg()
Date:   Fri,  1 Oct 2021 16:22:53 +0300
Message-Id: <20211001132253.7851-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Avoid the code duplication in the case when the Python method takes
only a single 'instance' argument.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/ftracepy-utils.c | 36 +++---------------------------------
 1 file changed, 3 insertions(+), 33 deletions(-)

diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index 7b1ff1b..ca7f914 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -1889,19 +1889,9 @@ PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
 						PyObject *kwargs)
 {
 	struct tracefs_instance *instance;
-	PyObject *py_inst = NULL;
 	char path[PATH_MAX];
 
-	static char *kwlist[] = {"instance", NULL};
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "|O",
-					 kwlist,
-					 &py_inst)) {
-		return NULL;
-	}
-
-	if (!get_optional_instance(py_inst, &instance))
+	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
 	sprintf(path, "events/%s/%s/filter", TC_SYS, self->ptrObj->event);
@@ -1916,19 +1906,9 @@ PyObject *PyKprobe_clear_filter(PyKprobe *self, PyObject *args,
 static bool enable_kprobe(PyKprobe *self, PyObject *args, PyObject *kwargs,
 			  bool enable)
 {
-	static char *kwlist[] = {"instance", NULL};
 	struct tracefs_instance *instance;
-	PyObject *py_inst = NULL;
-
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "|O",
-					 kwlist,
-					 &py_inst)) {
-		return false;
-	}
 
-	if (!get_optional_instance(py_inst, &instance))
+	if (!get_instance_from_arg(args, kwargs, &instance))
 		return false;
 
 	return event_enable_disable(instance, TC_SYS, self->ptrObj->event,
@@ -1956,19 +1936,9 @@ PyObject *PyKprobe_disable(PyKprobe *self, PyObject *args,
 PyObject *PyKprobe_is_enabled(PyKprobe *self, PyObject *args,
 					      PyObject *kwargs)
 {
-	static char *kwlist[] = {"instance", NULL};
 	struct tracefs_instance *instance;
-	PyObject *py_inst = NULL;
-
-	if (!PyArg_ParseTupleAndKeywords(args,
-					 kwargs,
-					 "|O",
-					 kwlist,
-					 &py_inst)) {
-		return NULL;
-	}
 
-	if (!get_optional_instance(py_inst, &instance))
+	if (!get_instance_from_arg(args, kwargs, &instance))
 		return NULL;
 
 	return event_is_enabled(instance, TC_SYS, self->ptrObj->event);
-- 
2.30.2

