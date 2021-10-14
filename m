Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FC4BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BF560FE3
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Oct 2021 15:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhJNPOI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 11:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbhJNPNL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 11:13:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FE4C02B8F6
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k7so20312943wrd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Oct 2021 08:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rOVkO6h9rrRRFzaqv+uBLFrsyHj/virndC9sRVzOI7A=;
        b=DCLXAt63k+NqwZAVriH5m0VSNiGlpsqqVt9A4pIMNhzhBIMAPVK11n40RtCQMAOP9K
         iWHjWVtTJDVJRj9eCuxXgHqn3tZfSZp7T116EQ04uf3z5Sjc+WGV7d1LtQRqVRWrcVxC
         +kGkUQ6vL42A/f51dgIJXPIXStHmRklGeZltVsyddo4MY7urNTqSiYLCuNJX2NgYtnqo
         ZvqDbDtQ0fPSd7r7nFtiVxRI7v6mZKLGiUpGAx4A+gmNEsAT2MHoX+P65yYn34J1E/Rk
         /SNZ8QpLWm9dR3mqkBUuRi93f24YO5j1/H1kgUk71+AlAdJc4bXWGc6jvpaxTKqF/SWk
         zR2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rOVkO6h9rrRRFzaqv+uBLFrsyHj/virndC9sRVzOI7A=;
        b=TT2zZgdPaJ8iJNkS31NJ1zMAL0vk+4HSfcT8JGBa2brH6wgTBaLMSFP64q8Mn/MjJF
         TDVQqmsdG0CdlPc8wTggal6EybJqyQYvuUEY0PEdO0XrUHt0NBOPX3ysBVhwB+Ff553x
         bAHGHyOr9KW2PEPqx4Snbjl49vlnNHFuiE/sMQJEQko4dA1f0BR2qzew7EEo4uT1oxfX
         yWQce3InO/lGMKtIDLSZZOgi0pPVeJCizEl15V4a/qtEAeUIk3tTg/9hCtRwSVcC5xx3
         1LOMpl8GYA0HrYfOgaG5ZIajFbu0ruzaraCVuc3rP1tQAmpacHI/5Z0RPOmSpqOiJz2d
         RkpA==
X-Gm-Message-State: AOAM530DJYW736AsE0sWNwYiHjsxm4BxZ+lyG34Lm1BLby9uXF+pFvFk
        qOXloJbr+o/dw+Zv/jJ+YBs=
X-Google-Smtp-Source: ABdhPJwFxDJbJL1TRdkpKgwjggrP1Qje59mBiR84Diuh5XCyPz1Rh2+QTXVBN6z9/4TicikYfvmJMQ==
X-Received: by 2002:adf:bb0a:: with SMTP id r10mr7180957wrg.23.1634223727995;
        Thu, 14 Oct 2021 08:02:07 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm2738065wro.25.2021.10.14.08.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 08:02:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 1/4] trace-cmd library: Do not use strncmp() when searching for KVM debug files
Date:   Thu, 14 Oct 2021 18:02:01 +0300
Message-Id: <20211014150204.2485499-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
References: <20211014150204.2485499-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Using strncmp() when looking for KVM debug files with given names in
the debugfs is useless and could be dangerous, strcmp() should be
used instead. Limiting the string compare to the name of the searched
file only could bring problems, in case of files with overlapping
names.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 lib/trace-cmd/trace-timesync-kvm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-timesync-kvm.c b/lib/trace-cmd/trace-timesync-kvm.c
index 58c028ea..6f76fe1f 100644
--- a/lib/trace-cmd/trace-timesync-kvm.c
+++ b/lib/trace-cmd/trace-timesync-kvm.c
@@ -163,14 +163,12 @@ static int kvm_open_vcpu_dir(struct kvm_clock_sync *kvm, int cpu, char *dir_str)
 		goto error;
 	while ((entry = readdir(dir))) {
 		if (entry->d_type != DT_DIR) {
-			if (!strncmp(entry->d_name, KVM_DEBUG_OFFSET_FILE,
-				     strlen(KVM_DEBUG_OFFSET_FILE))) {
+			if (!strcmp(entry->d_name, KVM_DEBUG_OFFSET_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
 				kvm->vcpu_offsets[cpu] = strdup(path);
 			}
-			if (!strncmp(entry->d_name, KVM_DEBUG_SCALING_FILE,
-				     strlen(KVM_DEBUG_SCALING_FILE))) {
+			if (!strcmp(entry->d_name, KVM_DEBUG_SCALING_FILE)) {
 				snprintf(path, sizeof(path), "%s/%s",
 					 dir_str, entry->d_name);
 				kvm->vcpu_scalings[cpu] = strdup(path);
-- 
2.31.1

