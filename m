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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0632CC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3E3B61A0C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Mar 2021 13:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbhCXNFG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Mar 2021 09:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234065AbhCXNEf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Mar 2021 09:04:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F1AC061763
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id z2so24393242wrl.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Mar 2021 06:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4UIs+hZLDi5iAqomvDA/upvdNqsH5erDUfGFvSxCEPs=;
        b=p1hrHgRLxskV4iQ+rUXcxbS1MN73sbmsf91mTitXHGGZUPIcinQX6JoyyxxivwYN2o
         b4v52rPdDNOPJNLztBWzblkkw+vebf0NDZkwKl9k/VsUR9MqRRfe/vLBxyFOmbQt6yRm
         0DLI5HXgWyBDtROgwc5C4SOh7+tGEvxq2LZ4hDUUOFbnh3bBKgHkCrLmbtlh400+/XCh
         +fY9C3WYbZ9JW8YxLDjwbT+Oz/cB7F4q8MWBCsviFTTgQY5DUPbx/WBKG/D8kYhbwg4q
         eRFc6fWAPb+ls0ZLPP1JAKS13fK1uS3AglZsPqE226SHyG0K104Nm4H6cEtQzbFjFA02
         Ad2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4UIs+hZLDi5iAqomvDA/upvdNqsH5erDUfGFvSxCEPs=;
        b=pIwu1gROMvdzkv+WIm4SgnxLQQeMGKjDqzcKki+Jk8WJUA6Iz+3pRDSVi35mkAfu8e
         IV/4CJOxpoyw2m7uarRaWcrv9TPJx7ztmPzmFz4/AITxuqH2Wu96Y7B0PaE781E3qXyh
         9ts9gse5YbyklUiXmILlNaJvVzCtDUOUzHA2j/JSKX7ZntS7ycmKEeKlBUN5zYfxJTuv
         cT9joSAeuANxwIMvT+b5J+APTH0pOw7/mqNnt0fGXfnpKY2cK2vC89etgbM9AzySRAMh
         3hj/DMoRnBpCAfH28ZJqZEK4aoDsvLstXvBS7vJ7nu3kkrS7m25g4m96QU1uzuBAWIu0
         5nKg==
X-Gm-Message-State: AOAM531SqBzkP3FL3VSzeiRG33B/bjuhCBpJ2WVMv3Rfq+aoav2ZU5ie
        efUfRWOeNeDFc0o+UhU+41g=
X-Google-Smtp-Source: ABdhPJxecjv39P+KHSXFZ8mUFVT1oqG4appD8TT776jsDA0zrEOPIJfhSw87xASAfcB6SkJbnmoccQ==
X-Received: by 2002:adf:e38a:: with SMTP id e10mr3418328wrm.37.1616591073322;
        Wed, 24 Mar 2021 06:04:33 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id w11sm3034919wrv.88.2021.03.24.06.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 06:04:27 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 07/23] trace-cmd: Define a new option for tsc2nsec conversion
Date:   Wed, 24 Mar 2021 15:04:02 +0200
Message-Id: <20210324130418.436206-8-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324130418.436206-1-tz.stoyanov@gmail.com>
References: <20210324130418.436206-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a define for a new trace.dat file option for tsc2nsec conversion.
Added logic in "trace-cmd dump" for parsig the option and printing its
content.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 tracecmd/trace-dump.c                         | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index a4637046..ce3d8dc0 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -125,6 +125,7 @@ enum {
 	TRACECMD_OPTION_TRACEID,
 	TRACECMD_OPTION_TIME_SHIFT,
 	TRACECMD_OPTION_GUEST,
+	TRACECMD_OPTION_TSC2NSEC,
 };
 
 enum {
diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 4bdfd53f..31b9d201 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -483,6 +483,22 @@ out:
 	free(buf);
 }
 
+void dump_option_tsc2nsec(int fd, int size)
+{
+	int mult, shift;
+	unsigned long long offset;
+
+	do_print(OPTIONS, "\n\t\t[Option TSC2NSEC, %d bytes]\n", size);
+
+	if (read_file_number(fd, &mult, 4))
+		die("cannot read tsc2nsec multiplier");
+	if (read_file_number(fd, &shift, 4))
+		die("cannot read tsc2nsec shift");
+	if (read_file_number(fd, &offset, 8))
+		die("cannot read tsc2nsec offset");
+	do_print(OPTIONS, "%d %d %llu [multiplier, shift, offset]\n", mult, shift, offset);
+}
+
 static void dump_options(int fd)
 {
 	unsigned short option;
@@ -543,6 +559,9 @@ static void dump_options(int fd)
 		case TRACECMD_OPTION_GUEST:
 			dump_option_guest(fd, size);
 			break;
+		case TRACECMD_OPTION_TSC2NSEC:
+			dump_option_tsc2nsec(fd, size);
+			break;
 		default:
 			do_print(OPTIONS, " %d %d\t[Unknown option, size - skipping]\n",
 				 option, size);
-- 
2.30.2

