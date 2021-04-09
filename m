Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E16C433B4
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C22606115B
	for <linux-trace-devel@archiver.kernel.org>; Fri,  9 Apr 2021 18:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhDISEx (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 14:04:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhDISEx (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 14:04:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F26C061761
        for <linux-trace-devel@vger.kernel.org>; Fri,  9 Apr 2021 11:04:39 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n2so10012403ejy.7
        for <linux-trace-devel@vger.kernel.org>; Fri, 09 Apr 2021 11:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxIpEl01Oua2BDcfzFHYtDQdMzrpgCFriF6Q4LHBp0k=;
        b=TBRiEhD0qoLArVy2N7Tqx+2U8EOIGQvP157QJ7ctBnNynzZ9z3KEienngYUzIoCbHc
         wLlN1q1U9dsgF/KsSh5iQkpt4ymj85UB1qzA1pLtWw92QbkcC90f1ZJsBLaS1evhTn8O
         q0oBGs3PUsG1cpokdridRpwmIv/Z9PoAKnjz5Y8UJGiUkTo80tLAJbbIwchsm1gpbF4O
         h4MrTopwgmKE9UBAwU4PIUi+btKWbxWQt79pUKLnDQwYhmkkOB+/68P32tPRsgclLtkE
         ChPgcR0SouyCTdR/61gQ6N6Csjj8x5urCD3SB/XMoYTMjKrY6ERy7UgWDhHl5vTOAJZx
         nCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lxIpEl01Oua2BDcfzFHYtDQdMzrpgCFriF6Q4LHBp0k=;
        b=OclLl/O/JdfoVfOhiy/f4z8CEthQJFoD99MTbuMUqX3F6W15Auf9mf1lHYDtelG1G9
         7L57frM/SX2eN9/Fev1sbu5hAPlIOZHriaFw5u7VCqHBsemJTyTzPva12MMIFIS8Tb8C
         ja+i/2SHABXTHeM5LbQLttMkSGexJHNZn5bS4ZDxNPbocR7QwsK3OzedrbDDgTe5iXbx
         dN8W1JWpXrIQ6BDrsekfXKmZd2hULUd2aXkkw84R3BvP4UW86/kq/NjOaNPlJxEF6yqW
         VmHpr4cLYZsRSCcpABwZpVauVX8TC/JWWNHDRtollju5/p4m2SNX0CjTiyRJoaHIAM/F
         WC6w==
X-Gm-Message-State: AOAM530kcTRkM6WEPvM9r2mUkCUHv8/AngZhcan20gYYvas/TMxEP/WS
        ciCn/SkP3Jn9u515ylsTObK6PIdkkmKP0w==
X-Google-Smtp-Source: ABdhPJy6dA3T9SGH644WJGBXiXerhaJB6kOeE+oxbkYuYlGEVkxzHsaDzKeCE9grbn65drjbH9Z0ig==
X-Received: by 2002:a17:906:4407:: with SMTP id x7mr16988834ejo.546.1617991478370;
        Fri, 09 Apr 2021 11:04:38 -0700 (PDT)
Received: from localhost.localdomain ([95.87.199.133])
        by smtp.gmail.com with ESMTPSA id b14sm1865568edx.39.2021.04.09.11.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 11:04:37 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, tz.stoyanov@gmail.com,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v4 0/5] Refactor the APIs for tracing options
Date:   Fri,  9 Apr 2021 21:04:18 +0300
Message-Id: <20210409180423.72497-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Yordan Karadzhov (VMware) (5):
  libtracefs: Fix issues with tracefs_option_id()
  libtracefs: Modify the arguments of tracefs_option_is_set()
  libtracefs: Encapsulate "struct tracefs_options_mask"
  libtracefs: Option's bit masks to be owned by the instance
  libtracefs: Rename tracefs_option_is_set()

 Documentation/libtracefs-option-bits.txt |  10 +--
 Documentation/libtracefs-option-get.txt  |   7 +-
 include/tracefs-local.h                  |  12 +++
 include/tracefs.h                        |  11 +--
 src/tracefs-instance.c                   |  15 ++++
 src/tracefs-tools.c                      | 103 +++++++++--------------
 utest/tracefs-utest.c                    |  12 +--
 7 files changed, 81 insertions(+), 89 deletions(-)

-- 
2.27.0

