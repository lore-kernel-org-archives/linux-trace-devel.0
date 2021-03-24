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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B89C433E3
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25608619E5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhCXNEd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhCXNE0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:26 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF44C061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:26 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k128so10462525wmk.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WDq4JxpNtg/mIRxKEMjeZkSbCUogjXW4ab8x4Wk8n5Q=;
        b=HqlE7zQJA+kWp+ILpbIMGQ1xFJYhZmheDV34zy9FNuxF+t1R37uEKH0F4ZKXh6TGGM
         TZNv7K85k/f01rcvEv7FUdK4a1rMQ1p/9r9xH1gmg5P1+y59R38BoQlfnmRAdtYqorbr
         Ku5l5f8nRU6sn0SKkVZEvQShh+P7SIc4oK1cLZjP34Jf/AsEuIy1H8xAYeoxjmogmete
         OMsWuYItVFIAmGWEBX9WvsuO9HOrqLzsk4kdYylrjRX2l/Bt0ApZRqmfmwiDYQYxhLFK
         nhIsaMd4lB5eJrfDKdxujE/7SH0rs2p2cHVPuXjBJxHYT/HWR3IZaHFAFb3dBYOyjmhg
         3M5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WDq4JxpNtg/mIRxKEMjeZkSbCUogjXW4ab8x4Wk8n5Q=;
        b=UTUfNqAFdRqxN1EC04dcnoJVGYKnp8D3LS00Fj3m/ZFdKwDH2DoSwrYw/z5XLr+7Iq
         bPvAzkbTX1LdHEU9N5dq8sVjVi9WC/i9aDjLWvpCdD/QlZXwv+HeJurxgf2m8vpoi5Ci
         QUfhEamcSEM2ExhJP+BfhNXV3xC0Bfbts/sr/tS4GoWt8qKSmQoMgBcZwv2EhOvxIzrR
         omDoCN6/78pK8X3vM8WGfMHH9aC0/Cnk7bbFcccmTY5Bt10vaP50I+w2gYkWcp9m3eVP
         FK93lsCQVtBoXFDJfvnUquSvXgnWI+RIKX1nAgHw0MJXAOCy1wBbzR2RiMYXDbuMK7kh
         AldA==
X-Gm-Message-State: AOAM533y2hE/C/W+Fdn/f0bggaAiqLrPDWV8Gk/1zF92mcRfp/9txVTe
        K2EmANFpTn4vyDMLhY67hhPz8WLEjPAtCg==
X-Google-Smtp-Source: ABdhPJzBRGy0qXDGY0ANpfm98k4ZVAT7btIQ+Pz73CThsNxVswUUEssfGEPObl/BW3/E4GtM5ycHkA==
X-Received: by 2002:a1c:400b:: with SMTP id n11mr2792264wma.167.1616591064696;
        Wed, 24 Mar 2021 06:04:24 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 04/23] trace-cmd: Internal refactoring, move logic for local tep handler in its own function
Date:   Wed, 24 Mar 2021 15:03:59 +0200
Message-Id: <20210324130418.436206-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Moved the logic for initializing a tep handler for ftrace events from
get_date_to_ts() to its own local funciotn, get_ftrace_tep(). That way
the code can be reused in the scope of trace-record.c file.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-record.c | 53 +++++++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index a0eb0385..635897e1 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -4459,52 +4459,59 @@ static char *read_top_file(char *file, int *psize)
 	return tracefs_instance_file_read(top_instance.tracefs, file, psize);
 }
 
+static struct tep_handle *get_ftrace_tep(void)
+{
+	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
+	char *buf;
+	int size;
+	int ret;
+
+	tep = tracefs_local_events_system(NULL, systems);
+	if (!tep)
+		return NULL;
+	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
+	buf = read_top_file("events/header_page", &size);
+	if (!buf)
+		goto error;
+	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
+	free(buf);
+	if (ret < 0)
+		goto error;
+
+	return tep;
+
+error:
+	tep_free(tep);
+	return NULL;
+}
+
 /*
  * Try to write the date into the ftrace buffer and then
  * read it back, mapping the timestamp to the date.
  */
 static char *get_date_to_ts(void)
 {
-	const char *systems[] = {"ftrace", NULL};
+	struct tep_handle *tep;
 	unsigned long long min = -1ULL;
 	unsigned long long diff;
 	unsigned long long stamp;
 	unsigned long long min_stamp;
 	unsigned long long min_ts;
 	unsigned long long ts;
-	struct tep_handle *tep;
 	struct timespec start;
 	struct timespec end;
 	char *date2ts = NULL;
-	char *path;
-	char *buf;
-	int size;
 	int tfd;
-	int ret;
 	int i;
 
 	/* Set up a tep to read the raw format */
-	tep = tracefs_local_events_system(NULL, systems);
+	tep = get_ftrace_tep();
 	if (!tep) {
 		warning("failed to alloc tep, --date ignored");
 		return NULL;
 	}
-
-	tep_set_file_bigendian(tep, tracecmd_host_bigendian());
-
-	buf = read_top_file("events/header_page", &size);
-	if (!buf)
-		goto out_pevent;
-	ret = tep_parse_header_page(tep, buf, size, sizeof(unsigned long));
-	free(buf);
-	if (ret < 0) {
-		warning("Can't parse header page, --date ignored");
-		goto out_pevent;
-	}
-
-	path = tracefs_get_tracing_file("trace_marker");
-	tfd = open(path, O_WRONLY);
-	tracefs_put_tracing_file(path);
+	tfd = tracefs_instance_file_open(NULL, "trace_marker", O_WRONLY);
 	if (tfd < 0) {
 		warning("Can not open 'trace_marker', --date ignored");
 		goto out_pevent;
-- 
2.30.2

