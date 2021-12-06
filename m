Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F636C433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Dec 2021 15:15:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357979AbhLFPTV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Dec 2021 10:19:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358302AbhLFPQc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Dec 2021 10:16:32 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44211C08EACC
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Dec 2021 07:09:11 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o19-20020a1c7513000000b0033a93202467so81072wmc.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Dec 2021 07:09:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zDNZxYq7FFFHG8G4lQ77zoaB6S5yLEI1xl/wPMiLygA=;
        b=E3hWzwC+SR7Ik+xMUO+ObwddNzyCaRes3juJSvYD1HkVzO6uNJFTgPNux3s2nDlH2p
         wcuZpbXmvYn9Uxf/k6UmAjFsz27bmjOGqz3SxafwYH+DnlRtSRbpMwTU80qsramBcGnt
         zSOcUVUNxsNzRAFhaHjZ3OBNPHjwnRpES8i1GurBh4xlzHekF5WtLTckC9ZrRZmzZpt6
         bg9pwrXDvLhdrU/F+HgsIcmnvkOJYsp4C4yb2xFygnZZw6nIM6wsuLRoSXMulLZnz8HQ
         +1plpDGnRFYj15HAZhl71Vcn34qXVMFFE1xkVrKo9h9kTpLIuItWgBZfsHwKZZs8lfu2
         rNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zDNZxYq7FFFHG8G4lQ77zoaB6S5yLEI1xl/wPMiLygA=;
        b=J5hAp9ov5r+vwg6/ETKebW4yjV7yKDtmzvjcsHUgQRRwupRMcmMLvKtHsnEFHJrV52
         FHKGIwGJR4WU4sLgXtGnw3gAxLKbQ/0WHkmItN4UOW5YrA5RaszuOIBjPPiKrCUkLVZK
         HISjFyUZemhu527ADxO1sFUe2F66XtbsUnDgww1nNSBnURHfqbGZQVQRq/HdofZ17pME
         NP9YFh0GBUYUlX1urM6Bb5h6CCK8O4N8pmQ+f5e99IvEM8sCuaN0TXpWCJ4RqxL99UrB
         HUEeO3GkWVVOptWQjiGS+l3UgfWDt8lxW6w73lCo1yCldScLtQ6vCJHXAT41v6PxYe5w
         IzOQ==
X-Gm-Message-State: AOAM530wcbAx16ZjMg/3I0jNWs4y02zSZUZr5O6aq0lA9524dGdoWLQd
        q2RwJULWKX7SjlT5VuFglZ99uoNTUyM=
X-Google-Smtp-Source: ABdhPJybR3X9qnYzsOj5D8cU9xuW9c9wrw+6+1BPDS74n/xRVT/D7g73n3k/1F/3yRPYcADPjgBUqw==
X-Received: by 2002:a05:600c:22cb:: with SMTP id 11mr39367343wmg.181.1638803349634;
        Mon, 06 Dec 2021 07:09:09 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d6sm11782668wrn.53.2021.12.06.07.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 07:09:09 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, rostedt@goodmis.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 2/3] libtracefs: Rename the 'tracefs_get_hist_*()' APIs
Date:   Mon,  6 Dec 2021 17:08:54 +0200
Message-Id: <20211206150855.361202-3-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211206150855.361202-1-y.karadz@gmail.com>
References: <20211206150855.361202-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The APIs are renamed in order to match the naming convention used in
the library. The patch adds documentation add well.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 Documentation/libtracefs-hist.txt | 15 ++++++++++++++-
 include/tracefs.h                 |  6 +++---
 src/tracefs-hist.c                | 24 +++++++++++++++++++++---
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/Documentation/libtracefs-hist.txt b/Documentation/libtracefs-hist.txt
index c8230e5..e3145c9 100644
--- a/Documentation/libtracefs-hist.txt
+++ b/Documentation/libtracefs-hist.txt
@@ -5,7 +5,8 @@ NAME
 ----
 tracefs_hist_alloc, tracefs_hist_free, tracefs_hist_add_key, tracefs_hist_add_value, tracefs_hist_add_name, tracefs_hist_start,
 tracefs_hist_destory, tracefs_hist_add_sort_key, tracefs_hist_set_sort_key, tracefs_hist_sort_key_direction
-tracefs_hist_echo_cmd, tracefs_hist_echo_fmt - Create and update event histograms
+tracefs_hist_echo_cmd, tracefs_hist_echo_fmt, tracefs_hist_get_name, tracefs_hist_get_event,
+tracefs_hist_get_system - Create, update and describe event histograms
 
 SYNOPSIS
 --------
@@ -73,6 +74,12 @@ int tracefs_hist_command(struct tracefs_instance pass:[*]instance,
 int tracefs_hist_echo_fmt(struct trace_seq pass:[*]s, struct tracefs_instance pass:[*]instance,
 			  struct tracefs_hist pass:[*]hist);
 
+tracefs_hist_get_name(struct tracefs_hist pass:[*]hist);
+
+tracefs_hist_get_event(struct tracefs_hist pass:[*]hist);
+
+tracefs_hist_get_system(struct tracefs_hist pass:[*]hist);
+
 --
 
 DESCRIPTION
@@ -190,6 +197,12 @@ that would be done by *tracefs_hist_command*(3).
 *tracefs_hist_echo_fmt*() prints the raw format that describes the state of the
 histogram in the given _instance_, or NULL for the top level, into the _seq_.
 
+*tracefs_hist_get_name*() prints the name of the histogram.
+
+*tracefs_hist_get_event*() prints the event name of the histogram.
+
+*tracefs_hist_get_system*() prints the system name of the histogram.
+
 *tracefs_hist_command*() is called to process a command on the histogram
 _hist_ for its event in the given _instance_, or NULL for the top level.
 The _cmd_ can be one of:
diff --git a/include/tracefs.h b/include/tracefs.h
index c2a6db7..7c03086 100644
--- a/include/tracefs.h
+++ b/include/tracefs.h
@@ -354,9 +354,9 @@ struct tracefs_hist *
 tracefs_hist_alloc_nd(struct tep_handle *tep,
 		      const char *system, const char *event_name,
 		      struct tracefs_hist_axis *axes);
-const char *tracefs_get_hist_name(struct tracefs_hist *hist);
-const char *tracefs_get_hist_event(struct tracefs_hist *hist);
-const char *tracefs_get_hist_system(struct tracefs_hist *hist);
+const char *tracefs_hist_get_name(struct tracefs_hist *hist);
+const char *tracefs_hist_get_event(struct tracefs_hist *hist);
+const char *tracefs_hist_get_system(struct tracefs_hist *hist);
 int tracefs_hist_add_key(struct tracefs_hist *hist, const char *key,
 			 enum tracefs_hist_key_type type);
 int tracefs_hist_add_value(struct tracefs_hist *hist, const char *value);
diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 9beafe0..837d4e1 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -41,17 +41,35 @@ struct tracefs_hist {
 	unsigned int		filter_state;
 };
 
-const char *tracefs_get_hist_name(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_name - get the name of the histogram
+ * @hist: The histogram to get the name for
+ *
+ * Returns name string on succes or NULL on error.
+ */
+const char *tracefs_hist_get_name(struct tracefs_hist *hist)
 {
 	return hist ? hist->name : NULL;
 }
 
-const char *tracefs_get_hist_event(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_event - get the event name of the histogram
+ * @hist: The histogram to get the event name for
+ *
+ * Returns event name string on succes or NULL on error.
+ */
+const char *tracefs_hist_get_event(struct tracefs_hist *hist)
 {
 	return hist ? hist->event_name : NULL;
 }
 
-const char *tracefs_get_hist_system(struct tracefs_hist *hist)
+/*
+ * tracefs_hist_get_system - get the system name of the histogram
+ * @hist: The histogram to get the system name for
+ *
+ * Returns system name string on succes or NULL on error.
+ */
+const char *tracefs_hist_get_system(struct tracefs_hist *hist)
 {
 	return hist ? hist->system : NULL;
 }
-- 
2.32.0

