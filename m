Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CC2C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 20 Apr 2022 15:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241579AbiDTPlc (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 20 Apr 2022 11:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235881AbiDTPlb (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 20 Apr 2022 11:41:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9924578A
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:38:45 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id e62-20020a17090a6fc400b001d2cd8e9b0aso2361057pjk.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 20 Apr 2022 08:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+TU6UngstTBnNiJS/CVSx/6fNCfacSVn0RjRmuk+vw=;
        b=hxjubpSeLg/E+aRdO4xAP/5pmeN+wsXK9uzD9dYOgaxgRPjd3jnOq9MJglUPtBV2JK
         Syk9w4pIkxB0gZ1OLWa7hDl7T5EQD656KiKOQ2NivECjhHW7BuxPR73/YIaGRGe1+VNh
         fj7KXLaqApdZGKBcib3D3fKR8nKiI1fV+5oE943cXN0zychGdRZsH//Of2ayyI5B/jFl
         V1ewDOMEgE2cOy8MZF7kyzP/Sz2r4zgqh9VZfRrjiX4ehGNNT6fl5TSfd+WF8YNafgKq
         aLaoc7xSqDU8U4hSDXr4n6/BymrzJ1P45E0MSvABzPrei3uistEAnGOL6q7AhTJC+fJL
         i+5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+TU6UngstTBnNiJS/CVSx/6fNCfacSVn0RjRmuk+vw=;
        b=dZ7WrTsiK1/oheojXrGDamR/LFchLwUSn3pEJgjW9UEn5Du2SItwHg7m6KrOFToNxa
         k/vkQB/PAlj10CFeKPsfCF/M0/YOEUa0WWHfZd12myG9fSFLz1RrrpVlQCI4wCcduWiO
         GE5+oNbt58apGGYVJ1ROB1pQmnaNtZX9LhO0masc5NvDLISLq1vr82mTHKuY0DMs9mZp
         AcIxRZ9iHmD+0TDl8au7fcvHh0vKv5244kIhReS1z9h3L7OmlSWn3jgQl7P7rWdVTPhh
         T00lSwDBtJX0YuGrsuYryw5fjq88Wi0mpy1zytaCQRrqpkzAdPhrm3lta/dSLqCvUG1R
         n3Ig==
X-Gm-Message-State: AOAM531uKTOjR6rt03+7ZtaJaqvY4xvg7brPgISHI65tTK/QuDMUdlHh
        H6o6rXHNlBf2vRp01jcMfGsP9nSN2kc=
X-Google-Smtp-Source: ABdhPJyB755he81pjaSaPpObrwS8zFFKXgVaMuq5tnFPIq2suxE6LkrdCbdPjIq6d0sLMue0wOxKsg==
X-Received: by 2002:a17:90a:930b:b0:1bf:ac1f:6585 with SMTP id p11-20020a17090a930b00b001bfac1f6585mr5159434pjo.88.1650469124616;
        Wed, 20 Apr 2022 08:38:44 -0700 (PDT)
Received: from localhost.localdomain ([14.100.48.186])
        by smtp.gmail.com with ESMTPSA id ay13-20020a056a00300d00b0050a5af3fbc7sm15296534pfb.220.2022.04.20.08.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 08:38:44 -0700 (PDT)
From:   Solomon Tan <wjsota@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 2/2] kernel-shark: Allow FreeSans otf in addition to ttf
Date:   Wed, 20 Apr 2022 23:38:27 +0800
Message-Id: <20220420153827.637413-2-wjsota@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220420153827.637413-1-wjsota@gmail.com>
References: <YmAkAE+5wy2mLncD@ArchDesktop>
 <20220420153827.637413-1-wjsota@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

FreeSans comes as otf rather than ttf in some cases. An example
is the gnu-free-fonts on Arch. With this patch, both FreeSans.otf and
FreeSans.ttf will be accepted to make kernelshark.

Signed-off-by: Solomon Tan <wjsota@gmail.com>
---
 CMakeLists.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index 5473bfa..3a48b0e 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -59,7 +59,7 @@ find_package(GLUT)
 
 set(KS_FONT FreeSans)
 if (NOT TT_FONT_FILE)
-    execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep ${KS_FONT}.ttf | cut -d':' -f 1 -z"
+    execute_process(COMMAND  bash "-c" "fc-list '${KS_FONT}' |grep -E ${KS_FONT}'(\.otf|\.ttf)' | cut -d':' -f 1 -z"
                     OUTPUT_VARIABLE TT_FONT_FILE)
 endif (NOT TT_FONT_FILE)
 
-- 
2.36.0

