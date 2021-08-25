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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 381F0C432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 208246112D
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Aug 2021 09:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbhHYJYc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Aug 2021 05:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbhHYJY1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Aug 2021 05:24:27 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79D8C0617A8
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:40 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q14so1207190wrp.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Aug 2021 02:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b8jSTj05xMs44fgv9I3UUy63KAb4PWH8V34+5f0uljE=;
        b=cj4iMHY49ujuij8aFG5id79GfOH9Ad4C6d91+2ifaEpisp9Yq8nM21ys3IptUHllVW
         4OJBT+tPI/QW7GNkoviJNFljDhKCVa8n7+2byVcbw0OCEYxASEe8LjU4jbC4dlYDOx74
         5O//H8Q00ktJCUzpr6y7Iq329uyjprZCUjGKxOLQAdzo7l6+a5P3DCnex0hom1zqc7/h
         dLsfJHL9f2KljK+mGhIfmBn/dj5kA88aJakUlnuDHD5i3HLvpMzWgolBpG5bibf3i4P9
         plwinPgUBhbe52Ok060t0Zb1IA2IBGwF+RTLosAMccYcAeUPrbg2NgLyLSPiSjcVOXlH
         kZrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b8jSTj05xMs44fgv9I3UUy63KAb4PWH8V34+5f0uljE=;
        b=aDBwwRLYZM4Iu+W2HCC3jj13FYZ8956aB+I1kFk9LfRwXCIokKNAOn26iKeziUKgvg
         2FqvwcuCZYzGWuVifmraH5fczcg0KszIuZXnOuVX6a7KhtY4rNJw+OwxmgfzyZRhq6L0
         avWzh/5ki2aEb6buY+IE32ydLXYVMQiD0tuJ4e4YUfGCZxuWY67yVjHdyr/Xr69VsT8C
         u+p/F53eYYbeEuud5QrYdkb0KClu152NhYfrkn5caMEclGlvCZB8OOIm9dgJgN42dKac
         W09IT6TdFqdGsES6Ed0hHe8eSgpHEO62hY/RoVq35hkDIGjnL1ftxBWZpCFdT6fFqIYW
         KAeA==
X-Gm-Message-State: AOAM530QUcFg7YU41UJkEhRKNXfAchBpPr+IFxC0NPMkpNsuVVnNGZbN
        3igEtNOFxDuRGfXGC/MKB5v53wfB7o8=
X-Google-Smtp-Source: ABdhPJzKpbDTThLZCtXA/67KckZx4pAo5WqDjTAvgLH/al2OfsTsYwh73Gjt/3uvK3Jgxj3neAfgbw==
X-Received: by 2002:a5d:58ce:: with SMTP id o14mr23418237wrf.319.1629883419293;
        Wed, 25 Aug 2021 02:23:39 -0700 (PDT)
Received: from crow.. ([95.87.199.109])
        by smtp.gmail.com with ESMTPSA id w9sm4599323wmc.19.2021.08.25.02.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 02:23:38 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 2/3] trace-cruncher: Have standard 'not existing' message
Date:   Wed, 25 Aug 2021 12:23:25 +0300
Message-Id: <20210825092326.45804-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210825092326.45804-1-y.karadz@gmail.com>
References: <20210825092326.45804-1-y.karadz@gmail.com>
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
index da58855..88b069c 100644
--- a/src/ftracepy-utils.c
+++ b/src/ftracepy-utils.c
@@ -69,7 +69,7 @@ PyObject *PyTepRecord_cpu(PyTepRecord* self)
 
 PyObject *PyTepEvent_name(PyTepEvent* self)
 {
-	const char * name = self->ptrObj ? self->ptrObj->name : "nil";
+	const char *name = self->ptrObj ? self->ptrObj->name : TC_NIL_MSG;
 	return PyUnicode_FromString(name);
 }
 
@@ -170,7 +170,7 @@ PyObject *PyTepEvent_parse_record_field(PyTepEvent* self, PyObject *args,
 	}
 
 	if (!field_size)
-		return PyUnicode_FromString("(nil)");
+		return PyUnicode_FromString(TC_NIL_MSG);
 
 	if (field->flags & TEP_FIELD_IS_STRING) {
 		char *val_str = record->ptrObj->data + field_offset;
@@ -2099,7 +2099,7 @@ PyObject *PyFtrace_error_log(PyObject *self, PyObject *args,
 		ret = PyUnicode_FromString(err_log);
 		free(err_log);
 	} else if (ok) {
-		ret = PyUnicode_FromString("(nil)");
+		ret = PyUnicode_FromString(TC_NIL_MSG);
 	}
 
 	return ret;
-- 
2.30.2

