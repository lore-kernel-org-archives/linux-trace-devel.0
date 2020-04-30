Return-Path: <SRS0=Wcha=6O=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F229C8300A
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AAB42076D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZMBS9YY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3MW2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726500AbgD3MW1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:27 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8362FC035494
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:27 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id g4so6275460ljl.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 30 Apr 2020 05:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdkWimkB5wJaK2PzEmrF786jnABOUHLlMtgQIOLH3Oo=;
        b=CZMBS9YYsoTDwT+KUhUrZceHrakI2tk41Wof+WHoMqNNuJkeQPru9b4YrTylqP82Q3
         ttprY6fxkVcklysRbBFObTEODGo/gkkUBfnjiZYdnYopJuidg5fT3KL9797sbPPRTy3u
         F7G+klzEpdKikYKHjsohcw8dyuS6Xq3gxKsalyom4mN3w+G5n67Q7ENbr+V9l6ECxyI8
         KDW1B0W10rcR8VLouj7FaZJ9NO9SJqkIGXRhfHmV6+WGPtR7xVNiY2jGJHkhJJjTTsN+
         PlFKQlIhvCNY6l52jqrJWUpbvlXRXkxRmxrnwkLxjUhHy8s6P747GZgTryuKldGl5jYT
         1mjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xdkWimkB5wJaK2PzEmrF786jnABOUHLlMtgQIOLH3Oo=;
        b=cTCpToc+rK3LJwUcFOhDLksNCESKsFp+LTREHG1tM8OwNfxCaCH8T4kgzojRP1sazo
         OvFOo9mXcicp9FolbDh8Rw/cPO/sw0J/4vZ/fbJyNfprl7E+e+r/2dHt+lbnCb32HAy2
         zuvQ4/Ilc0negU9HCWA9qF6XVxdI23ILCU4c7H/aysVVm15DDrKV97IZ48oyQGr+Hmc0
         L69KfSWc/TyHT/Du+fwea+30CSNwMCXMWkQillG/LfJ3prInIWY2QCsWVOvEku1Ci5Wy
         TWP1vL/StJcehE5uHjjPvKYdhMQGejU2ixiYOebxSzBKJB+yQv0GYiV2JVujdAKXYNIQ
         GsUA==
X-Gm-Message-State: AGi0PubCsDKh3KLUWv744gVX1zWGpA/dLSosO2h8sBrwFd43KNsFIB4U
        Uwy0E510j44+BpTAIfGXtP/Nysddz3A=
X-Google-Smtp-Source: APiQypJCPMaN0IWyh278uphK0wuvw6NJEGvPX9/PdpmGuBvfPsGj8gbyHqqIesELvpW8j2aGUVJayg==
X-Received: by 2002:a2e:8999:: with SMTP id c25mr2090295lji.73.1588249346054;
        Thu, 30 Apr 2020 05:22:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id a26sm4793168lfl.66.2020.04.30.05.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 05:22:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/4] Few small trace-cmd fixes
Date:   Thu, 30 Apr 2020 15:22:18 +0300
Message-Id: <20200430122222.101276-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A couple of trace-cmd bugfixes, good to have in the next trace-cmd
release.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd: Fix trace-cmd report crash while displaying trace.dat in
    specific use case
  trace-cmd: Add "main" in the output of trace-cmd stat when displaying
    main instance
  trace-cmd: Create ftrace instances before using them.
  trace-cmd: Do not try to update parent's memory from a fork()-ed child

 lib/trace-cmd/trace-input.c |  2 ++
 tracecmd/trace-record.c     | 38 ++++++++++++++++++++++++++++++-------
 tracecmd/trace-stat.c       |  4 +++-
 3 files changed, 36 insertions(+), 8 deletions(-)

-- 
2.25.4

