Return-Path: <SRS0=rfvd=6A=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CDC0C2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CC0D206D5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Apr 2020 07:22:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ODOVoIwO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439176AbgDPHWz (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Apr 2020 03:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438826AbgDPHWt (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Apr 2020 03:22:49 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F59DC061A0C
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:49 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id x23so4804025lfq.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Apr 2020 00:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B0aGOVZ8TAejorFjFuKwXmHiv8ofY1mZn5b3edSTMDM=;
        b=ODOVoIwOER98GaHZTB8/6P5390oSSzPuSaK8MUXSyokgSzXzbrnLww2ESStoygJ6Ln
         t+cjorIeZ7OhLAZ73+KqKbDv7nTdZksODqR5e7pmqgHKqSMsLUfTFHVxcPwg7ctM3AfI
         zLjp3ySTWj3k4yULTO22O4ceesCidZtMWTnEzfotCuttKQv2PRl5fWvXSz7I0O+k4xET
         37/RYhqWE/s8rTsKgkw8wNJmLNM0bbv5yncWybyKZHqTc/lax0/bltetwRBT+vfKDqoX
         fFpWI2CrGaampGzKfwNfPlJc/NNRLWPCuE6tX1Nb5rcBr7V373dwt0T+mnhyBwtp5I0Y
         yuMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B0aGOVZ8TAejorFjFuKwXmHiv8ofY1mZn5b3edSTMDM=;
        b=GBok+euDgOks+ieSkKjiPwtAaV6vMqu3lj/i64l13hA9uw5hDXZC2cJimsL0htmlbn
         Xxp6mzgTGwckkIhVex3cdaVYA63L87dPmbtsbXRw4KszPDT82vRRudLMUkKB5pY4YIRS
         UAeBuFwI3JK8QNSDNWrpMVJoF3UVqECMrdi7x9MdPSwl2OteaZ4L561XbMFNIGcJxQkq
         9Vq6NeOm53M4lPnWNVW/fv1Z2IuCTbQw/l7T3+z9fxgjbnbDJ4HpzPAOOGp7lgQJHzro
         13dKAha2jltXOMYxM0hy11ktogzSYVfBdzT9PGxMbGpRJ7nnXf1pWS1deZqRYzqZaVNp
         g95A==
X-Gm-Message-State: AGi0PuYNeNSHVeMAYH/a2Ucc05hOWZEawkCWQ4WkqreVVy/kFnph35Ay
        YsaNMKx1VWf204WTECQCeFyuB1Hmy3o=
X-Google-Smtp-Source: APiQypJ+X6uMvG03bePvjQX/8eYc6LpcqPqtFcCRg+rE5RSsPRumDtgjkFpHLd61zK9fNsbz2TQRWg==
X-Received: by 2002:ac2:4a76:: with SMTP id q22mr5195626lfp.157.1587021767306;
        Thu, 16 Apr 2020 00:22:47 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o3sm9914077lfl.78.2020.04.16.00.22.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 00:22:46 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Enhancements of the "trace-cmd stat" command
Date:   Thu, 16 Apr 2020 10:22:42 +0300
Message-Id: <20200416072244.50239-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"error_log" dump is added to the trace-cmd stat command.
Man page is updated.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Update tarce-cmd stat man page with instances list
  trace-cmd: Add error_log dump to trace-cmd stat command

 Documentation/trace-cmd-stat.1.txt |  4 ++++
 tracecmd/trace-stat.c              | 17 +++++++++++++++++
 2 files changed, 21 insertions(+)

-- 
2.25.1

