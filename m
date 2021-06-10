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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE12AC47094
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA2961410
	for <linux-trace-devel@archiver.kernel.org>; Thu, 10 Jun 2021 11:35:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFJLhK (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 10 Jun 2021 07:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFJLhD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 10 Jun 2021 07:37:03 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA19C0617A6
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:59 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 3-20020a05600c0243b029019f2f9b2b8aso6214462wmj.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 10 Jun 2021 04:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6d+ps2XI6q8t8p5XkZiTzQSOgVeK23JVAY/zSugXJQ0=;
        b=FVdEySxM5hs5y8uTrZC3+t/+/XhbukG9noL33LKU5fsEE2qK4ihNd4TdcL80D8boPb
         l77mypErCW/Lh/BSOJccnwq0oJCEIWUz0DDp/rRQM8FGDoDH6g2bjgsWE+Z1u1sfqKTw
         zaKmbzsDGMJ6LNMjeeonfyvME3krKk4zaWWZBk+0Nd2rRxX5jseMp9zSdQP5M4YdqRDD
         NhqKJ5ZrreUYFC3rCWZLqCA26Gfl58ka6rYWv+zM0KokD8VtSjsJii90qgbp7DHWsKT1
         6g3byp8hP787YWHay0rTmp+9ZA1tmVVvRNS46ITKDxhRlwUT+aMzI+oIZ+XwyBSBzgak
         egiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6d+ps2XI6q8t8p5XkZiTzQSOgVeK23JVAY/zSugXJQ0=;
        b=MRzmv2Y68oJogiG9ghBFIgftXNHJMgNjSIidUHRB253dOwkUbDgOnYj0h0Je2Hxdla
         3BZevq0FETTvuVg7f/zs4x45se2IpyGSO65ShQv4JFtmSFFn1vdlZWGZhKHSxe2+JEzK
         dpp8cWbiYYJDnaUKtYUVkhnbtY2ALr15wPl+0E5KqvaIva69ErKlyWKPui3icoSkhl8/
         aWv5c7Qig0AbW5mIAg2+CN6QVS0AfRAtG+AJ6mfLJXqKpphaVeVMOZfmTQlHbobL/Gml
         jejlhepTT+AxWbU7jqff4ADn+a4Vo3b9UQC84CbYrR8oMUqteDMDvEeHy4et1eNQULyI
         v+Xw==
X-Gm-Message-State: AOAM531mmFMAEwNrb8xX1akqvMC3dQ2/swLJIWVo5tTpgOD0pmb/Mw/+
        q+GuyhvvN1plkW8lPIKQGB9Kp8CHX1uG9g==
X-Google-Smtp-Source: ABdhPJyEEsZ7G3RHFSF6gzDoS4WLW0jESO7+R0yZ4ERk+hzMh7HOnAaLqbRNJktrG3O6n7oa3NFxHw==
X-Received: by 2002:a1c:4b0d:: with SMTP id y13mr4530876wma.179.1623324898041;
        Thu, 10 Jun 2021 04:34:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id n42sm8898391wms.29.2021.06.10.04.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:34:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v5 32/40] trace-cmd: Add file state parameter to tracecmd_copy
Date:   Thu, 10 Jun 2021 14:34:18 +0300
Message-Id: <20210610113426.257931-33-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610113426.257931-1-tz.stoyanov@gmail.com>
References: <20210610113426.257931-1-tz.stoyanov@gmail.com>
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
index ff9c9a34..e3b018aa 100644
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

