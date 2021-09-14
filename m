Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D933CC433FE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4BC610F9
	for <linux-trace-devel@archiver.kernel.org>; Tue, 14 Sep 2021 13:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhINNUq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 14 Sep 2021 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhINNUp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 14 Sep 2021 09:20:45 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90022C061574
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g16so20216416wrb.3
        for <linux-trace-devel@vger.kernel.org>; Tue, 14 Sep 2021 06:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dusIo46vr0+twIU5m7rA4qbkKOhLThJ/Bu3lxisqUc0=;
        b=Mtc3x+rtExjuIwIf2c2ObOhzj0zJpbJ3iDSu6HQAw7YqAg/n5Lu//Nyj/XOwONELHK
         R0oyVoJSMk7r0g6ihN7BNs3b/YQCZXVDsVcukWM3mbTkfl3hN4g3q8XSkh4aX1cIxx6i
         yLAcAhhexXQ164PGKyb2oCO+yAjQ5TnDoXqFrGJPC/zSMho1evs3bG9oIBJRMDGCONsc
         ZJo3WkSIhoA8YXCgzyqRUDnnIL5udvYta1tdHvIOS4V8vqoiAQuO5cvnUODSZgxKZ+IC
         +cR/RSIzY92bvk6UHLITnuyOJjNRmVPUs53gs9ytwnfcJdV1t+nuZzo4KKcA4qh5LG5t
         yy/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dusIo46vr0+twIU5m7rA4qbkKOhLThJ/Bu3lxisqUc0=;
        b=ShnRT57AmM0a6EEZTXhGMf7uUQdrMTe3vnMrkDRwS18Vb8/kcFS+YXf+D//+Eyzbu6
         sPV724Y0JzKasoOFi34uFs5Qu2vvA2oX1JahWKQoUK32gNcH0nWiwmNrjTLJDODAD+RM
         E8vw7BN5QbFGEfzhVrPiQS5xKPjWD42MCBkV6nwyUuidycssSsTPwuTTjWdjYXoMfOtB
         yJuW2iLqoZHN8E2yTxJVAIPG3LPC6mwG57U/mrO3p37xLtubciJ4lMWOWS2dIolLTEoN
         I+qojQTt2G87164Lk4kkfg5+yU7KZGhuyyZQSGLkqfPcXO0c8ddRQhxZvdVQB03djXFZ
         cemw==
X-Gm-Message-State: AOAM53234eiqiTx6/DBQNaChe4vR5rm73587fephNYhnO3cYjuKpOweN
        8ew6tHXR3eskjrmoARx0R9eA10mBRi4=
X-Google-Smtp-Source: ABdhPJyLBZ0fUhfh3nQQqrCCkx9qVnOc2gfghzxkYgR8UgLpmuAAYpVRPke8kEwCd6Vb4L5ZbGR8XQ==
X-Received: by 2002:a5d:598c:: with SMTP id n12mr17682678wri.391.1631625567253;
        Tue, 14 Sep 2021 06:19:27 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f18sm4545302wrw.63.2021.09.14.06.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 06:19:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/8] trace-cmd library: New API to copy buffer description between trace files
Date:   Tue, 14 Sep 2021 16:19:17 +0300
Message-Id: <20210914131921.3967421-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
References: <20210914131921.3967421-1-tz.stoyanov@gmail.com>
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
 lib/trace-cmd/trace-input.c                       | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 8ff46d52..4930063e 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -189,6 +189,8 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
 			  struct tracecmd_output *out_handle,
 			  enum tracecmd_file_states start_state,
 			  enum tracecmd_file_states end_state);
+int tracecmd_copy_buffer_descr(struct tracecmd_input *in_handle,
+			       struct tracecmd_output *out_handle);
 void tracecmd_set_flag(struct tracecmd_input *handle, int flag);
 void tracecmd_clear_flag(struct tracecmd_input *handle, int flag);
 unsigned long tracecmd_get_flags(struct tracecmd_input *handle);
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 9e3f4bc0..920a319c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4902,6 +4902,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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
+	return tracecmd_write_buffer_info(out_handle);
+}
+
 /**
  * tracecmd_record_at_buffer_start - return true if record is first on subbuffer
  * @handle: input handle for the trace.dat file
-- 
2.31.1

