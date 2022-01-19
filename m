Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35475C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 12:02:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344583AbiASMCm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 07:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240915AbiASMCm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 07:02:42 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36171C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:42 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cx27so10233656edb.1
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 04:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYkvkAfCeBO1Z1Xf6ZhBotUcYaaknuO+qIbFsKZ1qgo=;
        b=iNaYNuu2wSf4f8MBToN2EfQquQvRnzLoBjAmr4hQ2iCy1Te/KtXTL1/pVfetR12EAK
         3WrIrotcEV8R785DkcVxP4rPlzXuoZy1aMhsBO8Ra9J48MLfTc6K23HM3JjmwZ72R11b
         Sguv6M/fW3klpk556uaV27zhs3tIJvu8OV2VD2AxdX4BymDVR5moQbclQHyakSm86bvj
         TS2XqR0XKz0sBgYMUwRdL2L9fR2pYAgtXmV1UATnElWPFR5BPfY8Yuht8vi6qBYg9w73
         AwGAy/po3Ht+C5w2UVCg8oMkur05akw1jvLuL57IlIo946KIjE4t/hMpMeZvrCMr7/rR
         +4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pYkvkAfCeBO1Z1Xf6ZhBotUcYaaknuO+qIbFsKZ1qgo=;
        b=ZIQf279kPYiyJIczyQBG7e2sMYUh1Csc/88C+q7Bs81dzFrEhM0Qia/h1UkBZY8Qmf
         vYwx2nzuzDfek0fVp85a9r97jwHO1W+KTKMnrnNuzn5YedOltfD1JG8sK5wVzUnY7sdr
         95H/W4Aw5qP9SoXuHmU7JVf/FXxJn/txnsFg56xpOeXBj/af8e08Z/cHqMustaat2pIY
         44mfl4OuvsJhE/bUlFGGM9wlHIZlc4ZnIo+YvLsuI4Qzyhmw0k0WpRLz/oiSlCyWlbme
         4Vrv32T5YpkdLPvvOqf6H+iPGHMXSEVII5utZEDrakZ0ZW0PIYzFwb+TVKnSQYU2EL/J
         E/Rg==
X-Gm-Message-State: AOAM533t5le4QB4A5E/ptM0Lmxwz9nqNBquzRyh67kPnSRKCqY1E64xp
        ckQCTDpxNTu+g0ZvPLNN9OKUfL8CrUk=
X-Google-Smtp-Source: ABdhPJxpwf4U+l1/DNvF4oo+PdoxxuBoxV1LXpvYmdTtp65zwN9Sd24qBI2wdvEDGtFq+i45SQKrSg==
X-Received: by 2002:a17:907:6ea3:: with SMTP id sh35mr10025862ejc.497.1642593760563;
        Wed, 19 Jan 2022 04:02:40 -0800 (PST)
Received: from crow.vmware.com ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id d10sm569491ejt.55.2022.01.19.04.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 04:02:40 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org, hongzhan.chen@intel.com,
        jan.kiszka@siemens.com
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [RFC PATCH 0/2] Allow GUI plugins to build standalone
Date:   Wed, 19 Jan 2022 14:02:27 +0200
Message-Id: <20220119120229.68627-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Hongzhan and Jan,

I tried to build your plugin standalone and I realized that this is
in fact not possible due to some missing header files. This gets fixed
in the following patch-set. I also made some minor modifications in
the code of your plugin and will send you this modified version of
the plugin in a separate email. 

Please let me know if you find this modifications useful or not?

Cheers,
Yordan

Yordan Karadzhov (VMware) (2):
  kernel-shark: Add KsPluginsGUI.hpp/.cpp
  kernel-shark: Install missing headers

 src/CMakeLists.txt         | 12 ++++++++++++
 src/KsPluginsGUI.cpp       | 27 +++++++++++++++++++++++++++
 src/KsPluginsGUI.hpp       | 22 ++++++++++++++++++++++
 src/plugins/CMakeLists.txt |  4 ++++
 4 files changed, 65 insertions(+)
 create mode 100644 src/KsPluginsGUI.cpp
 create mode 100644 src/KsPluginsGUI.hpp

-- 
2.32.0

