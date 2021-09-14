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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FAD2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B96DF610A6
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhINNNz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232996AbhINNNz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:13:55 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F7AC061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:37 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id q11so20115617wrr.9
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=Ie0NkJ81tx5CrTz2YhnVLDpJ2QWzD4L0QZXwvBeTKZjPRzfy1ux4FWWIJNU9Tx3b0l
         K6ACSXsANI1fPpBfRUluZo6ky800JS2wMVvTNVYj/5+62J5fwQ7uD5ZcGTwGyrG3r1UA
         FRWwAoxrR0ORtp7Xf0K9wYyC4XYOSBQVe79xx9tmROo+fYvz1W6t6yG/XwI5PivTBjQx
         S/Y+BbwHh+6Dbb5TFu8L3wG4amKNF9fJnAmwEOLpcdNnPZ5buYKtXjUGlwWYOHdwkAyo
         3dxXiKfV/vgdHPVFtnPBSUhpcfkx1uMoR4rY4B+FhsUwNuuFYWOXBTcwCaUBgiRX9dje
         wIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q/XpTU2XhoHbHAqoA8x/vtqptp62mgjiQRNtFM2Rvqo=;
        b=o5Ly4G0bzNgRml8WgF0+vGEg2rl1Gi7F0w9UKMOyUPywf3khsLeClFtV4WE+vitx19
         gmSOiADF198GaU+fR+D7i4EddheDeNFhaBkfbO7Q8jvwkQtwMyP0WfIwyKExDE+LvRqy
         mEqujFWf/ivTE0UBuwCLAWsMmBkx68XBAbQA4S8FUqWb58CABiATZhnhQ6lZqba/P88N
         BIp5UvRle1EqbBuLtp6DLCq9kcWk6dL1f1Eyq8E/D5su5q+lqnXXwY3K24VM+RgBVD+a
         wR0+oSIrIfn0u/B4/AscfqrGG2TNF2uA6nKRcIJKd1OC+H1HeQrqtM6iiufgdfvLB0aM
         6wmQ==
X-Gm-Message-State: AOAM532EouF0dee7DPEMpFJufev58kLY2nRgrXoRqTIkOgdNeP8RTlYX
        9hCg6xF2oS44lDUiNauMDG07Kwq+Bl8=
X-Google-Smtp-Source: ABdhPJwR9hJSSEQXlJd5tT7Q8tcmHpy6uKMRuLCyxbqEDL8/ZplX4ITquXS3BIlIaC0oTvjheWYqgQ==
X-Received: by 2002:a5d:54cf:: with SMTP id x15mr19334850wrv.27.1631625156264;
        Tue, 14 Sep 2021 06:12:36 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm1910221wmj.0.2021.09.14.06.12.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:12:35 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 01/21] trace-cmd library: Read option id with correct endian
Date:   Tue, 14 Sep 2021 16:12:12 +0300
Message-Id: <20210914131232.3964615-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
References: <20210914131232.3964615-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4f..0dbcdbdc 100644
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
-- 
2.31.1

