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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46360C43470
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26FFA60BBB
	for <linux-trace-devel@archiver.kernel.org>; Mon, 17 May 2021 14:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241660AbhEQPBJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 17 May 2021 11:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241999AbhEQO7J (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 17 May 2021 10:59:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA59C08E89D
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:55 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id lz27so9455099ejb.11
        for <linux-trace-devel@vger.kernel.org>; Mon, 17 May 2021 07:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rUP8dy+x6VbSfLOd5kMRkaXxDNtZoou4qX0mjGI5Yyg=;
        b=KoEekqleQnWxxEiDyNQvC+sa14FfBUTtrwQC82umOfkE7fS+g4REsxzbHBv/LgMgZW
         lPR7VQB1VF0BeJo3aG+ZStEHfEf0YGB9xLqKJdeAHGqh34Yo/DfzmRRpiHYT8f9yKnUl
         IJNuS7dy5d7y8omU9IxvzAsd4YaZIkvc1+WWVD13uOpZh1BMsW5o99SiAYjxuCHw3/4/
         VV64U74e7wds9/RtiGqKf0hU9Nu81Hynn8tcF5WSKQUPpDbJyLrkARpqD3CUmSjlBAr/
         2+q0nLGE/Q6xV31P+X87GdlchYvc/UHL66SovrzP2IBlhahyfBDKXeIogB7ymGsDcjjq
         4RNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rUP8dy+x6VbSfLOd5kMRkaXxDNtZoou4qX0mjGI5Yyg=;
        b=jJjsrBwx9xeMxXObx8sei3drDtnhJNywFy1tVi7B9AhFDzEDbSRmFwy+8gatifRfRv
         sgCYoa3bwPlz4MLMYOwfUvsQO9MI/FTrLVNZ8qsct+qWzyrFXBKilI2lKIo09yNcBcq2
         empBGpoDdY+cJ/3sIAgh8Hfyfa69NLsCtjaEkVl+QM5p4cuo8yKaP9EHft+WYVyHr/JM
         aVWX5oPTUPtsySpp6wMDmJvoRGGuqnuc71X3eGnGiddy4l1M8ubXRwiSqvkUlEOrwPXj
         KwAjeIMD6bgJssm6TMNjNInThgvp8Fk1VP4aZRc3YSYSNksdNqZ5wWPJcNebm3fTNo2a
         ZM3A==
X-Gm-Message-State: AOAM5320E9jbGlv3kV/JuYjKPxC/JjeGiFWVQ2IKqlvugspwBlKI0IUq
        jucv0ND9jlrTt2qqvCwzIAYghqo8MMs=
X-Google-Smtp-Source: ABdhPJy5j15qU8bnT4ZiO7M1ASDGW0XN0zpestWZXg+iLBBRPNgaROjJ5027zJCq3xJ40JvQF45PBg==
X-Received: by 2002:a17:906:e0d5:: with SMTP id gl21mr157052ejb.93.1621261314570;
        Mon, 17 May 2021 07:21:54 -0700 (PDT)
Received: from localhost.localdomain ([84.40.73.151])
        by smtp.gmail.com with ESMTPSA id t2sm8484849edd.58.2021.05.17.07.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 07:21:54 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 7/7] kernel-shark: No slash at the end of KS_PLUGIN_INSTALL_PREFIX
Date:   Mon, 17 May 2021 17:21:40 +0300
Message-Id: <20210517142140.286153-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210517142140.286153-1-y.karadz@gmail.com>
References: <20210517142140.286153-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This trailing slash is redundant.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 94023a8..cef6f05 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -111,7 +111,7 @@ if (NOT CMAKE_CXX_FLAGS_PACKAGE)
     set(CMAKE_CXX_FLAGS_PACKAGE "-O3")
 endif (NOT CMAKE_CXX_FLAGS_PACKAGE)
 
-set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins/)
+set(KS_PLUGIN_INSTALL_PREFIX ${_LIBDIR}/${KS_APP_NAME}/plugins)
 
 set(KS_ICON        KS_icon_shark.svg)
 set(KS_ICON_FIN    KS_icon_fin.svg)
-- 
2.27.0

