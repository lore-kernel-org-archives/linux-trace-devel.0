Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F10BC433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 27 Jan 2022 06:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236464AbiA0GQ5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 27 Jan 2022 01:16:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236498AbiA0GQ4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 27 Jan 2022 01:16:56 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C772C06173B
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:16:56 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b13so2249135edn.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 26 Jan 2022 22:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZ7Y7jXmpp++naujOL14o+yci/xw95CMdiiE3LGJAV0=;
        b=IoGeNgnXQ6US/IYByb7dqFA/ciScFl8eh1RQFZ9YCZAOaXx/AGtiEQNfpQwao1aJxA
         mJloMUtB482ZsBZPx5rpw9LM+VdohtnyKPl7/qbajiXv1fyN1qIJ57nLPcW2gAwolHfo
         bON+xLB7QGKI9zmV404MTDv4a5P24BVxkgOFoMmvQEJDWOqeW70dgHWitSfGYFq4r6hs
         Zn0cqaNvc2030nwDoCwZNmR2UD/iksVOl0LHQrITGtO2wbWK3uNoTlGphmfZmR1gnoPc
         W73yOxTmzTBN0mKbdD051ekIqDdAcogitT+W6fHd9d02BRaXLX6mX/kGoQ86hiYV3IXI
         mnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SZ7Y7jXmpp++naujOL14o+yci/xw95CMdiiE3LGJAV0=;
        b=pnZPoYGApFEj/cz4sNbzp7VYRAYdKArkyyxbS1iAA72By9WoRkQWhhQ/NSZZrmvv3L
         CDBtSfjp/LQ+dXZcclodObjCaxDezyIT45IVwR8GY1O/Ng/Hz2OlgoB5gCm5F4Ak0jeq
         bhtT3zvMsdqMs9fftf4KqC0vbzHuWtaFLX8bolfOV5oUD5XXHHUBMUFLHpTQ00HWNYTC
         3k43TniDTkuoxfpEZW48FWr3A7lFCD7Ul/VrWKqzOnPJaWMkzU3XN9QvugMVV0prBVyb
         Pufu6ewOCtXJVhthAaqR+CHYPRKpT5O3hscGeSs7/j3dy8F9adoUcHNjzoYu1dP8qo6c
         bolA==
X-Gm-Message-State: AOAM5300UO8hnUoodt+71HFJ5ZOzeKkDubHpzapBmZJUoPVWUIesjfwC
        DhyzLrn0iCVohTaqSGGIqLCM7+kfueY=
X-Google-Smtp-Source: ABdhPJyOMdvgZzMJ5SrAam9/Dr6vx4IRQ5CrljhUFDgSYB2uJGGYqbFuPklmgNC/md6DwF8c5T4oyw==
X-Received: by 2002:a05:6402:c9b:: with SMTP id cm27mr2277026edb.100.1643264214906;
        Wed, 26 Jan 2022 22:16:54 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id rv28sm7847731ejb.71.2022.01.26.22.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 22:16:54 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cruncher: Update CONTRIBUTING doc with tests
Date:   Thu, 27 Jan 2022 08:16:53 +0200
Message-Id: <20220127061653.23426-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

All trace-cruncher code should be covered by the unit tests. Added
instructions how to run the tests in CONTRIBUTING document.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 CONTRIBUTING.md | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 1f73807..7f6c5af 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -20,6 +20,11 @@ The preferred coding style for the project is the [Linux kernel coding style](ht
 The project follows the conventions for [submitting patches](https://www.kernel.org/doc/html/v5.4/process/submitting-patches.html)
 as described by the Linux kernel.
 
+### Tests
+
+Make sure that all your changes are covered by the tests. Before submitting your patch, make sure everything works at 100% running the tests in **tracecruncher/tests**. As trace-cruncher interacts with the Linux kernel tracing infrastructure, the tests must be run with root privileges:
+`sudo python3 -m unittest discover .`
+
 ## Reporting Bugs and Creating Issues
 For bug reports and issues, please file it [bugzilla](https://bugzilla.kernel.org/buglist.cgi?component=Trace-cmd%2FKernelshark&product=Tools&resolution=---)
 
-- 
2.34.1

