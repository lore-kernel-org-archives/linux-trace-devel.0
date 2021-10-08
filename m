Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E78CC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B92E60F6B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhJHEPV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237160AbhJHEPV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:21 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8022EC061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:26 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id p13so31726590edw.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bkf14UTvC7wyjQOgnsEbWJkZBpY0MyQC1pPagFRphH0=;
        b=c9DccbL9kQ5wo+9gF+DbY3ZoO8A7TMeGcQqvXaOeoYvbSnY07QWc+TqZ52pnJQDDq1
         37wDFwkY8C+xngOgc8aD+QbhVRysJP5vubM0dP/CbDzq6TH6dNo7MNwckYJ7UyfIRnCp
         CSs+R6RCmFdMm5B06c5VZBAnfF41A4vhHEzxpw35AsrmAaGCD8Gt72eTYfjGijCsMH+0
         irC9OcoJZ/5PlquGU28VHhDJylWDyf28/yrVaw5LiBsYhe8oVRkDuJ+N6tXcgShVHv3m
         bu0DEkXSujBEOVPh++1Krp7/+77Me7kmk9nso6W3p/nsVhaNHhZ7y0AtznNe5yb6d8kI
         lgJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bkf14UTvC7wyjQOgnsEbWJkZBpY0MyQC1pPagFRphH0=;
        b=QyLNSFKv6LcEAT2jsIUJmevX5S054cx6YwQ6P5rYqCeLDuQSUvDcJ8TvcUkQ7JgXnM
         0BfrpuCIuS+rB3STCLWZgI5pRWvKzyQXQqYKdrEI8QDEPxP4DPKpQy8knqkmFasM/0UE
         gabHQFWvLDgxYPLZy4rkOhl+5fXZ5vQg/SSOfb2hycKBWGx5BEP6CHAqf1GGA/C68KBb
         R6tmda4B9QsbgIm3s8gFFew4lMR4QmwZw0cBxXR/Bsl1olyImIrHV4oPZVft/Rv1qi5n
         RGAwM0FyeWDxJ9L+4KzLKsEq2OYjf0x6Kepo4Bc9uEusAsdNd/LzDc6LMKInt70KUM3R
         N2JQ==
X-Gm-Message-State: AOAM530xdD1shkn2Uion+1RKRX0oT2NcLKYME3jlePXIdcQ7YwU7ZdDk
        MZ8lDYfNdkrDJgsG5U5mpzBb/3U5A+UsfA==
X-Google-Smtp-Source: ABdhPJztPEhIzgzrjiNryZqNjCBHDvNIkiQ2c8NJXd99NAve2gRbcJjmAGZY7Q8yBQxQ09vl8e6CkQ==
X-Received: by 2002:a17:906:cd11:: with SMTP id oz17mr1330437ejb.67.1633666405160;
        Thu, 07 Oct 2021 21:13:25 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:24 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 02/10] trace-cmd library: New API for setting a message context to an output handler
Date:   Fri,  8 Oct 2021 07:13:13 +0300
Message-Id: <20211008041321.973755-3-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API associates previously created handler to message context
with given output handler. The message context is used by the output
handler to send data over a network, instead writing to a local file.
 tracecmd_output_allocate()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  2 ++
 lib/trace-cmd/trace-output.c                  | 22 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index b4cee0f6..2f34af13 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -270,6 +270,8 @@ struct tracecmd_option;
 struct tracecmd_msg_handle;
 
 struct tracecmd_output *tracecmd_output_allocate(int fd);
+int tracecmd_output_set_msg(struct tracecmd_output *handler,
+			    struct tracecmd_msg_handle *msg_handle);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 3878b963..d73c4f99 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -918,6 +918,28 @@ struct tracecmd_output *tracecmd_output_allocate(int fd)
 	return handle;
 }
 
+/**
+ * tracecmd_output_set_msg - associated an output file handler with network message handler
+ * @handle: output handler to a trace file.
+ * @msg_handle: network handler, allocated by tracecmd_msg_handle_alloc()
+ *
+ * This API associates an output file handler with a network stream. All subsequent API calls
+ * with this output file handler will send data over the network using the @msg_handle, instead
+ * of writing to a file.
+ * This API must be called after the handler file version is set and before
+ * tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_msg(struct tracecmd_output *handler, struct tracecmd_msg_handle *msg_handle)
+{
+	if (!handler || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	handler->msg_handle = msg_handle;
+
+	return 0;
+}
 
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
-- 
2.31.1

