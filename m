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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E6CC432BE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE6060D07
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236604AbhG1NdC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236608AbhG1Nc7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:32:59 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEE7C0613D3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id y7so1009044eda.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oqvzM6eESGiECj8eIUX8GcJE+bAjS8cLQ7UhIuig320=;
        b=BPjqPSOtCVhuPyuVvgg+oDT699yFq44z4HsCXgvP3AgjzsFDIv8ZVwPwrmB8F/s15o
         +L+JC1aH7KnV6TEAqlkkS6L9GZXLtjaXqIZ0XpTQcxc0bLkGpR5A6D7plRessX5mPHnl
         AOn0MjFlfe5ts/dCOr95LnIFz/QAxoS8DQF+GbgFtM1y+FQcS0LOpcmR9U8Jjjul1xgH
         EWLE5cNILy6QPqii/KIU3jksG76Ux16zI1narKtZMFsD+PbnEYfC1Om4MCrcav2nCvgf
         hsBuw970r3xB9VaegzQDG/230jf+0w0fsml7qgwANt3O4iZA6YKvsSj7FBtiwcfRGXzG
         Sm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oqvzM6eESGiECj8eIUX8GcJE+bAjS8cLQ7UhIuig320=;
        b=k5ci8TI7k0DLeHO68FnI09SUIBK0ww+gzYTgyLipIsDRo5864Ih0PfY2OhPufBG5fc
         NUxH6rP42LrGlUQ04lzW3p43XOhDbEkTX6NRewwjWPQF8qhKLc9ZAKyBEamN1UvI2pxs
         Td9ewF+jOATTAj8ykb7ZzTqzairBJfvuNIuLqef4+M0nGTxV6IapGsfcj7ope/u6kYy1
         oVeutgfL+0Y/TtGhjkb0wMg5PfYtWc7iitvVsFdxj+TcyFLeEHNOk6yLS8HA0gZAXqP0
         tTxdrm2z2xMoeG0YsJ8PAqncMVP2ggSNsBxOsay3KpxEjw4LEVCo40WujY62cgq96/3g
         7Qzw==
X-Gm-Message-State: AOAM533BL68dLSidZZcohJ9fBuxoIV2G0wOVjbvYbMdQVEL51gk+MgIS
        E1Z3LjeRfnu7oCFSc8j0oJs=
X-Google-Smtp-Source: ABdhPJxBp0E8VQ6YYAG+AMlaH8q46oLyUPGQrs6n3MbM7NvR45vc9iXxXx8sHcUyVmuwL+sMwfuwMQ==
X-Received: by 2002:a05:6402:12c3:: with SMTP id k3mr19111634edx.11.1627479175099;
        Wed, 28 Jul 2021 06:32:55 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:32:54 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 03/87] tarce-cmd library: Fix version string memory leak
Date:   Wed, 28 Jul 2021 16:31:26 +0300
Message-Id: <20210728133250.234140-4-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The version string is allocated when a VERSION option is processed, but
is never freed. Free it on input hanlder close.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-input.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 6e7024a6..d5ffafd7 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -3517,6 +3517,7 @@ void tracecmd_close(struct tracecmd_input *handle)
 	free(handle->cpu_data);
 	free(handle->uname);
 	free(handle->trace_clock);
+	free(handle->version);
 	close(handle->fd);
 
 	tracecmd_free_hooks(handle->hooks);
@@ -3958,6 +3959,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->cpu_data = NULL;
 	new_handle->nr_buffers = 0;
 	new_handle->buffers = NULL;
+	new_handle->version = NULL;
 	new_handle->ref = 1;
 	if (handle->trace_clock) {
 		new_handle->trace_clock = strdup(handle->trace_clock);
@@ -3970,6 +3972,7 @@ tracecmd_buffer_instance_handle(struct tracecmd_input *handle, int indx)
 	new_handle->parent = handle;
 	new_handle->cpustats = NULL;
 	new_handle->hooks = NULL;
+	new_handle->version = NULL;
 	if (handle->uname)
 		/* Ignore if fails to malloc, no biggy */
 		new_handle->uname = strdup(handle->uname);
-- 
2.31.1

