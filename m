Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6878BC433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Apr 2022 16:10:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237792AbiDHQMa (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235287AbiDHQM3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Apr 2022 12:12:29 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D417C354D31;
        Fri,  8 Apr 2022 09:10:25 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id q6so17236qtn.4;
        Fri, 08 Apr 2022 09:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=M68ICgKbxlCQqoMVu694WmBCQEFTFLTaV3AEkmDCixI=;
        b=Q9Gj0kAoRwYdK7cO0JOjaq17WRVHTuEP1C1kRXR4lEiLmMYumyQviILD4kJPVQkCnw
         9r59eq5Ny+SKmR2SE/M/tsGVS76OuxVkddQhcjmY3BDmu2saZ0RKjLL3ga9X80RHsgsH
         IUlpbfgp1FN+ZO1/nySE6/8OXqpGWu9yR0bXqIhxCTWQC0wbhLkMo95ejSvxVFK+zaAH
         vRw3PTW93f0PquuV0qrlb1lGv6CbXx8hxneEeYVc9YdFBf4vFdCS4X9YM+V7cjRfPujt
         fF27Mq2DTdt76bucF+lJH6FcK7SB4wPPF/P4Q2HsyswBz4pDn7k8lZDmVN8rbLIrN5Dw
         r0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=M68ICgKbxlCQqoMVu694WmBCQEFTFLTaV3AEkmDCixI=;
        b=aS7gBU2ZZHSsMdEHyaUyXiRPRCBrgjQkdkTsu7QJkFSV9DuEN6pAYS84GUkTDC6DpS
         sxxWUZZOrZVJ6iqduFTLv8AuTiUbiDh+IvGlpJTNxyL0V3a0yFECDe3++PuxYxViCff3
         zv6gcHX3Agd6aVUaafgc3xlV6fnL8DSh2BDC3BRvas81MSza9S5kohrDlnAu8L+lGKpY
         VEJtuBjSbTddZbjg7SCY+Q/R1GOoepnHS5LhO7TONJTAtWvpX2vIKhlfBlUCoNfH3t9M
         bIE+tlksrO2UoCfvDg7hZS9r/g8gw9y5tgEPofZhBWGrdOBDD0nGHaKxj2/pWaDTPu0u
         0rZA==
X-Gm-Message-State: AOAM533HC3kkVf9+wT5I9y6tj7OgMtXIjssGmqjc1OlCdmUscLASxfZx
        0xG5JefN8FlHFmw4dar7ioDLnyJRdu4=
X-Google-Smtp-Source: ABdhPJxj0rD4vjyVUbHm7wTZOX0MRuv5/mdhvbzxHe+8U+GXFprQ9GvxdCOBEkMZMFhEufrFQ/iDgw==
X-Received: by 2002:ac8:7a90:0:b0:2e1:d84f:1164 with SMTP id x16-20020ac87a90000000b002e1d84f1164mr16902825qtr.314.1649434224825;
        Fri, 08 Apr 2022 09:10:24 -0700 (PDT)
Received: from fionn.redhat.com (bras-base-rdwyon0600w-grc-11-174-88-121-127.dsl.bell.ca. [174.88.121.127])
        by smtp.gmail.com with ESMTPSA id j1-20020a05620a410100b0067ec5ecac66sm15361722qko.19.2022.04.08.09.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 09:10:24 -0700 (PDT)
Sender: John Kacur <jkacur@gmail.com>
From:   John Kacur <jkacur@redhat.com>
To:     lkml <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveria <bristot@kernel.org>
Cc:     RT <linux-rt-users@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org, John Kacur <jkacur@redhat.com>
Subject: [PATCH v2] rtla: Minor grammar fix for rtla README
Date:   Fri,  8 Apr 2022 12:10:12 -0400
Message-Id: <20220408161012.10544-1-jkacur@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

- Change to "The rtla meta-tool includes"
- Remove an unnecessary "But, "
- Adjust the formatting of the paragraph resulting from the changes.
- Simplify the wording for the libraries and tools.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/tracing/rtla/README.txt | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/tracing/rtla/README.txt b/tools/tracing/rtla/README.txt
index 6c88446f7e74..0fbad2640b8c 100644
--- a/tools/tracing/rtla/README.txt
+++ b/tools/tracing/rtla/README.txt
@@ -1,15 +1,13 @@
 RTLA: Real-Time Linux Analysis tools
 
-The rtla is a meta-tool that includes a set of commands that
-aims to analyze the real-time properties of Linux. But, instead of
-testing Linux as a black box, rtla leverages kernel tracing
-capabilities to provide precise information about the properties
-and root causes of unexpected results.
+The rtla meta-tool includes a set of commands that aims to analyze
+the real-time properties of Linux. Instead of testing Linux as a black box,
+rtla leverages kernel tracing capabilities to provide precise information
+about the properties and root causes of unexpected results.
 
 Installing RTLA
 
-RTLA depends on some libraries and tools. More precisely, it depends on the
-following libraries:
+RTLA depends on the following libraries and tools:
 
  - libtracefs
  - libtraceevent
-- 
2.35.1

