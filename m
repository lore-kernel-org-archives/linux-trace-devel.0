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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360BCC433EF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 190C160FBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 13 Sep 2021 12:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhIMMtV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 13 Sep 2021 08:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbhIMMtR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 13 Sep 2021 08:49:17 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424FEC061574
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:01 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g19-20020a1c9d13000000b003075062d4daso1357822wme.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 13 Sep 2021 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tYi/OxG9q8YttiGK2z4ezEmgneh7bLVQNh0Z0ehABFo=;
        b=l4Ac9PkXdfLYya0VmjKZU+Xt+B+h2xb/eA1rhR2k3Ead6gLsXvyCtPTU8+pB8JhSlh
         qZZA3p13uwCgo/E0ZJK8m9TWpB6wIAViYcgIvrX7vkAOpmbX4L3IwX/aZKn3OKu4H01j
         v9T+CmuDRoinmzBvYuKhZKVq9m9wrKvbtlGIM7pIysS/MlWn3JAeY0y+GNMV5uq0jq4Z
         s/jcd6JwRS+5E2mp3doaFtbHKz7quKDq5CM2D0PnHooYVXg1u67lM2RErmewP83uWNoS
         g0eiCdtX2Bh4PHrsYz9S5t4LJOVLQg5QFQvRqhCjgPnmowfSmC2oIhLf/F7c3oWDMzhA
         zeBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tYi/OxG9q8YttiGK2z4ezEmgneh7bLVQNh0Z0ehABFo=;
        b=1f8ptDUB2+VBYteDEvg2o0MDkMYUkzPJfnDjMvBm25JusQRR8ZPKlmu+UtvZJ5VsBE
         uiHEVXSlQirDrXPWR1qI1Vl9yEdt6QmyWHTmuPxpEVY2iWd+Qa6mysbSowkUHsRUsSyp
         7g5gkRvV1bBG/JbwC/A6VK0oT3Jg1lxYiAyk9Mey3HNbWgoceDAirssmM5n1gNalHf5S
         4Pk2qCsOLIO+OErtisLDyVZntghzdHyJKmR/T3ag2f3RbMpDyB/7MrxlTy02KIWMyMv/
         gFYTO/09ejMTJkDyAIptzkP0d/LPgab8+JrZIlTxxUlZTPMwZVgVBNggzisM2jlSkRYJ
         aMeA==
X-Gm-Message-State: AOAM53063EYtHt5axe9UgSxX67D1rqsuiX2JzJf1c8kfIxi/boyXiHos
        bUgXIDyW7jtfExaH1RQWR+ThzwDTxt4=
X-Google-Smtp-Source: ABdhPJyoK62ZMmDO3uECyglIYY/c4aooC841u9+/QO3J0JrKLvB4tpsi8HhXqccQzFvOoOJSpkDDAg==
X-Received: by 2002:a1c:7d0f:: with SMTP id y15mr10341748wmc.41.1631537279862;
        Mon, 13 Sep 2021 05:47:59 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id k17sm7718077wmj.0.2021.09.13.05.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 05:47:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/8] trace-cmd library: New API to copy buffer description between trace files
Date:   Mon, 13 Sep 2021 15:47:50 +0300
Message-Id: <20210913124754.3679916-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
References: <20210913124754.3679916-1-tz.stoyanov@gmail.com>
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
index c3d7075f..86010dd5 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4898,6 +4898,19 @@ int tracecmd_copy_headers(struct tracecmd_input *in_handle,
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

