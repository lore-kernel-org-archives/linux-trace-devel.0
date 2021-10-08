Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FABEC4332F
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E6161073
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Oct 2021 04:13:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237293AbhJHEPZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 00:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237288AbhJHEPY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 00:15:24 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AC7C061570
        for <linux-trace-devel@vger.kernel.org>; Thu,  7 Oct 2021 21:13:30 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b8so31166063edk.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 07 Oct 2021 21:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oVu8pY3/hQgRZzpaZTZau6X6vXl9h+f2NZxNYNpdzgA=;
        b=emr0jCV9cE6VY3o7tYq6pyPFCY20tEuEhHcmL3i1HuUkbSooRNdpBephvpvO49Opqg
         WLWLOAunIdA0JROA1+5J7teqwwWl2RUEbERmFafEolH6U1yncd082wSjqxFgLaXAL+v/
         gjV7p3HwIx/Mmj+2bao6yb5RG+VmJe1Od3lI68RWb75xlDBffDo4+WaN2if1898FqnTg
         8fFCZLjEN+qNAG8V0+4plXYLhiq9rD8DQCgDJa5RSkY6UOZF+jAzjNpr5LHXb2rL4VoC
         OBDQcLlJvA6sKNowh7qgeRatd1MIMJsQxYEoguBAyRUCMki5dj6IB5YhxToFT9Nv8xZn
         cacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oVu8pY3/hQgRZzpaZTZau6X6vXl9h+f2NZxNYNpdzgA=;
        b=qhIzzl+Zu2c+iSAVFI2ySjyLVacilm8zvQYopdwiQkP8UCyfsGSH+oCpk+CVvOFCOn
         bawT/GmVUnCC9CxFo4qorV6SMxF6truRk6mQGF1sWbruw5XvQOLXjMkiFL41qXRU7R5G
         AJMxDbgeYzFO2vZZxUEq13RosoifYKh5xfnEGE/5jpAaVClJ9hqP7T/3Ga/PqzO6arJe
         QE7RyBQQ1/4Aq+g29HpnhBSBHX3HJyab8CY3aPHhk/Jvp/UbMl6Re/yteT1VgA1tQIjv
         KPAv0xkhFaXMLN4AFrOxh9jzfesrRvl23kDYg8b6SnWwNG5lfxZ912tJAYcBIHEX48dI
         97iA==
X-Gm-Message-State: AOAM530fIRup+i04dSmkMMLVYtDtTnfVOzypI/XShu2KIB79KAsCFKp6
        K/FZs5rCjn8b/fnHPvIf449WIHIIEN2lUg==
X-Google-Smtp-Source: ABdhPJyZG9LIk/VYMOKothjGHj3XGV8g2DaHr3T888egMByb9M98vNe284YvueEMPibYJciHJ0qkhg==
X-Received: by 2002:a50:eac4:: with SMTP id u4mr11540946edp.259.1633666408739;
        Thu, 07 Oct 2021 21:13:28 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lb12sm465740ejc.28.2021.10.07.21.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 21:13:28 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 05/10] trace-cmd library: New API to inherit parameters from an existing trace file
Date:   Fri,  8 Oct 2021 07:13:16 +0300
Message-Id: <20211008041321.973755-6-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211008041321.973755-1-tz.stoyanov@gmail.com>
References: <20211008041321.973755-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The new API initializes previously allocated output handler with
parameters from an input handler to a trace file.
 tracecmd_output_set_from_input()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 .../include/private/trace-cmd-private.h       |  1 +
 lib/trace-cmd/trace-output.c                  | 33 +++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 8ef448eb..da1dbb09 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -274,6 +274,7 @@ int tracecmd_output_set_msg(struct tracecmd_output *handler,
 			    struct tracecmd_msg_handle *msg_handle);
 int tracecmd_output_set_trace_dir(struct tracecmd_output *handler, const char *tracing_dir);
 int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *kallsyms);
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle);
 struct tracecmd_output *tracecmd_create_file_latency(const char *output_file, int cpus);
 struct tracecmd_output *
 tracecmd_create_init_file_glob(const char *output_file,
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index c654561a..7db3729b 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -996,6 +996,39 @@ int tracecmd_output_set_kallsyms(struct tracecmd_output *handler, const char *ka
 	return 0;
 }
 
+/**
+ * tracecmd_output_set_from_input - Inherit parameters from an existing trace file
+ * @handle: output handler to a trace file.
+ * @ihandle: input handler to an existing trace file.
+ *
+ * This API copies parameters from input handler @ihandle, associated with an existing trace file,
+ * to the output handler @handle, associated with file that is going to be created.
+ * These parameters are copied:
+ *  - tep handler
+ *  - page size
+ *  - file endian
+ *  - file version
+ *  - file compression protocol
+ * This API must be called before tracecmd_output_write_init().
+ *
+ * Returns 0 on success, or -1 if the output file handler is not allocated or not in expected state.
+ */
+int tracecmd_output_set_from_input(struct tracecmd_output *handler, struct tracecmd_input *ihandle)
+{
+	if (!handler || !ihandle || handler->file_state != TRACECMD_FILE_ALLOCATED)
+		return -1;
+
+	/* get endian, page size, file version and compression */
+	/* Use the pevent of the ihandle for later writes */
+	handler->pevent = tracecmd_get_tep(ihandle);
+	tep_ref(handler->pevent);
+	handler->page_size = tracecmd_page_size(ihandle);
+	handler->file_version = tracecmd_get_in_file_version(ihandle);
+	handler->big_endian = tep_is_file_bigendian(handler->pevent);
+
+	return 0;
+}
+
 static int select_file_version(struct tracecmd_output *handle,
 				struct tracecmd_input *ihandle)
 {
-- 
2.31.1

