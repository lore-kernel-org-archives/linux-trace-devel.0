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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F5FC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E23F360EC0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhG1NdN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236645AbhG1NdK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:10 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EB9C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id da26so3272275edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H4TXdWVR0KHalzeA1Oa3mJ2zNP6QDQtoY5CWQCoBnK4=;
        b=vUhwF/Hb6q3o1oWoVLgVVVo/Y5oegg7ea504Sa7HK7PbR25XPlRib5u3hVKtv2tRRI
         PJkeWJIxQHkfrqk8LjFJBoI0hon6x/wyRAJ7UvPJ2Esxpxdv4TiwWwwTtsmOK2wpOhQe
         +YpxWFxpZvPjX687WBmUwHcgMEP7Mh7WJSBrs0bZ3klctG6PbyccXmcPOLF7H3FbjZft
         RBmtsriW4LCFHW9LDh5+fn61cSRqRPcz7yL8olFFQTe1Z3f/laP6ye57ciq9atP5s5DS
         G1qxSSHrgDphBEZ/1aRd9J7UDtkWYxISu08PIRe7dQQJW356BoMhHCwXaZQuaCexT+kO
         mbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H4TXdWVR0KHalzeA1Oa3mJ2zNP6QDQtoY5CWQCoBnK4=;
        b=e5JzdtfIRkRMZR1jc3e+yiQAIyptc04K8m40JphGbImm3lKj+LGCeF1OnMreqT9pcM
         4wGXftA7EETdfwBoRomzkOmvDSLplZSFPQy/Id1j/qT32i+pO+O+euUHlOkyiHUxzzy9
         CpLuGDYxdA+dhw4/bYsVVkRtIE/3Yf+KXSAfZga3WCM1UJi8o1IB6BWyS0qFx/5FH6Pf
         jmDSJhf+sjXzzj3Kk8NJG1+W+KWv7NuCRIF5w3uEfadIrjXqtwZ41/JW0nYMlP9AT99N
         G2WKGEuffQnMgMoyKA3ef7RaBun2sPmMIwewK7Gz2ET+GxBdR43BCoXQmUqbz5LByvC6
         75tw==
X-Gm-Message-State: AOAM530+pULmMg012uRyj7EivdPAQWszqafLDbD5dXgVwmJWqK85CE8a
        q5Aa632FHOggk2tHJIj7W44myzDeDwCjYQ==
X-Google-Smtp-Source: ABdhPJxTx3ZcuQi9MpKUTNbtzyHKPxBJ/D1eBD+wSObpVmanksxY1M7MenYqQVBZumoIdbASRYvA2A==
X-Received: by 2002:a05:6402:1cb6:: with SMTP id cz22mr17996086edb.148.1627479187247;
        Wed, 28 Jul 2021 06:33:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:06 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 15/87] trace-cmd library: New API to get the version of output handler
Date:   Wed, 28 Jul 2021 16:31:38 +0300
Message-Id: <20210728133250.234140-16-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

There are cases where the version of the file, associated with given
output handler must be retrieved. Added a new API to get that version:
  tracecmd_get_out_file_version()

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/include/private/trace-cmd-private.h | 1 +
 lib/trace-cmd/trace-output.c                      | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 16dbed56..2fb15026 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -316,6 +316,7 @@ int tracecmd_append_buffer_cpu_data(struct tracecmd_output *handle,
 				    int cpus, char * const *cpu_data_files);
 
 struct tracecmd_output *tracecmd_get_output_handle_fd(int fd);
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle);
 
 /* --- Reading the Fly Recorder Trace --- */
 
diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 8e402d35..2c10575e 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1843,3 +1843,12 @@ __hidden bool check_out_state(struct tracecmd_output *handle, int new_state)
 	return check_file_state(handle->file_version, handle->file_state, new_state);
 }
 
+/**
+ * tracecmd_get_out_file_version - return the trace.dat file version
+ * @handle: output handle for the trace.dat file
+ */
+unsigned long tracecmd_get_out_file_version(struct tracecmd_output *handle)
+{
+	return handle->file_version;
+}
+
-- 
2.31.1

