Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8D2C433ED
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE7E761480
	for <linux-trace-devel@archiver.kernel.org>; Tue, 11 May 2021 13:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhEKNiP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 11 May 2021 09:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhEKNhm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 11 May 2021 09:37:42 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF2AC06175F
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:36:31 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id b25so29761894eju.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 11 May 2021 06:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h84T0ZQlnzwcgPs8lYoKMlSLkjUitpzJEXDURgYVJQc=;
        b=ClNiHG0JjboKnDKOb7TJXl9vPJbyzwBZoPySSrL1LKwWzsY5aAjhG1OJtdr/CQ12hI
         cmhLrxLD/lmkVOfKj+FOo9bxv+MDkU8Z3jCGlDH0IeWc5D39IBuzyn5JgwVojT4kM3Lm
         kl/zSG0lMyuK98HZtSB86bZoBFoP99qDm8on2bKgfQAdgG+WChotPjhbDLGBZsPWXfxL
         DeNXVNrz9Y5LlsyQezQI6O3+z2+q9Odcrf9ymiBrbIRQJej80ODJ7P/Vdt8tUYY5hruf
         iyboyp/fFOYwinRcRmGAxAq2RejxZdVxwMK1Jbx0g9rKlYSuuHzR3my2kUn/QVa8QWNe
         UzbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h84T0ZQlnzwcgPs8lYoKMlSLkjUitpzJEXDURgYVJQc=;
        b=FeFw+qBuzCoTI5tbIw0xnPZM+xUyu4lo0i+//SY4Y1KHa2FmX2oX5IBN2e9G5Bcxph
         vXBvXCP4u1eoY7e2L3X6SbjeFOHwoWj6LBolbx4GJeIwX+huKm1esYamKALgLLyfpULj
         0xbt319g0sCsT/JYve/xSAwzoQeiWMZsPHVdxq4SUxzf6Qp4k6WkQsBXpAxau8D9YYNo
         8B1Vqy9Uci298oETqoOkZNcb7yaHnawKogeFqQ5gUo3CkvLF7KLI3QZYN6i6poLabHSO
         tzVVRmt9m/dvvPqmmBiJkQYfEzY3Ls8Nshh/a0R469Qyb8HOQoD1MjuE4TRhMp2tMaVN
         4v+Q==
X-Gm-Message-State: AOAM53323iFwgURWvA7sGPNm4qp6FrIU53WldXD5J+F2j7FUuoHtI2Wb
        6ZqNiDJ03Y8HtXhvIQNd4VKc4SINwU8=
X-Google-Smtp-Source: ABdhPJx5WMQA+68nx8dxxjySY+eCmwT8rQgQ3papj4aTaxZ5/F6Z07YYlIXWArmId7NpnNmaoxOdxA==
X-Received: by 2002:a17:906:1ed1:: with SMTP id m17mr32383499ejj.208.1620740190472;
        Tue, 11 May 2021 06:36:30 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.176])
        by smtp.gmail.com with ESMTPSA id y8sm2431160edo.90.2021.05.11.06.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:36:30 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] kernel-shark: Fix bug in filter clearing
Date:   Tue, 11 May 2021 16:36:19 +0300
Message-Id: <20210511133619.287496-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Applying a filter to the loaded tracing data requires looping over
the entire data-set of entries. On large data-set this can be very
expensive operation. To coop with this, a number of checks are putted
in place to making sure that a loop is not performed in a case when
it is not really needed. However, there is a mistake in the logic of
these checks. So far we considered that calling filter_entries() with
no filter being set does not require looping over the data. But this
is not correct because if a filter had been applied already, calling
the function with an empty filter is equivalent of clearing the
existing filter, hence  it is a legitimate operation and indeed we
need to loop over the data.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206131
Reported-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark.c | 20 ++++++++++++++++++--
 src/libkshark.h |  5 +++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/src/libkshark.c b/src/libkshark.c
index dc58dcf..1222a81 100644
--- a/src/libkshark.c
+++ b/src/libkshark.c
@@ -166,6 +166,7 @@ static struct kshark_data_stream *kshark_stream_alloc()
 		    goto fail;
 	}
 
+	stream->filter_is_applied = false;
 	kshark_set_data_format(stream->data_format, KS_INVALID_DATA);
 	stream->name = strdup(KS_UNNAMED);
 
@@ -1271,8 +1272,11 @@ static void filter_entries(struct kshark_context *kshark_ctx, int sd,
 			return;
 		}
 
-		if (!kshark_filter_is_set(kshark_ctx, sd))
+		if (!kshark_filter_is_set(kshark_ctx, sd) &&
+		    !stream->filter_is_applied) {
+			/* Nothing to be done. */
 			return;
+		}
 	}
 
 	/* Apply only the Id filters. */
@@ -1294,6 +1298,9 @@ static void filter_entries(struct kshark_context *kshark_ctx, int sd,
 
 		/* Apply Id filtering. */
 		kshark_apply_filters(kshark_ctx, stream, data[i]);
+
+		stream->filter_is_applied =
+			kshark_filter_is_set(kshark_ctx, sd)? true : false;
 	}
 }
 
@@ -1356,10 +1363,19 @@ void kshark_clear_all_filters(struct kshark_context *kshark_ctx,
 			      struct kshark_entry **data,
 			      size_t n_entries)
 {
-	int i;
+	struct kshark_data_stream *stream;
+	int *stream_ids, i;
 
 	for (i = 0; i < n_entries; ++i)
 		set_all_visible(&data[i]->visible);
+
+	stream_ids = kshark_all_streams(kshark_ctx);
+	for (i = 0; i < kshark_ctx->n_streams; i++) {
+		stream = kshark_get_data_stream(kshark_ctx, stream_ids[i]);
+		stream->filter_is_applied = false;
+	}
+
+	free(stream_ids);
 }
 
 /**
diff --git a/src/libkshark.h b/src/libkshark.h
index ee3a1d3..23e3b49 100644
--- a/src/libkshark.h
+++ b/src/libkshark.h
@@ -324,6 +324,11 @@ struct kshark_data_stream {
 	/** Hash of CPUs to not display. */
 	struct kshark_hash_id	*hide_cpu_filter;
 
+	/**
+	 * Flag showing if some entries are filtered out (marked as invisible).
+	 */
+	bool			filter_is_applied;
+
 	/** The type of the data. */
 	char			data_format[KS_DATA_FORMAT_SIZE];
 
-- 
2.27.0

