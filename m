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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31549C433E6
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD1A23130
	for <linux-trace-devel@archiver.kernel.org>; Wed,  6 Jan 2021 16:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbhAFQMQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 6 Jan 2021 11:12:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbhAFQMQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 6 Jan 2021 11:12:16 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210F0C061357
        for <linux-trace-devel@vger.kernel.org>; Wed,  6 Jan 2021 08:11:36 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id g20so5825921ejb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 06 Jan 2021 08:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y+k8neNdzORKAr1XPD79IEi+kxR+kKWu+FozF4tcoT8=;
        b=NJ0gT6pJu33+F15iQqucjeMIu5QMf5GgWnzPn0k+lZJnd3136mpdji6id0Eqt8BI07
         uLAlzCU0ayTDcxI9qs2dOc5YGVAewnw7snXBp2TE4kpgVl3vCNNZXt4RNK4bqvvYWilp
         xLDNAtjESrZ9XxWQghOTgXuSg7dQt1RTZkJbJ+vtGp+oHn6nnmEJ9yd56TpCgwL4JR+w
         hLqUIaUIpZtFeOP+/jt5wNYZoXxlZj8mgPa0mJ3LoC0PO09ZN1gkty/6Fgk6y76+vP4D
         v5fiwJNm6ig92fpwb0/g2rMql8LAe/GJdHUvNY3jq/VzK+HzowH6m//SVZ3yhOFGN45y
         UeGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y+k8neNdzORKAr1XPD79IEi+kxR+kKWu+FozF4tcoT8=;
        b=FP81fMMQsdwue2/7gSSWxPOY2m8UgilEcczqyE373yKgrlcTqc4V/Wc2X5tywRpDUv
         efugIzX5G6mN8LXjZRibcQtFnV3rYPIcAatTZBDkZ0wirpAH96czHj1vKqxavlavRgfZ
         zvhK3tV4/cyc/gzjrCEM/aMUeX+PEjr9enDjrKeDansO6cdN8iI5k7HoTjd1yxG7gEe8
         Hh527xl/mBbl+ZFFwaH81seqrwa0hScpEHeM+eh8ztIG7GN/e9/+MfgbwONN/lcVX/U9
         Jx49PKLkxotzmFhyK7vOM4bpjpGNUva16dIS00YXPT8G/rv9JyScgQSV86k4Pt4KXUmz
         mdXQ==
X-Gm-Message-State: AOAM530Rodbc/U7bSGlC0B1MTE6e2olqvBDchSypbp0XFdQu0VqytLZ/
        E5R/tA/oq5Khfn9rD4HAE0k=
X-Google-Smtp-Source: ABdhPJybKUrrQ8l9bnJdNg74y64HJSA/P6z331hjTutovAgmLl+PcseCqMhR65kvX92TNmoulLmiUw==
X-Received: by 2002:a17:906:5043:: with SMTP id e3mr3380251ejk.260.1609949494867;
        Wed, 06 Jan 2021 08:11:34 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id q25sm1570041eds.85.2021.01.06.08.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:11:34 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 1/6] kernel-shark: Add KS_DOUBLE_SIZE macro
Date:   Wed,  6 Jan 2021 18:11:15 +0200
Message-Id: <20210106161120.119085-2-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210106161120.119085-1-y.karadz@gmail.com>
References: <20210106161120.119085-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The macro is useful for resizing of dynamic arrays. It is currently
used to resize the Data stream descriptor array, owned by the session
context. We will later use the macro with the arrays of data fields and
plugin contexts.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.h | 14 ++++++++++++++
 src/libkshark.c        | 15 +++++++--------
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/src/libkshark-plugin.h b/src/libkshark-plugin.h
index 1a642ad..f3c724f 100644
--- a/src/libkshark-plugin.h
+++ b/src/libkshark-plugin.h
@@ -346,6 +346,20 @@ int kshark_handle_dpi(struct kshark_data_stream *stream,
 int kshark_handle_all_dpis(struct kshark_data_stream *stream,
 			   enum kshark_plugin_actions  task_id);
 
+/** General purpose macro for resizing dynamic arrays. */
+#define KS_DOUBLE_SIZE(type, array, size, ok)				\
+{									\
+	ssize_t n = *size;						\
+	*ok = false;							\
+	type *tmp = (type *) realloc(array, 2 * n * sizeof(*tmp));	\
+	if (tmp) {							\
+		memset(tmp + n, 0, n * sizeof(*tmp));			\
+		*size = 2 * n;						\
+		array = tmp;						\
+		*ok = true;						\
+	}								\
+}									\
+
 #ifdef __cplusplus
 }
 #endif // __cplusplus
diff --git a/src/libkshark.c b/src/libkshark.c
index 315c24f..3aa3fa2 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -234,16 +234,15 @@ int kshark_add_stream(struct kshark_context *kshark_ctx)
 
 	if (kshark_ctx->stream_info.next_free_stream_id ==
 	    kshark_ctx->stream_info.array_size) {
-		size_t new_size = 2 * kshark_ctx->stream_info.array_size;
-		struct kshark_data_stream **streams_tmp;
+		bool ok;
 
-		streams_tmp = realloc(kshark_ctx->stream,
-				      new_size * sizeof(*kshark_ctx->stream));
-		if (!streams_tmp)
-			return -ENOMEM;
+		KS_DOUBLE_SIZE(struct kshark_data_stream *,
+			       kshark_ctx->stream,
+			       &kshark_ctx->stream_info.array_size,
+			       &ok);
 
-		kshark_ctx->stream = streams_tmp;
-		kshark_ctx->stream_info.array_size = new_size;
+		if (!ok)
+			return -ENOMEM;
 	}
 
 	stream = kshark_stream_alloc();
-- 
2.25.1

