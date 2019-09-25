Return-Path: <SRS0=n4q8=XU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9899C432C1
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2D621D7A
	for <linux-trace-devel@archiver.kernel.org>; Wed, 25 Sep 2019 11:08:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GBZ6RXrk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404301AbfIYLI3 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 07:08:29 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39905 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730191AbfIYLI3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 07:08:29 -0400
Received: by mail-wm1-f66.google.com with SMTP id v17so4356077wml.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Sep 2019 04:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PftMYStab7hDUmSefaStno00LgM+2CuYNwg+6kDkE3U=;
        b=GBZ6RXrkjg+/t1yeaMSTeWPSwpWy0XiyqxPIkknK4B8kBM+w3j90FyDulh2AxxePk5
         djUeT7Oov0bMdFrQlOfX63wSIYSrWZPsL+cxU+zynoOyDOxaGFEsCQ9CW07Ds8jlEPLf
         Wn+cNTnHSEKp2vbcRpS3WZuRrPttIeb4fIqzVi94E4slPW975NgIlNa2/jbvyQN05v5z
         tEtgSF3TRPsArD6bjqFnhd67LAvffSgYH71yoiNPiKDy0RG76XwtbD1B/t84XXB5W4RJ
         qIqz8EP+dPaxeoTaec0DF9mrvCjbH0ppMQ5UNnnQwt9D7Hw4Ci2GE9hFQc3tDTmZ2VBy
         m20w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PftMYStab7hDUmSefaStno00LgM+2CuYNwg+6kDkE3U=;
        b=cvhbjqEWGcf6VuQGB4nJ3heGf1WacKN98BhYAgo9lASTmmJT4dvanAqpvh0aRrWAT7
         eGAFOLLjeck1DSqEpbwUomwfMEJkOGaw9qhgtFrZazD4ZZ57uP+VcLaVOT2itZfMB0ba
         vhBLBm+OPo61f/Qk/Tvtxn202/2ZUXHP6utgvqd32GQkK17Bra2UZsyZWCS7Je2awxC5
         pREkMHRGE4I0AnALPvlRTJWKxD7QAlDCbw2M/DRsYJZyAwRgjmnx3DbfE2O1Uf9VxMyF
         pmIvuwRoxHo0aPerC9Cvd51Z5T0JNLjm7/orLRzDXNtxzLXprcoLESusjOYhwCDOp0LO
         gidw==
X-Gm-Message-State: APjAAAUmO5ycxMO11u4wcdt5ITLXsTUy/gRGJXPSM2gDQUz9Rzrqxc3M
        fmeCGgnfD6zlLwkShgUZ4Grs3V9G
X-Google-Smtp-Source: APXvYqyn2mpRPjDslJ/KeU5OIx8bi82FhjM8vctCiDdVMkinxHqYqVPDLuJM5uD14bG6jhM53UYFlA==
X-Received: by 2002:a1c:c506:: with SMTP id v6mr6738979wmf.160.1569409707089;
        Wed, 25 Sep 2019 04:08:27 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id t13sm12277619wra.70.2019.09.25.04.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 04:08:26 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Reset CPU mask
Date:   Wed, 25 Sep 2019 14:08:21 +0300
Message-Id: <20190925110823.1242-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Reset CPU mask:
 - After setting it in trace-cmd record with option -M, to its previous
   value.
 - By the "trace-cmd reset" command, to its default value - all CPUs are
   enabled for tracing.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=204941

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Reset CPU mask after setting it in trace-cmd record with
    option -M
  trace-cmd: Reset CPU mask to its default value with "trace-cmd reset".

 tracecmd/trace-record.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

-- 
2.21.0

