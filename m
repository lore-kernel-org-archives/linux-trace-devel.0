Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2668C282DC
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:32:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C352920693
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 18:32:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732271AbfDQScF (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 14:32:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42985 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728373AbfDQScF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 14:32:05 -0400
Received: by mail-wr1-f65.google.com with SMTP id g3so33204903wrx.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 11:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=epYbQZX/UY0Lu2IyUSgotJ4OVZ39bFKRk+pk59tFoaw=;
        b=ITB7WFxO6qrEAq2e1Zo7pAsTcr2HhKnuBW3QVOSFkWsW1ugz/04pqzHPLISkLqQLx3
         U36ymbbQvkccd+tESEX2qurkBLXIrOAwMKhRyPrM+9CWr1AJ68Pufkji1+cplE70WwU1
         NADTYIRUkvHG//nddinut3XJVKzZIyECqb2BSfs8Qjr4GuDXr98CoVAHvBeUPL7+rvEb
         1e7f3oMDx4knXW1q6y+CdxSeVb+qoP1JP2nl5fzyTMr3YIolyo6bB06lM0K0yIgvFEeY
         XTF5dZC9qzOIvkQMrDZIWKAvlAOn0AHof9C3TI4E9tZjF7+WyD6kbm5w30xBt06YUP/y
         lKBg==
X-Gm-Message-State: APjAAAVHNBkeWZUReO6yTlMYOyfDtXRLRl4j5wvk3s5Rx+282d4wi03v
        Qp8Qlu4nZ0lXlfvR/SrQx40XsmiIEA==
X-Google-Smtp-Source: APXvYqzfJ5yWe+n+dQ+6PoMovbJdaxCXCD0VLp9GS2o4AVZnOqcVre4q6u7AGqGEbAwoW+YUBItMTg==
X-Received: by 2002:a5d:6192:: with SMTP id j18mr932079wru.303.1555525923965;
        Wed, 17 Apr 2019 11:32:03 -0700 (PDT)
Received: from localhost.localdomain ([151.251.252.188])
        by smtp.gmail.com with ESMTPSA id 192sm6090506wme.13.2019.04.17.11.32.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 11:32:03 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/1] trace-cmd: Add --no-filter recording option
Date:   Wed, 17 Apr 2019 21:31:56 +0300
Message-Id: <20190417183157.8776-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Add --no-filter option that disables trace-cmd filtering out its recording
processes from the trace.

Slavomir Kaslev (1):
  trace-cmd: Add --no-filter option to not filter out recording
    processes

 Documentation/trace-cmd-record.1.txt |  5 +++++
 tracecmd/trace-record.c              | 14 +++++++++++---
 tracecmd/trace-usage.c               |  1 +
 3 files changed, 17 insertions(+), 3 deletions(-)

-- 
2.19.1

