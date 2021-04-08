Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BA6C433B4
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3036761158
	for <linux-trace-devel@archiver.kernel.org>; Thu,  8 Apr 2021 08:09:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDHIJe (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhDHIJd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 04:09:33 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C21C061760
        for <linux-trace-devel@vger.kernel.org>; Thu,  8 Apr 2021 01:09:22 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id e7so1276127edu.10
        for <linux-trace-devel@vger.kernel.org>; Thu, 08 Apr 2021 01:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJXZQMPMG5mpzbRlUr/gK2aXA5EXyvAevH5jszP6yaA=;
        b=EyEHVwlT2lQHHCIVfcPv0IZWuKtze6Y19xTeO1LinkjCm25Y6ebZrK8S6GXn+SpPcz
         T+OzJlPmQ0fENgk6s/7Ez2CVz3Z23QL+yLXxV7qnRZ9IUehyHk7h6sFPluhbLub5pu9i
         ysdfxDVGv5LOKHLonL+FptgKoja9ycBM8y+UU45LTrjshKJaeuxBDpEyxhqP8Az1TfP6
         GvBGp1CxCn5iGPTeI4N9rxJ+ReM8OJS0BhoBm7HD2+kXYxrGsOdyVCIg6C2C4AuqpzPL
         Aei5vba5L8KMjxlJ3l5YzU1O+FqI4OM3dGIYeOnM+t6y8bFQaCtwJ7vtQsSIm0OMTx9/
         MNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJXZQMPMG5mpzbRlUr/gK2aXA5EXyvAevH5jszP6yaA=;
        b=b77mGt3z1IiwOR3sOQmWo3pZBwoKhdadG/pHWCf6gEMRGZp0c8z2Xuez+mcQxelGNG
         7SmNwobUGfQ/fF+jx9c00e2ulNkIh6WlWl3gPsQC6Gp5l67DKgFwiDDwbO3Ya6ZPA1ae
         t8BeOa9h52ers3IWPex2nv5kH/mq020NB+qwUeYZyHcN1sLqfzEXbEKx+RMSFZkotH96
         CYAZ00Z/456ckol1x++jooYtxPUeLamL95w21OJ4IOItQYsQ+RIm+p2atovQiC3q/Hlq
         fE6CuAyJhc2pL4lfped43jhcPOQTbkRAHj6recoeYmfSYFb08+VF2Qy3n7UHowjHVXkc
         dYxQ==
X-Gm-Message-State: AOAM532PWCu6cc30chrBEgbVvSEhhl0DuZFstBbNzcsWDQeO57vNpe3s
        UzBrk7rUPZWIWg3Do0RX4pOiqYb98ejxiQ==
X-Google-Smtp-Source: ABdhPJxE3DDexQzLuR38ONeJQdU1OYRkhsD78ZBnec8VLfBEiVcWPC5WTDJISKl7OWfQ9R8+EYlaIw==
X-Received: by 2002:a05:6402:518c:: with SMTP id q12mr9798084edd.11.1617869361554;
        Thu, 08 Apr 2021 01:09:21 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x1sm14009444eji.8.2021.04.08.01.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 01:09:21 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Documentation and unit tests for new trace marker APIs
Date:   Thu,  8 Apr 2021 11:09:18 +0300
Message-Id: <20210408080920.3130041-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Documentation and unit tests for new trace marker APIs

Tzvetomir Stoyanov (VMware) (2):
  libtracefs: Document marker APIs
  libtracefs: Unit test for trace marker APIs

 Documentation/libtracefs-marker.txt | 127 ++++++++++++++++++++++++++++
 utest/tracefs-utest.c               |  91 ++++++++++++++++++++
 2 files changed, 218 insertions(+)
 create mode 100644 Documentation/libtracefs-marker.txt

-- 
2.30.2

