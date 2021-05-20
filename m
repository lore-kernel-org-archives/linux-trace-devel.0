Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9E4C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452A161163
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbhETDVy (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhETDVy (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3363C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:32 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l1so22955386ejb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vmi5AjbJuXgF72hp4cDxxO6svoQZ6g9atW7rqDFkATg=;
        b=C34kszP+1igmfAnvDQFCstOCVzB4Kt9AmTz8cZXHa4/GCHgTMseYrIy7RIZpRh//3b
         PP9wdZRgBbV4ZkPh0+Vt7PBz3ql3bTEvvOOnCFhM5WhjUP574BiklNdP3D1YaUi1dnNY
         aWRUvakJZB667Cf0EB5G7Z8wEVu0PLS9S6mtjerbEk7TedYwHfT1z1nlRMCKH/QVsm3o
         FP5mPnlckUJ+0+IRkGe3gbhCJREU1hS2EsYy571mUuEoh4Qz5iD6Y5KJ9C8Ssvd4tjL4
         SIVMwvGTmWmYBjPtrYZ+PpqHcIrTQpt6v0GpYEwtbilxx6IKtjuRw0ncYNDmkyE/U8Cv
         F6kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vmi5AjbJuXgF72hp4cDxxO6svoQZ6g9atW7rqDFkATg=;
        b=aqZ7oHIwv2WPk6KIY3EeYYDpKOfyNPbPIkPNS1bJN0kBXlEFBypK1eue8VS9WdA0W8
         Tt8+coXT8IEXuM7HFz5TI8rDsx7gMRdU9fNJO3SnRPUeWSOWMScu9HrwXHIDxrJmp/rk
         lbZ5kA7CHe1Ds7dUIEHp35xWuoFfTCsi8h5Mzbec70DOC4JiRiRZs3KBpXxlbNcoOiS2
         9N1EgVye4t1Sbq+kpzre2Svf2V+aWBNujab5eIbwPlbBM8Cx+C4nAkgZW/aAna8+FwLn
         V/orl4EMWhuDOTf8bNKBnEEmGbTWFqQwd+8dyrydMkHJNa2sK7e9W+iu+qNWSX233mEi
         plJg==
X-Gm-Message-State: AOAM5307SESVw9g5xtmOyrv9polg2PXe3o4RkUBE9kJ0qyk++splKrIk
        KqPoAUwi7ySXBa7dTkwipQpVcNj+YrQ1QQ==
X-Google-Smtp-Source: ABdhPJz0L5BPeXtUyTjyJB0T/dW03k6dAEln297RrwjLtnspRHP4sqHAGMlqsCCJ9erlXzq91wwmYQ==
X-Received: by 2002:a17:906:b2c1:: with SMTP id cf1mr2390619ejb.544.1621480831463;
        Wed, 19 May 2021 20:20:31 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:30 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 27/29] trace-cmd library: New internal API to set file state of output handler
Date:   Thu, 20 May 2021 06:19:57 +0300
Message-Id: <20210520031959.346165-28-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added a new library internal API to set the state of an output file
handler:
 set_out_file_state()
This new API will be used internaly in library for split and convert
functionality.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/trace-cmd-local.h | 3 +++
 lib/trace-cmd/trace-output.c            | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/lib/trace-cmd/include/trace-cmd-local.h b/lib/trace-cmd/include/trace-cmd-local.h
index 48a01d43..830bbb1a 100644
--- a/lib/trace-cmd/include/trace-cmd-local.h
+++ b/lib/trace-cmd/include/trace-cmd-local.h
@@ -51,4 +51,7 @@ void out_compression_reset(struct tracecmd_output *handle);
 void in_uncompress_reset(struct tracecmd_input *handle);
 int in_uncompress_block(struct tracecmd_input *handle);
 
+void set_out_file_state(struct tracecmd_output *handle, int new_state);
+
+
 #endif /* _TRACE_CMD_LOCAL_H */
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index e7370798..24c260c4 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1951,6 +1951,11 @@ out_free:
 	return NULL;
 }
 
+__hidden void set_out_file_state(struct tracecmd_output *handle, int new_state)
+{
+	handle->file_state = new_state;
+}
+
 __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 {
 	return check_file_state(handle->file_version, handle->file_state, new_state);
-- 
2.31.1

