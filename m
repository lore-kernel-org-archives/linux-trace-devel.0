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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A443C43460
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CB87611AD
	for <linux-trace-devel@archiver.kernel.org>; Thu, 20 May 2021 03:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbhETDV3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 May 2021 23:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbhETDV2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 May 2021 23:21:28 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933EC061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id c20so22976952ejm.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 May 2021 20:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyNKoXfwKbcpwqBj3pYeS8+00BKdpmjvZYvw5dv9nuI=;
        b=i3Ka+M+hD3NMkC7NvgYzR/tfGc04A/UkOY2F5MF+Qp42kSCndOwjNQROYwO2TawMAo
         JLZlX5rH3sq02WbPbWSuCds/y3MGqnPLDaVfXoH7YexiSh2AUFnyli1pEnctWA5N2eTI
         2nN52sVeEMiRLDQtmukRJ8l4kScoUXLxuAQFVWdzC7WpeMkIMbh4N4CKkkUzdJ3FoVJ+
         SaQRPBl1MZZ3rX3XN6Gc/D4SDVPmc2E+GqWu+ZUgDLzpNgXphkDEnByWoL4Ej5JN4/jg
         YWtUQ6jc7BnVVGBu1lsksHUnRH/4C8OzhHgOIKiOEA8G24a0DICvrsZqVXAkdyKClll1
         5QOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyNKoXfwKbcpwqBj3pYeS8+00BKdpmjvZYvw5dv9nuI=;
        b=f3pA57280T+mhemNdGzW7AHzZrM+ZJOxOrrnKi/9YzRMZAk0ncFNSMzDkdSeeS1bwd
         qXZRZgKR/BBMbBUpgbae7u5K0lCcB71dHHP2Jy2QvRuj7pyg86lU6WTohRmqEMMRYHkt
         t1uqU1IUonBICzIcTKJIWtakv58JjFfwJiS0X6wZJTqVEwuyqFe6b9OF5aJMNW6nsm+A
         hCRPPH06Y461N5n6279dE+VjhgVz+MEdODz/bz1KQ1j2kpiyAT989P9rSuwWPCtS4ctr
         pGDHibWU56ETo7lzmspZZjx+wMHZTXlxiZY68siXBCcselF5O3spjDfMgYeROgQ3Ynx5
         URTQ==
X-Gm-Message-State: AOAM53169bjsVOoRDiMZp9EgvBwYZ0ancrXBGqCpl2ja0EH2twlHo5UE
        ovBrvbXLuguNwbxufYEGtOQ=
X-Google-Smtp-Source: ABdhPJyKankNcLjPMoVf45I9F1qjhKevX3r1JRIH/dY9AySB+eH5i31nO/GYe3uHV8pw0g74GyZQUQ==
X-Received: by 2002:a17:907:b09:: with SMTP id h9mr2388094ejl.430.1621480806939;
        Wed, 19 May 2021 20:20:06 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f5sm763280eds.55.2021.05.19.20.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 20:20:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 04/29] trace-cmd library: Add new API to get file version of input handler
Date:   Thu, 20 May 2021 06:19:34 +0300
Message-Id: <20210520031959.346165-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520031959.346165-1-tz.stoyanov@gmail.com>
References: <20210520031959.346165-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added an API to get the version of the trace file, associated with given
input file handler.
  tracecmd_get_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 2 ++
 lib/trace-cmd/trace-input.c                       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 136057b4..6a211333 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -232,6 +232,8 @@ int tracecmd_set_cursor(struct tracecmd_input *handle,
 unsigned long long
 tracecmd_get_cursor(struct tracecmd_input *handle, int cpu);
 
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle);
+
 int tracecmd_ftrace_overrides(struct tracecmd_input *handle, struct tracecmd_ftrace *finfo);
 bool tracecmd_get_use_trace_clock(struct tracecmd_input *handle);
 tracecmd_show_data_func
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 97ad0a5d..67e73c4c 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4046,6 +4046,15 @@ struct tep_handle *tracecmd_get_tep(struct tracecmd_input *handle)
 	return handle->pevent;
 }
 
+/**
+ * tracecmd_get_file_version - return the trace.dat file version
+ * @handle: input handle for the trace.dat file
+ */
+unsigned long tracecmd_get_file_version(struct tracecmd_input *handle)
+{
+	return handle->file_version;
+}
+
 /**
  * tracecmd_get_use_trace_clock - return use_trace_clock
  * @handle: input handle for the trace.dat file
-- 
2.31.1

