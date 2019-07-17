Return-Path: <SRS0=BCkm=VO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE09C76192
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0AB02077C
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Jul 2019 08:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MjqvzOIV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfGQIxg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Jul 2019 04:53:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54832 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfGQIxg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Jul 2019 04:53:36 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so21266507wme.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Jul 2019 01:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3GT1b5uvh7uZiyHBocSd/6MDhzcL8hqUa4RJ2qQG1E=;
        b=MjqvzOIVMWwCg/Y243ooC5bODl0y8MskpCD9mnEyKUGOkUOrN6m149g12O+Hb8RsE+
         3HRWfhot3GHKeyV0cZ8Cg9Dv7YDz55FN+mUR6H7vS2gLOPea+GHYaUGvoAO77PUPuGMt
         yy8BHgHCqyWnlNySbfBdNGEZAIRLRBXu5ZLOLF35wE9y67EcbfdnGPKu00yUjLhJ30q4
         B31ym2HyRtJ8y0lAnIm5T1wqgUz5PWFcl590W8FtZFunOi+jaPQrfZKNCPR5n+d8+pCJ
         mg5kvccQc0Ip5YyGJ+NYXDc+/8loTqI16/lgyPtnRKCoFDAgu1PvEULDE0nyTjfW1ePT
         C8lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b3GT1b5uvh7uZiyHBocSd/6MDhzcL8hqUa4RJ2qQG1E=;
        b=pL34y1EquBtHjGENL7SXPypwn195682rsGCkMJLRoNhnVhao2CxrSyhurmuBJo7ta8
         6x7w1YOx0aVd4LOS7d0fqEp08p8Z10n2A4f6mgzntLP4spwst+e/6kDB4KY9NUGFRy6a
         ULeolgcVBteq6U9rYr2mNOlSxPA6l/uvKlsp8UsO8qAzAcoOAwlhDmoYGpu6kIsUsyGs
         cR2ciBh4SvDNGYbvoJY19LBpWjvx7vQFUPZWUoda6ffPZYxgyqKjkgqIUf9rMd2U+Y6F
         /d0h2MFYRxJWqwSn4Ts+HYpx6SRFID1WGpAUb8bOVvHF0zDGWvob49wQJ3bevgZ126M7
         Nc8w==
X-Gm-Message-State: APjAAAUD2OTcesrwJmqIXnPWo6nsrAin3hrVRPqP3Sbthf5MNrIQf/qS
        k+nn4GvbaScYgCS9ijb9UbM=
X-Google-Smtp-Source: APXvYqyAxQmPW/KQ4FEpNlBzUPJ0SUyRLpI0Gudfv9kL+t/XUiF4RMqGpmQKs0ye2kf19KvIRLzfZA==
X-Received: by 2002:a7b:c933:: with SMTP id h19mr36589676wml.52.1563353614627;
        Wed, 17 Jul 2019 01:53:34 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id w23sm24102127wmi.45.2019.07.17.01.53.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 01:53:34 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/2] Fixes for KS 1.0
Date:   Wed, 17 Jul 2019 11:53:04 +0300
Message-Id: <20190717085306.12393-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It turns that there are number of ways to crash the GUI if you click
buttons or play with the mouse before any data is loaded. This patch-set
tries to get this fixed.

Yordan Karadzhov (VMware) (2):
  kernel-shark: Initialize the data-related fields of the model
  kernel-shark: Always check if data is loaded before changing the
    graphs

 kernel-shark/src/KsGLWidget.cpp    | 22 ++++++++++++++++++++--
 kernel-shark/src/KsGLWidget.hpp    |  2 ++
 kernel-shark/src/KsTraceGraph.cpp  |  9 +++++++++
 kernel-shark/src/libkshark-model.c |  3 +++
 4 files changed, 34 insertions(+), 2 deletions(-)

-- 
2.20.1

