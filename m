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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92A98C433ED
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6883B610FC
	for <linux-trace-devel@archiver.kernel.org>; Fri,  2 Apr 2021 13:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDBNUH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 09:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhDBNUG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 09:20:06 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE2FC0613E6
        for <linux-trace-devel@vger.kernel.org>; Fri,  2 Apr 2021 06:20:05 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id h13so407217eji.6
        for <linux-trace-devel@vger.kernel.org>; Fri, 02 Apr 2021 06:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G1ZquU7vO/goaoK6gzyVFkmCg37oKGKH+OeSpNiV27w=;
        b=jogMwCb2uqcau+/IRDjY6CRrQZbNWy1vpbQiyRO9XcZ2GUM1JyaPOkXwhGHOVzZwri
         wfqqslz6x35rb3xFe2iW4jBWWWYhZh5uQfqiYU7OSs8LDenXXAswDxeWkowPp3SIwAv8
         krERKTFXcSB8tNWo5ppyKxB22p1N16Jv9qWuN7Ruym4nwqbe/EywAD/9iOdcgG12lK2n
         DtLMAgFMXzxcItQXHIw9DsZ/0JTY3KSsLIDx/mBPjX9qNbtUtbT86h+NV0mzup1odiHt
         iFQN1ThCzEzU1hRnIvO6kKW+BKWtiUtAu4fVrdUYEisJ6zF7kgkrI5D+LCU92W4zW+J0
         bstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G1ZquU7vO/goaoK6gzyVFkmCg37oKGKH+OeSpNiV27w=;
        b=N1TCoDJHIG6S0TcuJnfiDb6AUgg/1ty6+D1komKpVHHojWREczGu/VC1j2I3gY6zSh
         j5cxAOcUpbZ07TLqhjvaSuI5jOFLipbM4TYcAePp/xDFT34FBRWWzo4v0dvL6MUckpSk
         UbrBygd0j+FGBxPxTOhqHSpqDdg9aJkWXFVowzuMvGq9WOt0D9lM0w33K/Qa636AgYAc
         n+7Ed6e4ESoocMBWCoEsQ7Jb/yDfyFW9rx3xgzbleD2qSgypU28Up+82wTNP41PF3NLj
         RFNJxq8Jfd1JiFuseFjKTuWnp5XJIPS8Fek1eKlEZ9l0dgTM692sw9Ehkr2tnYNWJxQy
         ZWOw==
X-Gm-Message-State: AOAM5326rAUoVa9kwv1koYBaQadSk4VnJeQSs4bLtHGk/eUwty7eV1Te
        zwZvTJd5UkjRri9KXo+pMWk=
X-Google-Smtp-Source: ABdhPJyQTZjCDzauxRIWTxtXsRh9q94p3yFBidR+906mtl2Y6U7Q0hLClW4s79BCS8jwfUPyzCc/uQ==
X-Received: by 2002:a17:906:7a50:: with SMTP id i16mr832282ejo.29.1617369604067;
        Fri, 02 Apr 2021 06:20:04 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id n3sm4120476ejj.113.2021.04.02.06.20.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 06:20:03 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 3/6] libtracefs: Encapsulate "struct tracefs_options_mask"
Date:   Fri,  2 Apr 2021 16:19:44 +0300
Message-Id: <20210402131947.346235-4-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210402131947.346235-1-y.karadz@gmail.com>
References: <20210402131947.346235-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The definition of the mask gets hidden from the user. This way we will
be able to modify this definition in the future, without breaking the
API. Such a modification will be compulsory, if too many new tracing
options are added in the future. Note that encapsulating the mask
definition, requires two API methods to be eliminated, however those
methods have no particular use-cases for the moment.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 include/tracefs.h   |  6 +-----
 src/tracefs-tools.c | 33 +++++++++++----------------------
 2 files changed, 12 insertions(+), 27 deletions(-)

diff --git a/include/tracefs.h b/include/tracefs.h
index 5c4e50d..0665e8d 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -131,11 +131,7 @@ enum tracefs_option_id {
 };
 #define TRACEFS_OPTION_MAX (TRACEFS_OPTION_VERBOSE + 1)
 
-struct tracefs_options_mask {
-	unsigned long long	mask;
-};
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id);
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id);
+struct tracefs_options_mask;
 bool tracefs_option_is_set(struct tracefs_options_mask *options,
 			   enum tracefs_option_id id);
 struct tracefs_options_mask *tracefs_options_get_supported(struct tracefs_instance *instance);
diff --git a/src/tracefs-tools.c b/src/tracefs-tools.c
index 3b5f773..11a4c8c 100644
--- a/src/tracefs-tools.c
+++ b/src/tracefs-tools.c
@@ -19,6 +19,10 @@
 
 #define TRACE_CTRL	"tracing_on"
 
+struct tracefs_options_mask {
+	unsigned long long	mask;
+};
+
 static const char * const options_map[] = {
 	"unknown",
 	"annotate",
@@ -197,6 +201,13 @@ enum tracefs_option_id tracefs_option_id(const char *name)
 	return TRACEFS_OPTION_INVALID;
 }
 
+static void tracefs_option_set(struct tracefs_options_mask *options,
+			       enum tracefs_option_id id)
+{
+	if (options && id > TRACEFS_OPTION_INVALID)
+		options->mask |= (1ULL << (id - 1));
+}
+
 static struct tracefs_options_mask *trace_get_options(struct tracefs_instance *instance,
 						      bool enabled)
 {
@@ -366,25 +377,3 @@ bool tracefs_option_is_set(struct tracefs_options_mask *options,
 		return options->mask & (1ULL << (id - 1));
 	return false;
 }
-
-/**
- * tracefs_option_set - Set option in options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_set(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask |= (1ULL << (id - 1));
-}
-
-/**
- * tracefs_option_clear - Clear option from options bitmask
- * @options: Pointer to a bitmask with options
- * @id: trace option id
- */
-void tracefs_option_clear(struct tracefs_options_mask *options, enum tracefs_option_id id)
-{
-	if (options && id > TRACEFS_OPTION_INVALID)
-		options->mask &= ~(1ULL << (id - 1));
-}
-- 
2.27.0

