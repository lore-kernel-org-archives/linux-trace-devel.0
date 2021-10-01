Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B29EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DFE261A7D
	for <linux-trace-devel@archiver.kernel.org>; Fri,  1 Oct 2021 13:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353492AbhJANfm (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 1 Oct 2021 09:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353474AbhJANfm (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 1 Oct 2021 09:35:42 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24DC06177D
        for <linux-trace-devel@vger.kernel.org>; Fri,  1 Oct 2021 06:33:57 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id dj4so35876812edb.5
        for <linux-trace-devel@vger.kernel.org>; Fri, 01 Oct 2021 06:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HLqXcdKmx0xgq06Yv4Pii1ZryeIaB0kLwy9cp1qWRNg=;
        b=dY9m075pbKMLarqcyePg2e3TY+PZ6NFyGRltx/WECr706/xP68cK0vB3D/wnopxdEj
         LsO77crlT4zy7YiMRZTXxEwi3ag5QMkp6wSt/y4TDEITSk8dKiI/RBO5ySmjXzPAdCa8
         TXbNhMilZK2/VumAu7ynlYqoNZi/E3LKihC+BdbOL8XPB/8mXvN4fuH6ohqbSD8kNlWY
         tctSJ6Pa5e08w3VJSC2yw52AdhRn1RojKpPFl3VBFnFRDDS3bCHnxdwzS4ktijz2ctqZ
         7zaqn/GXzoyrzP64gU33WIarRikcMuN09jlrr9PxAPnfXjzeTn0xkoOu7myRENbrGJxu
         PW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HLqXcdKmx0xgq06Yv4Pii1ZryeIaB0kLwy9cp1qWRNg=;
        b=Y+XhZM/gBpgE25NS0TPPmZJ777tD25Tt6BALvRXDSNLm8zRrFxhUf3I83cjLpMB6lB
         TFTK7DS46euQApxFB37kCWwxtLjB2+36ZICUP4XXEMWXsiHks/Sz3PTBYpEGS6GPwgvZ
         CIueYl6mUFAVGLmMgNW9cuBIIQwisqFidZ0LTv0Eyt7GfZtxlydkn1LkAQVVWSIMgLo7
         xmr6/hkKYg5z8TFOWbLq2n9UVFnVVFlJwqtSUwRUYFmIHxauAs3VFzUdgoCpXlzRUT4T
         QZmhO3DD0npie2V1k6T1QtxwrgbdMHReLNFoknOHmmRb1aIMfMJTa+V+s0SUZvidBYm6
         uCkw==
X-Gm-Message-State: AOAM531bKRiV3iS60CX67O/xXiVtmFueMWOL6LfpWX5zGQZlmDmm7OUM
        N2TZFvb9ndt1FZqNhPjsoNBBMZrP75g=
X-Google-Smtp-Source: ABdhPJymINjwe+VR9dthmwDvey+Z8Mm2tKAfEhtwfsuYEF02s1jeLgcTtX/BD4obE7+ys/U529MfQw==
X-Received: by 2002:a17:906:3486:: with SMTP id g6mr6561161ejb.71.1633095235315;
        Fri, 01 Oct 2021 06:33:55 -0700 (PDT)
Received: from crow.. ([84.40.93.30])
        by smtp.gmail.com with ESMTPSA id ne24sm2993250ejc.46.2021.10.01.06.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 06:33:55 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/5] trace-cruncher: Improve error messages
Date:   Fri,  1 Oct 2021 16:33:41 +0300
Message-Id: <20211001133346.8217-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Various small fixes aiming to make the error messages, printed by
trace-cruncher, more useful.

Yordan Karadzhov (VMware) (5):
  trace-cruncher: Error on fail to destroy
  trace-cruncher: Proper type name for the python objects
  trace-cruncher: Correct misleading error message
  trace-cruncher: Proper labeling of the libtracefs errors
  trace-cruncher: Proper labeling of non libtracefs errors

 src/common.h         | 11 +++++++----
 src/ftracepy-utils.c | 26 ++++++++++++++------------
 src/ftracepy-utils.h |  2 +-
 3 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.30.2

