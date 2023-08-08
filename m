Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A867C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue,  8 Aug 2023 17:30:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234373AbjHHRaU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 13:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbjHHR3s (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 13:29:48 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35F58C0B6
        for <linux-trace-devel@vger.kernel.org>; Tue,  8 Aug 2023 09:12:51 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-76cded293e8so417619285a.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 08 Aug 2023 09:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691511137; x=1692115937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MJtHRpmyyqtO1Vr5KRaxABt/gc7Fvw6L4GcikuzHNYQ=;
        b=j1df50t958XeYrupiXbXbXgPNOskkk4/8rJnhMAdCFx8BulGC/p+9qxLDGxYCtoStF
         9jVeRgYNwgny1zemJDMzmfOYx6H/stDEvBpWgSx1d6YJSRFGMbrVjanQ2RT9EOmtrTOZ
         twLu9b1GUZDJ9B56XZoa3wBBglBUQujtxpa4AXym8FZLGAGkzKnwx898XOpd/d2x1jcl
         RgoyGhC5Wccd5jL1RwYEF22FUBYh5HV7IyqztEFiF+71nfaCBi4QNEzJqMiNXLMmvQ/m
         hMs72ssC+ofIySaVtX8/Vse6XvU0/ZkHC6a2he6Yt/CReSQlnEjRmfk4BQy+2IE8qt4a
         FzGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691511137; x=1692115937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJtHRpmyyqtO1Vr5KRaxABt/gc7Fvw6L4GcikuzHNYQ=;
        b=OqgAZBJjV2glH1BHpNBHen3p5oQdt5bgiSx5TuV36Hayg5iP3QguJsy50h6HjolJOs
         SdcEiJmmHh8nu3gSZiPfylK1O9HWDsr0q9xqlxly6tLbnOr1XvGkyVPEnNksVQFX94k4
         ZGwfW/vRrP2rteoaQvmZc2AX2D11kCrLV8UKjuU35csAIybVlwh29nPcHJnR7TzTC/+U
         QVQGumcY6qCj3cbtVLJa7CVN3CvpNhH7EdHcBoFM+WxrPRVXXISsqhWWcCCMi2EpYDF2
         YXKzcFlQmVAqruXFJReW1OpfMHGa005hJOJdnQpcsPAF9zVlLHrcYhgInTVHo0WNqYAw
         Uopg==
X-Gm-Message-State: AOJu0Yzfh8jsWhiEkuFZKp4qdBXqmrhKLqA8c+9zl7BzKu/nAKfU5Y9c
        q6jnkqyHz75Gg2LrkinqpukLXfCywVQ=
X-Google-Smtp-Source: AGHT+IHkcVp9asXBFhgC2kSzAs3QJveajvVPxBvbCuFPc9GPq+3G+kI77nhTHypZivuIHQyJLSQr/g==
X-Received: by 2002:a05:620a:2951:b0:765:a651:a11d with SMTP id n17-20020a05620a295100b00765a651a11dmr207435qkp.36.1691511136805;
        Tue, 08 Aug 2023 09:12:16 -0700 (PDT)
Received: from 3xKetch.hsd1.ma.comcast.net ([2601:180:8300:500::6aa8])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a030700b0076c97ae43b9sm3381540qkm.66.2023.08.08.09.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 09:12:16 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Stevie Alvarez <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v3 1/6] histograms: Initial histograms interface
Date:   Tue,  8 Aug 2023 12:11:54 -0400
Message-ID: <20230808161204.5704-2-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230808161204.5704-1-stevie.6strings@gmail.com>
References: <20230808161204.5704-1-stevie.6strings@gmail.com>
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
index 0000000..ebce94e
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
+	TRACEEVAL_TYPE_NUMBER_64,
+	TRACEEVAL_TYPE_NUMBER_32,
+	TRACEEVAL_TYPE_NUMBER_16,
+	TRACEEVAL_TYPE_NUMBER_8,
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
+ * Trace data entry for a traceeval histogram
+ * Constitutes keys and values.
+ */
+union traceeval_data {
+	char				*string;
+	struct traceeval_dynamic	*dyn_data;
+	unsigned long long		number_64;
+	unsigned long			number;
+	unsigned int			number_32;
+	unsigned short			number_16;
+	unsigned char			number_8;
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
+struct traceeval_type;
+
+/* struct traceeval_dynamic release function signature */
+typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
+					 struct traceeval_dynamic *);
+
+/* struct traceeval_dynamic compare function signature */
+typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic *,
+				    struct traceeval_dynamic *,
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

