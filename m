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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 868DCC49360
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7446138C
	for <linux-trace-devel@archiver.kernel.org>; Mon, 14 Jun 2021 07:52:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhFNHyW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:54:22 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:39444 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhFNHyV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 03:54:21 -0400
Received: by mail-ed1-f53.google.com with SMTP id dj8so45193135edb.6
        for <linux-trace-devel@vger.kernel.org>; Mon, 14 Jun 2021 00:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OL6z+eplL6Um4JCUwgrmpOe7SOkUvFTEKsytnrQIMvs=;
        b=tBL3xhbBePer2qFA8n+wh1wMGgG5QKX90Beaa1kkTB/PVeviOio91LjqUUAKr0t7Or
         S4C4Rq9L6XmXwAZAxpYPE3SY80A1MAgjeGhbQGRufIonIv78A8ABPLASjUXI896Zi4uq
         6iW9zb7d+VwCHognbVkw8XIkaCa4ZYpjJx5NIUB1dufRYHx/kuQba9uR13/7FunHkV6C
         RlVHr3pLcUj5m+YNTb0yd+xmjMOnRyGadgHTFXTgCWfwX6qT80RHQe3vskacmCWYNUq+
         tLFkJH8jwbg8iVlp01ElLLPMIPU8gJ0j7UOd/PzrHb1uBlh7hSbFo0ClqKcuFjZZoVEQ
         G9ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OL6z+eplL6Um4JCUwgrmpOe7SOkUvFTEKsytnrQIMvs=;
        b=PJe5L4AVxEpBu50M4phmceyf4QD+VZUQ6Gj59iwXwLs9Sd4hzXPJZvobJwdgC6MkT/
         sVtGK7ZdjTTV6w/6kVzx7hdKwwTLRD4yGcCQaRmONAKZW10irifZXTdRbftvCjXaI7H1
         nMdejvy8Vr07+DCKzAOn8LSfuNHF7p7JdWomAaDvrfTm25GeTGsyuhdK6CjhdvV9vy0p
         o+VVHIlXP5BgzCtmqDwYJsa28FzlEyAq3ZywJ1r5/ERwa6L4jK++r65nhvt9sp6fAWPD
         g4YOkBg4qQXvKGamqconzlyb+kCIrAbZoQT9LVsAldx2FPeaJAFY1fXAvdRCWdn9RVg2
         ZcPQ==
X-Gm-Message-State: AOAM5337XmPLtwpBHd+eypGLb7WiWkx6qMcvJulWM6qxI0sM7lxTk0Ku
        KV5PGmSHu4wJOPaEIH3BgsU=
X-Google-Smtp-Source: ABdhPJxlpZdOavn/g0aLy2mM6QjLU5Rtf+nCfH+dG9EljhBGQq3yhh9tqSlQqgV8y2f2hj8RURW+Eg==
X-Received: by 2002:aa7:c584:: with SMTP id g4mr15291731edq.335.1623657062489;
        Mon, 14 Jun 2021 00:51:02 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f6sm6536444eja.108.2021.06.14.00.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 00:51:01 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v6 32/45] trace-cmd: Add file state parameter to tracecmd_copy
Date:   Mon, 14 Jun 2021 10:50:16 +0300
Message-Id: <20210614075029.598048-33-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210614075029.598048-1-tz.stoyanov@gmail.com>
References: <20210614075029.598048-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The tracecmd_copy() API is used to create output trace handler from
given input trace handler and to copy data from it. Currently it is used
by trace-cmd split and restore commands, that's why it is hardcoded what
data to be copied from input to output handler. Addig desired output
handler file state makes the API more generic and allows it to be used
in more use cases.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 4 ++--
 lib/trace-cmd/trace-output.c                      | 8 ++++++--
 tracecmd/trace-restore.c                          | 2 +-
 tracecmd/trace-split.c                            | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 9a08a960..2c31be5f 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -309,8 +309,8 @@ int tracecmd_write_options(struct tracecmd_output *handle);
 int tracecmd_append_options(struct tracecmd_output *handle);
 void tracecmd_output_close(struct tracecmd_output *handle);
 void tracecmd_output_free(struct tracecmd_output *handle);
-struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle,
-				      const char *file);
+struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
+				      enum tracecmd_file_states state);
 
 int tracecmd_write_cpu_data(struct tracecmd_output *handle,
 			    int cpus, char * const *cpu_data_files);
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 9b83eb76..806c833c 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1931,13 +1931,16 @@ struct tracecmd_output *tracecmd_create_init_file_override(const char *output_fi
  * tracecmd_copy - copy the headers of one trace.dat file for another
  * @ihandle: input handle of the trace.dat file to copy
  * @file: the trace.dat file to create
+ * @state: what data will be copied from the source handle
  *
  * Reads the header information and creates a new trace data file
  * with the same characteristics (events and all) and returns
  * tracecmd_output handle to this new file.
  */
-struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file)
+struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char *file,
+				      enum tracecmd_file_states state)
 {
+	enum tracecmd_file_states fstate;
 	struct tracecmd_output *handle;
 	const char *compr_name = NULL;
 
@@ -1946,7 +1949,8 @@ struct tracecmd_output *tracecmd_copy(struct tracecmd_input *ihandle, const char
 	if (!handle)
 		return NULL;
 
-	if (tracecmd_copy_headers(ihandle, handle, 0, 0) < 0)
+	fstate = state > TRACECMD_FILE_CMD_LINES ? TRACECMD_FILE_CMD_LINES : state;
+	if (tracecmd_copy_headers(ihandle, handle, 0, fstate) < 0)
 		goto out_free;
 
 	/* The file is all ready to have cpu data attached */
diff --git a/tracecmd/trace-restore.c b/tracecmd/trace-restore.c
index 96b4fb5d..7d439fd2 100644
--- a/tracecmd/trace-restore.c
+++ b/tracecmd/trace-restore.c
@@ -125,7 +125,7 @@ void trace_restore (int argc, char **argv)
 		if (tracecmd_read_headers(ihandle, TRACECMD_FILE_CMD_LINES) < 0)
 			die("error reading file %s headers", input);
 
-		handle = tracecmd_copy(ihandle, output);
+		handle = tracecmd_copy(ihandle, output, TRACECMD_FILE_CMD_LINES);
 		tracecmd_close(ihandle);
 	} else
 		handle = tracecmd_create_init_file(output, NULL);
diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 8366d128..401e1d29 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -345,7 +345,7 @@ static double parse_file(struct tracecmd_input *handle,
 	dir = dirname(output);
 	base = basename(output);
 
-	ohandle = tracecmd_copy(handle, output_file);
+	ohandle = tracecmd_copy(handle, output_file, TRACECMD_FILE_CMD_LINES);
 
 	cpus = tracecmd_cpus(handle);
 	cpu_data = malloc(sizeof(*cpu_data) * cpus);
-- 
2.31.1

