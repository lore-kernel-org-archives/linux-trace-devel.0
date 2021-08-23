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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B761FC4320A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 982C961368
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Aug 2021 12:54:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235738AbhHWMyo (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Aug 2021 08:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235842AbhHWMyn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Aug 2021 08:54:43 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499E5C061575
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:01 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so253055wmd.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 23 Aug 2021 05:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v5Ih0Qj2bIlVyaxT/bP+O9o75/OXqCHo7ClGoPbWYf8=;
        b=k2HPWo2XnuIRDUgf34HuaJ8PqadA5ddsIRRCM82pqvWGx7cF0MQ5DW1DoD1DFnbvTC
         apbBGMWnq6aeCP3Xb9NCnfjg0S3XsODZR8PE8C/cV6t0GKGYzfB6tegGDy74cDC/6QXY
         S+PlMR0XdKGY4j6Ty2ibktTeil+mGLBiVZDm1juxLela/qWs4+8D+lwBg6X/nGOrmq0/
         BTvtJKvU1SnGk+sTnP9cSXMAqGFFlkBdK5Gp/vUwalWPd8qPE2mLxvqcfmhj6B1/LEnq
         g1SKVX+NBxeXc0e3hSomL1iNF5Axawts8z5Pyf6st5wrvNlLg1ER2wzMk8yeUkLhwuEa
         BrAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v5Ih0Qj2bIlVyaxT/bP+O9o75/OXqCHo7ClGoPbWYf8=;
        b=M/UtqV86Ga3pQAeJbbwxW18hTQEFL1HxbAtKFZm/xYedh3pmVlsu6extmFjUjVakoM
         SZ6vggH8xMs6bd6KYEvXVkO4VwhGtkuOnPRQK8n+ONEk5d3wGE1/qzlm2fkVZ1yINA7f
         Lu7KZzC38htU4ff9TcTU2X5SJjlt+isrBix3sjC+DvbT7tRZ1CjDMgLdmZK5qiwsCFHT
         zg3YSSXSSBw7XcOBWKMOvn0qmo4RPNegjP1VN1+E1HrYmJv96r3Iu4MYEYjn7cjACBcO
         9O/4d2WXZJq3g/rWQa0p/XfnlBnjJxA5ia6b2LsXnIgDP8YIC9fRbtPzfZMpOwZ6sO/h
         FZaQ==
X-Gm-Message-State: AOAM530jgOwwAjIOSfajjkP+qwWO66Atq0/gOpYHu6vvF7pMLQZctR08
        Aht21h/Nih1eBjOCPDCyPAODVoDGbTM=
X-Google-Smtp-Source: ABdhPJyeZiTlwBj2Opd3yOEsawB/Xvd2RV2bbzEm730EXd3BCTO4jfuKDJm7oNDGaLtyiBK6A0r/Tw==
X-Received: by 2002:a1c:443:: with SMTP id 64mr10024462wme.180.1629723239743;
        Mon, 23 Aug 2021 05:53:59 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id b10sm11469454wrt.43.2021.08.23.05.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 05:53:59 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] trace-cruncher: Have standard 'not existing' message
Date:   Mon, 23 Aug 2021 15:53:47 +0300
Message-Id: <20210823125348.145615-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210823125348.145615-1-y.karadz@gmail.com>
References: <20210823125348.145615-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The string "(nil)" is used to state that an object
do not exists / is empty.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/common.h         | 2 ++
 src/ftracepy-utils.c | 6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/src/common.h b/src/common.h
index b7f6a87..476e4f1 100644
--- a/src/common.h
+++ b/src/common.h
@@ -24,6 +24,8 @@
 
 static const char *NO_ARG = "/NONE/";
 
+#define TC_NIL_MSG	"(nil)"
+
 static inline bool is_all(const char *arg)
 {
 	const char all[] = "all";
diff --git a/src/ftracepy-utils.c b/src/ftracepy-utils.c
index a3ae03a..4561a4d 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -68,7 +68,7 @@ PyObject *PyTepRecord_cpu(PyTepRecord* self)
 
 PyObject *PyTepEvent_name(PyTepEvent* self)
 {
-	const char * name = self->ptrObj ? self->ptrObj->name : "nil";
+	const char *name = self->ptrObj ? self->ptrObj->name : TC_NIL_MSG;
 	return PyUnicode_FromString(name);
 }
 
@@ -169,7 +169,7 @@ PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
 	}
 
 	if (!field_size)
-		return PyUnicode_FromString("(nil)");
+		return PyUnicode_FromString(TC_NIL_MSG);
 
 	if (field->flags & TEP_FIELD_IS_STRING) {
 		char *val_str = record->ptrObj->data + field_offset;
@@ -2098,7 +2098,7 @@ PyObject *PyFtrace_error_log(PyObject *self, PyObject *args,
 		ret = PyUnicode_FromString(err_log);
 		free(err_log);
 	} else if (ok) {
-		ret = PyUnicode_FromString("(nil)");
+		ret = PyUnicode_FromString(TC_NIL_MSG);
 	}
 
 	return ret;
-- 
2.30.2

