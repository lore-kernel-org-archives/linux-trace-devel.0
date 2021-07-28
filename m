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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAFC7C43216
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:32:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D3C6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhG1Nc7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236488AbhG1Nc4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:32:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855E5C0613C1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id h8so3254391ede.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u913aEcM4Y1n3bPg/dvdp50D8ymj8krFrTrlfTU3wS8=;
        b=CYQ6Jg97WAgLRBwkYotyNjUdPhTHn8DFP10badKYK4yqfcLrT5LxE1AozzMwyW7j2/
         hyCqH70j8VmRZCcNdEreRaQ66+8lHT7dhGJBWWa3Cjh3OANJmFd0du+4z9A06AQ4up/d
         vbLqo17VVtZUTBTL7IgAzop3Wg3IrESX4YFnU45orZcKqpKRSeIRfaDZeOlWcKG238y7
         T4IEYEWW2/FWy6+HSh0tA2JG6Ia7Abm03/dwYfwD0rhSH5/JyV78CUA9avISyoeltqcC
         tCrdT79urislLJB2QXDlraE9/D+yBuARSkostabUOoCe+Wyy9hkZqjaGOqNyKJHkWoO3
         lZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u913aEcM4Y1n3bPg/dvdp50D8ymj8krFrTrlfTU3wS8=;
        b=harRNxIACqsY1sMNOI3kJVbkC40b247fblUBCMTSH9h6t16U+BfBB5y8CJmIXa/BY8
         OReJcKtq/SasKWSolEhcY6lmvtw/9Wkr9gdWlzcc2KFj9MsD2+MMm1YnGGL+DG0eDy3z
         IloBLaG5l0VdeMI4oN/sZ5o9yNe/v3Mv3cvDLCY8nTyHWMDNzBQ5DTwX1/GxYMWLemWS
         5dyQhkaXdGG9fqZ3RGGH39h1rXfd63Gz6HxpoRzlZQN+yoSMqTKUoNLu2lYL8Jh/sDsS
         otzXyUhAKC1y3H7FF6hA0SMM8Xx2OuomTC65nzuWxpFjGaIx/euFAbXBQSj5ft6PUtmt
         vhhg==
X-Gm-Message-State: AOAM531C/gLUnRmIltN7u2abiAJzBn/pHRLgw4+AbvQi6of72HzJkaju
        3gryIUzKZElThpqIVFeCjEfO4TGixPYbug==
X-Google-Smtp-Source: ABdhPJyLuKhhQOHUYGAcaDlhEMYeqrVFVhjodyCnbB2Ltj+oE9rejtJBB1S6+53E1cVhvpeGuNGcCQ==
X-Received: by 2002:a05:6402:22e9:: with SMTP id dn9mr13373659edb.218.1627479173158;
        Wed, 28 Jul 2021 06:32:53 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:52 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 01/87] trace-cmd library: Read option id with correct endian
Date:   Wed, 28 Jul 2021 16:31:24 +0300
Message-Id: <20210728133250.234140-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The id of a trace option is 2 bytes short integer. When reading it from
the trace file, use the tep handler associated with the file, if
available, to convert the option with the correct endian order.
A new helper function is introduced to read and convert 2 byte integer.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4f..6e7024a6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -336,6 +336,18 @@ static char *read_string(struct tracecmd_input *handle)
 	return NULL;
 }
 
+static int read2(struct tracecmd_input *handle, unsigned short *size)
+{
+	struct tep_handle *pevent = handle->pevent;
+	unsigned short data;
+
+	if (do_read_check(handle, &data, 2))
+		return -1;
+
+	*size = tep_read_number(pevent, &data, 2);
+	return 0;
+}
+
 static int read4(struct tracecmd_input *handle, unsigned int *size)
 {
 	struct tep_handle *pevent = handle->pevent;
@@ -2660,16 +2672,15 @@ static int handle_options(struct tracecmd_input *handle)
 	handle->options_start = lseek64(handle->fd, 0, SEEK_CUR);
 
 	for (;;) {
-		if (do_read_check(handle, &option, 2))
+		if (read2(handle, &option))
 			return -1;
 
 		if (option == TRACECMD_OPTION_DONE)
 			break;
 
 		/* next 4 bytes is the size of the option */
-		if (do_read_check(handle, &size, 4))
+		if (read4(handle, &size))
 			return -1;
-		size = tep_read_number(handle->pevent, &size, 4);
 		buf = malloc(size);
 		if (!buf)
 			return -ENOMEM;
@@ -2827,7 +2838,6 @@ static int read_options_type(struct tracecmd_input *handle)
 		if (do_read_check(handle, buf, 10))
 			return -1;
 	}
-
 	/*
 	 * Check if this is a latency report or flyrecord.
 	 */
-- 
2.31.1

