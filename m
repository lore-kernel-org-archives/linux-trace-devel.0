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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6873DC433E9
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B4C364EA2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  1 Feb 2021 17:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhBARZB (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 1 Feb 2021 12:25:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhBARY5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 1 Feb 2021 12:24:57 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1979FC0613ED
        for <linux-trace-devel@vger.kernel.org>; Mon,  1 Feb 2021 09:24:17 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id g10so1516569eds.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 01 Feb 2021 09:24:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmVcXJgUz0miHehNivT+tRvOfOrwtVKDeNmjrBnSb5g=;
        b=II4A0WqeN7FDhjZDv8LSKb0Wq6hNZKw2f9Di8wk1qu58eoLPlis9XcGDrXvEmkzdVN
         vPn4y3qfk9dnZ72x9Ej7S+GMcPJuC34jKN4fR9KT4P+HAdiR8rMBdr/yIbJnYfWvOkn2
         4/ffP7nHMKv/X+JfhaNqfM5FjdwrTVMvmJeNs9DPzQ+FCrT+hoWVFrRmC0roy5tQIQZJ
         uhDPgxC9+zyEbeVZQcxkzV56dIDDL9rlIjE72RggTqNE+EH39Cehz60agoee4awJZPtM
         p7zC6cElqHKB12rzhITYTVXgrJ4y1iUED2paxlpIdc7JU1rLEtUKNwHar/FM7Hsh/tBT
         odBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmVcXJgUz0miHehNivT+tRvOfOrwtVKDeNmjrBnSb5g=;
        b=aAHT5PDU83MBr5JN7QUfr8591WiezH9FrLCt4v1Fkmn1oK1aJTGrBxBux9kl93fZmB
         P2l6puO9eQvHKAjajTcpT478h5zpGpaewxu0rMCkKnG7ii4YM5xFJUFnWI2lPVK3lVLl
         oOqTt3LNO93Uj5JnQUXMQ4FOQXZW0Es8LdJhOyR7LzMzmDAQBEHQEhDu4hrHxldjIViY
         n4n6/24wq2QW13b2FQfG1qR8zDHBksobB56nQNsSEzaFiyn69hYlpyiX1yx42zaaW44h
         GE8nhWqZYNR0SHFmalliag9iNy/XqyYojVuXsOgIV0wogxQ26QOOUp//0/6TKttCEd5F
         qRSg==
X-Gm-Message-State: AOAM533XAFM8Bu+TJLMN9wJifFGsR2eAZ2IDv8UvtdlJSnQ9SfA+5UsG
        ipD6HCS/rLGBcoLTFVDp1mKMjkVaViQ=
X-Google-Smtp-Source: ABdhPJyiqElxR7cDd3KBaNgoDEDl7oa41FHz8bbO+nRltbtaoVzz844k1p0czwxlToTp60wqwgi4aA==
X-Received: by 2002:aa7:de0f:: with SMTP id h15mr6908201edv.198.1612200255905;
        Mon, 01 Feb 2021 09:24:15 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id bm9sm8312446ejb.14.2021.02.01.09.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:24:15 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 04/24] kernel-shark: Fix a misleading comment
Date:   Mon,  1 Feb 2021 19:23:38 +0200
Message-Id: <20210201172358.175407-5-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210201172358.175407-1-y.karadz@gmail.com>
References: <20210201172358.175407-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/libkshark-plugin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/libkshark-plugin.c b/src/libkshark-plugin.c
index b85d0e9..bc68186 100644
--- a/src/libkshark-plugin.c
+++ b/src/libkshark-plugin.c
@@ -577,7 +577,8 @@ kshark_register_plugin_to_stream(struct kshark_data_stream *stream,
 			 * The plugin has been registered already. Check if it
 			 * is initialized and if this is the case, close the
 			 * existing initialization. This way we guarantee a
-			 * clean new initialization from.
+			 * clean new initialization from kshark_handle_dpi()
+			 * or kshark_handle_all_dpis().
 			 */
 			if (plugin_list->status & KSHARK_PLUGIN_LOADED)
 				kshark_handle_dpi(stream, plugin_list,
-- 
2.25.1

