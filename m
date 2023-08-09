Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4894C04A94
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Aug 2023 17:53:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjHIRxu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 13:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHIRxt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:49 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD3E10F6
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Aug 2023 10:53:48 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id af79cd13be357-76754b9eac0so11014785a.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Aug 2023 10:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691603627; x=1692208427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irLZzpaAbuT5pEiREaaBz+Xmu3lslzxYJH7JhZcbFus=;
        b=kn5uJmZh4zGnh7EDdB/aSpH9cBbLTTeTuewk8J7TnP8kxxGkPUYxEaTRhBxAUTgjRA
         vpdbZLIdreL8Fge5YTgpOo5G3E5Wrx0vAYFgTruBC+FKSvCTlBSVTamAYnwlhkQF7MEY
         c7nWm7mf5hT5bMJMUBYA7bwJgoiMGTzqzUS4e7wXiVu1JmPCMxsnikEtL4/sZ29jtGGR
         sSZcJ4999f6Thk4iMdbyyLlqjW90RsgJ0M1lwuEQefWntNfusyBilGU3CwoWccR5Nrq5
         oHWK4OGquFH2Uh4yCzqEMGwJyAkBcDXGbLmbzmqX3GxUdysCqtRJ3wlw6IY0mwUDenq7
         WafQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603627; x=1692208427;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irLZzpaAbuT5pEiREaaBz+Xmu3lslzxYJH7JhZcbFus=;
        b=feX+SHw2XcIPPMvuUqHvZmCZtHCzPO4H8MEZZpEguGSqVO4hGLIPTKKcWIQzNRtZve
         9RI7q5Ru/Xom7IYMGWXnZfKHbVd7NMRl/4xa9OLe5rrYqgb8wWIa5X8VBCR+3hshh9vE
         hFczagZhmRgBj2rryoyLlethxsf8lJqKsXvfJ/TBygep23HwWZTaGP3NzeC7K/6ZJcKT
         pFfuxNKwn0klmMYKMOwHsxFRdwlOQfMHCjG+O6mzVzE94Q6V8eqS25Pc39QYMXK2qpzE
         VGMsWa/tL5IvADClRICSFFEt0Jxfpp0+nOJCaAYWD305NVMLM0/vxpz81HUlvQWwqajS
         bgrA==
X-Gm-Message-State: AOJu0YzYgk2yR+kcouPU8qzfcgeMvJNz1+Cz0l2wx4ZpMl1LlQFRWGtk
        IVujsTivajKCPLoNRpyzHfLYtV+wqDg=
X-Google-Smtp-Source: AGHT+IFz6lDnuS0NU583v7sxOiiG9GuEsJc4wTPKvBdxmW6zdFCHuWqAILqEgh/jAwarze1btvKUUQ==
X-Received: by 2002:ad4:4f47:0:b0:63d:2907:46 with SMTP id eu7-20020ad44f47000000b0063d29070046mr2775798qvb.26.1691603627438;
        Wed, 09 Aug 2023 10:53:47 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::2409])
        by smtp.gmail.com with ESMTPSA id x4-20020a0c8e84000000b00623839cba8csm4633646qvb.44.2023.08.09.10.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:46 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v4 1/5] histograms: Initial histograms interface
Date:   Wed,  9 Aug 2023 13:53:34 -0400
Message-ID: <20230809175340.3066-2-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809175340.3066-1-stevie.6strings@gmail.com>
References: <20230809175340.3066-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Stevie Alvarez (Google) <stevie.6strings@gmail.com>

Initial header file for libtraceeval's histogram API. The interface
provides a simple way of aggregating trace data and reading through said
data.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-hist.h | 130 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 130 insertions(+)
 create mode 100644 include/traceeval-hist.h

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
new file mode 100644
index 0000000..3565756
--- /dev/null
+++ b/include/traceeval-hist.h
@@ -0,0 +1,130 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * libtraceeval histogram interface.
+ *
+ * Copyright (C) 2023 Google Inc, Steven Rostedt <rostedt@goodmis.org>
+ * Copyright (C) 2023 Google Inc, Stevie Alvarez <stevie.6strings@gmail.com>
+ */
+#ifndef __LIBTRACEEVAL_HIST_H__
+#define __LIBTRACEEVAL_HIST_H__
+
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdbool.h>
+
+/* Data definition interfaces */
+
+/* Field name/descriptor for number of hits */
+#define TRACEEVAL_VAL_HITS ((const char *)(-1UL))
+
+/* Data type distinguishers */
+enum traceeval_data_type {
+	TRACEEVAL_TYPE_NONE,
+	TRACEEVAL_TYPE_NUMBER_8,
+	TRACEEVAL_TYPE_NUMBER_16,
+	TRACEEVAL_TYPE_NUMBER_32,
+	TRACEEVAL_TYPE_NUMBER_64,
+	TRACEEVAL_TYPE_NUMBER,
+	TRACEEVAL_TYPE_STRING,
+	TRACEEVAL_TYPE_DYNAMIC
+};
+
+/* Statistics specification flags */
+enum traceeval_flags {
+	TRACEEVAL_FL_SIGNED		= (1 << 0),
+	TRACEEVAL_FL_TIMESTAMP		= (1 << 1),
+};
+
+/*
+ * struct traceeval_dynamic - Storage for dynamic traceeval_types
+ * @size: The size of the dynamic type
+ * @data: The pointer to the data of the dynamic type
+ */
+struct traceeval_dynamic {
+	void		*data;
+	size_t		size;
+};
+
+/*
+ * Trace data entry for a traceeval histogram
+ * Constitutes keys and values.
+ */
+union traceeval_data {
+	struct traceeval_dynamic	dyn_data;
+	char				*string;
+	unsigned long			number;
+	unsigned long long		number_64;
+	unsigned int			number_32;
+	unsigned short			number_16;
+	unsigned char			number_8;
+};
+
+struct traceeval_type;
+
+/* struct traceeval_dynamic release function signature */
+typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
+					 struct traceeval_dynamic);
+
+/* struct traceeval_dynamic compare function signature */
+typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
+				    struct traceeval_dynamic,
+				    struct traceeval_type *);
+
+/*
+ * struct traceeval_type - Describes the type of a traceevent_data instance
+ * @type: The enum type that describes the traceeval_data
+ * @name: The string name of the traceeval_data
+ * @flags: flags to describe the traceeval_data
+ * @id: User specified identifier
+ * @dyn_release: For dynamic types called on release (ignored for other types)
+ * @dyn_cmp: A way to compare dynamic types (ignored for other types)
+ *
+ * The traceeval_type structure defines expectations for a corresponding
+ * traceeval_data instance for a traceeval histogram instance. Used to
+ * describe both keys and values.
+ *
+ * The @id field is an optional value in case the user has multiple struct
+ * traceeval_type instances with @type fields set to TRACEEVAL_TYPE_DYNAMIC,
+ * which each relate to distinct user defined struct traceeval_dynamic
+ * 'sub-types'.
+ *
+ * For flexibility, @dyn_cmp() and @dyn_release() take a struct
+ * traceeval_type instance. This allows the user to distinguish between
+ * different sub-types of struct traceeval_dynamic within a single
+ * callback function by examining the @id field. This is not a required
+ * approach, merely one that is accommodated.
+ *
+ * @dyn_cmp() is used to compare two struct traceeval_dynamic instances when a
+ * corresponding struct traceeval_type is reached with its type field set to
+ * TRACEEVAL_TYPE_DYNAMIC. It should return 0 on equality, 1 if the first
+ * argument is greater than the second, -1 for the other way around, and -2 on
+ * error.
+ *
+ * dyn_release() is used during traceeval_release() to release a union
+ * traceeval_data's struct traceeval_dynamic field when the corresponding
+ * traceeval_type type is set to TRACEEVAL_TYPE_DYNAMIC.
+ */
+struct traceeval_type {
+	char				*name;
+	enum traceeval_data_type	type;
+	size_t				flags;
+	size_t				id;
+	traceeval_dyn_release_fn	dyn_release;
+	traceeval_dyn_cmp_fn		dyn_cmp;
+};
+
+/* Statistics about a given entry element */
+struct traceeval_stat {
+	unsigned long long	max;
+	unsigned long long	min;
+	unsigned long long	total;
+	unsigned long long	avg;
+	unsigned long long	std;
+};
+
+/* Iterator over aggregated data */
+struct traceeval_iterator;
+
+struct traceeval;
+
+#endif /* __LIBTRACEEVAL_HIST_H__ */
-- 
2.41.0

