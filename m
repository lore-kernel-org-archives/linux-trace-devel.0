Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2ECC5519F
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 475EE204EF
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:51:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dFjKZfpJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbgKTJu4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Nov 2020 04:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725809AbgKTJu4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Nov 2020 04:50:56 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA96DC0613CF
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:55 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id lv15so6163676ejb.12
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Nov 2020 01:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZwXt6FGkMado1PkmeQhps3dwntOjYmm1TkCEXK//Y0=;
        b=dFjKZfpJweCVROf1lDKK6sLpvTqhMRHblqlGEl54FAEC3zReXDP+IWBqPSfg9ldaZo
         SmK1cR0nQ4fcs9PSuA0RUq0lVytdkKmM4iYAAIpnSpzAfYgiqMHaRYI6/fDutTYfnRHk
         yNg8Z3Ef+91nSNx9IaSZ0OAsamEdTjehfzsc8Oasx63D9nt34OOTf10+cOLosvIPR8NA
         0uLeqj3Tt+w0B6xt+8A0xUrv0Ja5vT7ESZxyb+89QWC0QhhQnbSdYC2JeZhTFc8XxAfM
         qI21+Yc2q0//icXx/paQjuSAvp7mrLPuUwcE8hUcOOUkNHlC7x0wKmV6cJtFLO+MkHwj
         /FrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7ZwXt6FGkMado1PkmeQhps3dwntOjYmm1TkCEXK//Y0=;
        b=Kb2B7BfyS930p/K9QVC4ForSrfx6Asor+nr+ipufrBAWVBOH/Hvgh35vabzJKKe/Np
         bZIhTuP+/+5Foap1HH96aLWBYNYE89xNaCJHtzI8+w075QOaEEmem3tSdlga+mHmrGD7
         9HMYT5YpS3kR/maa7IRpQziqEGhffkKZh2094X8awTGC9424m82ACqwZHVCl9U/g85Wi
         CWzvoqnNyca61LweUr3PpCdsk/8pqQedzJr1lf9AaSbeSz4pbuY0kbDVOw4GqPHrxcka
         YbSqHZIbgMofXfpkr+rZU6oORmx2y/d/8UwHgiz6I+3Mt/VzcgQnbe3EyEwa9Ncy1IOj
         1q0A==
X-Gm-Message-State: AOAM5332RnFjca85fmMszxJN5zIckwnphB31pUPuCAVZM0QFgiR5NDZE
        90bpl/ea3Ch11wv0WPE9Dwg=
X-Google-Smtp-Source: ABdhPJwvqz9lNw3hTC0EHXZCS751Nfxx5aPXrf7YXBQuaunqMcXsqIC5e/3z4VObuuogrj+t/KqUsQ==
X-Received: by 2002:a17:906:8511:: with SMTP id i17mr23916625ejx.481.1605865854492;
        Fri, 20 Nov 2020 01:50:54 -0800 (PST)
Received: from localhost.localdomain ([84.40.93.58])
        by smtp.gmail.com with ESMTPSA id e17sm861995edc.45.2020.11.20.01.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 01:50:53 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/4] Upgrade the OpenGL wrapper for KernelShark v2.0
Date:   Fri, 20 Nov 2020 11:50:27 +0200
Message-Id: <20201120095031.271735-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch-sets contains one major improvement to the OpenGL wrapping
interface used by KernelShark, that is the capability to draw text to
the OpenGL canvas. In the same patch-sets we do few other independent
small improvements and optimizations.

Steven,
Please review carefully the first patch. Check the new code in
src/libkshark-plot.c, but also think if the addition of the public
domain header file stb_truetype.h can bring some licensing issues.
Also, is the reference to the original project good enough?


Yordan Karadzhov (VMware) (4):
  kernel-shark: Add support for drawing text
  kernel-shark: Make GLUT optional dependency
  kernel-shark: Add ksplot_draw_polyline()
  kernel-shark: Optimize ksplot_draw_polygon()

 CMakeLists.txt                   |    6 +-
 Documentation/doxygen/dox_config |    1 +
 build/deff.h.cmake               |    3 +
 src/CMakeLists.txt               |    8 +-
 src/libkshark-plot.c             |  305 +-
 src/libkshark-plot.h             |   73 +
 src/stb_truetype.h               | 5011 ++++++++++++++++++++++++++++++
 7 files changed, 5366 insertions(+), 41 deletions(-)
 create mode 100644 src/stb_truetype.h

-- 
2.25.1

