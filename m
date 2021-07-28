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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D8FAC4338F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B1AA6101B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Jul 2021 13:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236709AbhG1Nd4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 09:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236706AbhG1Ndz (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 09:33:55 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407A0C061757
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:53 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gn26so4676291ejc.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Jul 2021 06:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PMiuWR4N6LgPZuSqUWJGi09003tT5J8kWKShbX5hD7A=;
        b=DnVJyKCFXCE4UZILoDGpyFp1Ja/7Z7umuKX0eZRDcamt+uz7IwhjMTkkRQ9y58CfhV
         xQWhOw6T0duMgL2tUbbuei+C+FjMWH9qluwrZ0X3RxjCSRVzXYEpZn07dXmTPiH+wLfH
         LXU0739LXrQETDQ9VdILlftKS6nWwwnZfbmRuz46CylO6aZIK+1IAbHPBsIsXsTMURPI
         2vW81NndBwX5VQ2Ys7ZY7ErC+R1GvLXU1UzUEkCsbSI7euOU8OvF08dirBQU4qz9a8WA
         tPJ+NcRWRTUQLHYcPpSpbMxp4aTvOoQWQiHyGKg9McvLondj2dx4WhcopTtonRuK2Guy
         wDnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMiuWR4N6LgPZuSqUWJGi09003tT5J8kWKShbX5hD7A=;
        b=lg86FzAdK37lf6Wy7FDLSwz8c3pdUT9YxotUqvyn4qtyFhinlG/NyE3j2WkAd/9FbS
         mxjpY46mupYh1gDtXswMPh7uXam4Z7A4DBh/1WPWYq6q/yLQ3cRGbY/sJUS/QllfvPjU
         6nXmZTr9u5H3GBL8KPvh/HOtYcqVA90Jv2BJFEIG0YWAmcd1J2sKGrkArKvca3YvpDcM
         pOEsvfrWZ811z2xSjsEMz4FyUtQXsbFSCyXkMXrT24BTSR6AGtJFIaC/BDrSBIq3xQag
         w1Zk2XpUjpXc+U12NfZCruZAZsjWbOgaOVTOXy4rXnzdtT4TUYxw0hC3+uhWPcRVfaPv
         o0Pw==
X-Gm-Message-State: AOAM533r/eP54Uldn5QTQEAcuh8gcQuFnIk+ZvdxtzlkSek+EQRBBFSi
        AqGUrQWS/rnr9uiEkxKxcQE=
X-Google-Smtp-Source: ABdhPJyQ1YgjvkQ2Sewu7E6jjbXYFvxMDQUlG2cOxAeVflTo7TkcXmeDNzrFoEr70wQTMjcVj9pyZA==
X-Received: by 2002:a17:907:98c1:: with SMTP id kd1mr12882363ejc.51.1627479231878;
        Wed, 28 Jul 2021 06:33:51 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id b25sm2700705edv.9.2021.07.28.06.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 06:33:51 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 59/87] trace-cmd report: Do not print empty buffer name
Date:   Wed, 28 Jul 2021 16:32:22 +0300
Message-Id: <20210728133250.234140-60-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728133250.234140-1-tz.stoyanov@gmail.com>
References: <20210728133250.234140-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In trace file version 7, the top buffer is saved with its empty
file name, string "". When displaying it, filter those empty strings.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-read.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-read.c b/tracecmd/trace-read.c
index 6384e52b..3ebf580a 100644
--- a/tracecmd/trace-read.c
+++ b/tracecmd/trace-read.c
@@ -1175,7 +1175,7 @@ static void print_handle_file(struct handle_list *handles)
 	/* Only print file names if more than one file is read */
 	if (!multi_inputs && !instances)
 		return;
-	if (handles->file)
+	if (handles->file && *handles->file != '\0')
 		printf("%*s: ", max_file_size, handles->file);
 	else
 		printf("%*s  ", max_file_size, "");
-- 
2.31.1

