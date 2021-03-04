Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D2DC433E0
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7718A64E05
	for <linux-trace-devel@archiver.kernel.org>; Thu,  4 Mar 2021 13:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbhCDNMT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 08:12:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241141AbhCDNL4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 08:11:56 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72AEC061756
        for <linux-trace-devel@vger.kernel.org>; Thu,  4 Mar 2021 05:11:15 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id b18so21110409wrn.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 04 Mar 2021 05:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A/U4ophKx95pc0BiAmlg5sDFwxH/i1S2XU/Bc62tdKU=;
        b=iXAOfMn687blLZQyazXNzFatasMhzJKKuI9CnSdeOEGJ+3Paqz9//6JkHf3Vb2/qCV
         XKCbq548QbXnJ/theZP65J7rEoJbcx8vT5LYRXY2ZZvTMoTEUIK4hUZ80gEJbqG3TYYf
         0fz9Z4LKYrzfsx9+/zQ6nwGHBe83rytBzKGasxiOZE/3vFdS99iiWbTVEFzcD7MLBi0/
         a1xm86XsXlBja4pzgxeS0TrvTnu6ncHiTxCljIZ4H68Etf580Y0Mr7CtOlrniWYbSCBd
         w3T+NXQICw7dJvbUR78JdeIUzfrlHSWN935D7gvYDhLc1ERsfxWYYiGxJeWZs50BF2Rf
         IiAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A/U4ophKx95pc0BiAmlg5sDFwxH/i1S2XU/Bc62tdKU=;
        b=o4ThlG06KY0urEBcZ0jE++FTLI0iprq/J/5vUx+QwLRlumv7ScmnfUYOQs0r8lMPh3
         9xTOYKc2fEb1/mz6buaqCCIPdGkOWGL4M2hKIts0F6Wf6eMUabNFG3BnCn+udcyqRyLK
         UgkgYWKVJVHUyVXDTQEzH4VxrM+bmreFr3zZCcnaRT2ABJDiPkdcTryL69HMSPT3CWTr
         h8yJISLiZOHOMwmrOwy001OLLtuZ4tmGTFfe78xuZm6aI9ro61bYgSxpW7ufhi/8DKj2
         4+hy7hMg30S4VDsybQRREArCVEgpCx5yYbMzc4BRI9hQplZjnTlfR/Z3KcZzNQuDJe4V
         Mudg==
X-Gm-Message-State: AOAM530L/IuK25++MgmYSAEkCZk+jVjrFFid5Ykn3lBfL/ameG+viavj
        qDp6ogD1veiHzkj4qOWWG2+f8LDEvveQvQ==
X-Google-Smtp-Source: ABdhPJyAN4Gu/R4qhd6Vigy1zQFNWEK+Fuo/hDF5ow/RZbSPrdWfLMaZUldkUNihm+Ia5bV0VWePbg==
X-Received: by 2002:a5d:4d09:: with SMTP id z9mr3832478wrt.426.1614863474427;
        Thu, 04 Mar 2021 05:11:14 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f16sm35250546wrt.21.2021.03.04.05.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 05:11:13 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] trace-cmd: Apply time stamp corrections by default
Date:   Thu,  4 Mar 2021 15:11:10 +0200
Message-Id: <20210304131112.204294-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Apply all time stamp corrections from trace file meta data by default.
Removed APIs for pair and unpair tracing peers, as that logic is not
relevant any more.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Enable TS correction by default
  trace-cmd: Remove APIs for pairing a tracing peer.

 .../libtracecmd/libtracecmd-peer.3.txt        |  32 +-----
 Documentation/libtracecmd/libtracecmd.3.txt   |   2 -
 include/trace-cmd/trace-cmd.h                 |   3 -
 .../include/private/trace-cmd-private.h       |   1 -
 lib/trace-cmd/trace-input.c                   | 102 +-----------------
 5 files changed, 5 insertions(+), 135 deletions(-)

-- 
2.29.2

