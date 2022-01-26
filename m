Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809FFC2BA4C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 26 Jan 2022 09:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiAZJwF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 26 Jan 2022 04:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbiAZJwF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 26 Jan 2022 04:52:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC67C06161C
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:04 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id j23so63028410edp.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 01:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1r3q6UI3ETEfXlpiKGuOGPYwXnfQP0DjegJSqd7Veys=;
        b=XKPVgdAhEettpMMhC52qvVZYROUS6g09ZZvVuW3/C6dy09gsZMRd88BQ6Lz/k18mmH
         OnbBp8UHyyOtlM2z9F9BwOARqSXTrjpIUd3rozeihmm6o0GlyVe5rAXWrWgjmGAzUJvC
         zo9X/ny+d92/OO9xhx2qA8Kuvsng0Bf3rhqfa/wSjhGk5UZmARQSRlUSiGvQaTqo4WOI
         EqzX+aQx7speD60pY6vqpDYPxrX20YZsb5N7T18VBikqTl4wuQYlGLwpQt2czWM8ozV7
         DvhczyHq7SiFUnG8sW2OqywlZooShuwUb8mvFz3XCdchRBOtaYJZFKHlmAx+XCuHasCf
         x7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1r3q6UI3ETEfXlpiKGuOGPYwXnfQP0DjegJSqd7Veys=;
        b=Dw3+dnNbZ8E5uL4DKXcl48BJv9EF4Ae5W3hpg2PEW5rq6kpytLVyQTnorRJDH6cv7j
         RJoE1+MYAnfzG362sDlAWK9dyPoo/NCSyxqnNbTB+poHulY1uFfNTW9GoNS2F9JPuhBM
         ynWBkMSiMnB0RuUMQRiFtag3WoW5odyksv5nSf7njX+5ouf3oHrvm4G0stW51BEKKVgV
         XQnZq0BOZCLh7juc6jN+pvBFqLiuvj7iBl+AOKD6/LD8WCHlVhwnMhZ+1K8TdR/JFvtg
         /yuKga7b0I8dQTKhX7KAdZD9yQU6eJ2est4/SABPDTfRYIGtwsVupKYW6l6PhBhB53HI
         zj0Q==
X-Gm-Message-State: AOAM533TB1Xtiv6h88rLIqzACEpNMnaJECRr7jsVtI8b96tApboHs5Gb
        6AkzQHYQG42vceri8C3fcX83SUg4bMs=
X-Google-Smtp-Source: ABdhPJzGS7+0L1vfcAzW++W1MWSOpdwKA51ogBwhFY528YGtabV1MMlMhJpileXyCtc2CXH629tjoQ==
X-Received: by 2002:a05:6402:26cc:: with SMTP id x12mr14573767edd.153.1643190723240;
        Wed, 26 Jan 2022 01:52:03 -0800 (PST)
Received: from oberon.zico.biz ([151.251.254.11])
        by smtp.gmail.com with ESMTPSA id v15sm9529823edq.35.2022.01.26.01.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 01:52:02 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v8 4/9] trace-cmd library: New API to copy buffer description between trace files
Date:   Wed, 26 Jan 2022 11:51:49 +0200
Message-Id: <20220126095154.570700-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126095154.570700-1-tz.stoyanov@gmail.com>
References: <20220126095154.570700-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new library API is introduced, to copy buffers description between
trace files:
	tracecmd_copy_buffer_descr()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h |  2 ++
 lib/trace-cmd/trace-input.c                       | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 5bbe5898..07430d37 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -195,6 +195,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9afc6559..5f2b9d85 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -5009,6 +5009,20 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 	return ret < 0 ? -1 : 0;
 }
 
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle)
+{
+	int i;
+
+	if (tracecmd_get_out_file_version(out_handle) >= FILE_VERSION_SECTIONS)
+		return 0;
+
+	for (i = 0; i < in_handle->nr_buffers; i++)
+		tracecmd_add_buffer_info(out_handle, in_handle->buffers[i].name, 0);
+
+	return tracecmd_write_buffer_info(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
-- 
2.34.1

