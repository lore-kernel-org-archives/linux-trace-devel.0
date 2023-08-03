Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B95C41513
	for <linux-trace-devel@archiver.kernel.org>; Thu,  3 Aug 2023 22:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjHCWye (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 3 Aug 2023 18:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjHCWyc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 3 Aug 2023 18:54:32 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D729E67
        for <linux-trace-devel@vger.kernel.org>; Thu,  3 Aug 2023 15:54:31 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-26837895fbbso954043a91.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 03 Aug 2023 15:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691103270; x=1691708070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HKp36H1UulTymdurc1G1f3NMo+jgEHMsoEA+WiaWkMA=;
        b=TnSA8dZO4vSmr7CiAk0BpkaPNrkUwEDCzJSk6tzgiPH5fRVXkVR52tdx8dMm7p/5yt
         CeWsS1nInz4WmXYZd/iS35qovh5w1GgIzBiYImyZXxp/4XV/+hBJyVhq8Qt2opm+18M7
         i1g9Lci5hyLOWr5I1a3ctT9V4uxTnWeo4p7DTD3GINbIHrwJy+JN5TgUyeKp7Kg42JtU
         rXAZSxOyMk+uKUSigWAWDMamOGvkhIAJyB8tKaSuswVf+p4ObyVOYHNY1nS6wiCHKHpZ
         bn6JgVdBsJ1utGConWTSTC7q7lCrhuJYVp+zTb3es8omMY6VkZRvoYX9rnwEVh5xKSwg
         jMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691103270; x=1691708070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKp36H1UulTymdurc1G1f3NMo+jgEHMsoEA+WiaWkMA=;
        b=cN2QzoBZIfb6n1IQYX71OdC/i7bRDd7r5MCHWbiEzqWqnnX2/T8WM23f5rYtVtTS/W
         Cj4GZ8Wp9hIGv17/zcKYObbcBD3T5FnJxu6k5s4c5X02d3d6JyjZ4DLtjtC2xK1wUSU2
         Vv/SNFVg0R88g/0RhJMyhMshw0uhkL4x7Vio5/vUdG9MehK7zcCB9cOnowaErGcp98q5
         rmi8WX1vgpEImCZ/8jnOOQ4A8Vs90BD6U2yVb7sbgAoFn2r+4bz9xzlKcS6z8TWYmOwI
         onaD3UbkgLtx06iQHKymWC1M5OLmMgM+BYk7UFVCwEJ48yqSFqZu9gWihKxI6gFKU4T3
         Hn6Q==
X-Gm-Message-State: AOJu0YxVp4JTqfBayNhw2wrPLA0GMqjBnwSnKiLGvG1pcj7Ul2AeipzG
        rJAfPqIDe0IwzwX3T0+BaI+0NcvLT7At/Q==
X-Google-Smtp-Source: AGHT+IEERnmub5R7FNBuFFsuACy78+VffNnLmZM8MwoX5WBpE2gkEuPRWxDDylidG88Jor1p1u1T+Q==
X-Received: by 2002:a17:90b:4f48:b0:268:b64b:f684 with SMTP id pj8-20020a17090b4f4800b00268b64bf684mr73652pjb.33.1691103270642;
        Thu, 03 Aug 2023 15:54:30 -0700 (PDT)
Received: from 3xKetch.lan ([2601:600:a17f:b422::ffc])
        by smtp.gmail.com with ESMTPSA id o14-20020a17090a4b4e00b00268b439a0cbsm351120pjl.23.2023.08.03.15.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Aug 2023 15:54:30 -0700 (PDT)
From:   Stevie Alvarez <stevie.6strings@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ross Zwisler <zwisler@google.com>
Subject: [PATCH v2 1/5] histograms: Initial histograms interface
Date:   Thu,  3 Aug 2023 18:53:59 -0400
Message-ID: <20230803225413.40697-2-stevie.6strings@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230803225413.40697-1-stevie.6strings@gmail.com>
References: <20230803225413.40697-1-stevie.6strings@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: "Stevie Alvarez (Google)" <stevie.6strings@gmail.com>

Initial header file for libtraceeval's histogram API. The interface
provides a simple way of aggregating trace data and reading through said
data.

Signed-off-by: Stevie Alvarez (Google) <stevie.6strings@gmail.com>
---
 include/traceeval-hist.h | 128 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)
 create mode 100644 include/traceeval-hist.h

diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
new file mode 100644
index 0000000..4664974
--- /dev/null
+++ b/include/traceeval-hist.h
@@ -0,0 +1,128 @@
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
+	TRACEEVAL_TYPE_STRING,
+	TRACEEVAL_TYPE_NUMBER,
+	TRACEEVAL_TYPE_NUMBER_64,
+	TRACEEVAL_TYPE_NUMBER_32,
+	TRACEEVAL_TYPE_NUMBER_16,
+	TRACEEVAL_TYPE_NUMBER_8,
+	TRACEEVAL_TYPE_DYNAMIC
+};
+
+/* Statistics specification flags */
+enum traceeval_flags {
+	TRACEEVAL_FL_SIGNED		= (1 << 0),
+	TRACEEVAL_FL_TIMESTAMP		= (1 << 1),
+	TRACEEVAL_FL_STATS		= (1 << 2)
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
+/* struct traceeval_dynamic release function signature */
+typedef void (*traceeval_dyn_release_fn)(struct traceeval_dynamic *,
+		struct traceeval_type *);
+
+/* struct traceeval_dynamic compare function signature */
+typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic *,
+		struct traceeval_dynamic *, struct traceeval_type *);
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
+	traceeval_dyn_release_fn	dyn_release;
+	traceeval_dyn_cmp_fn		dyn_cmp;
+	enum traceeval_data_type	type;
+	size_t				flags;
+	size_t				id;
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

