Return-Path: <SRS0=grb/=RR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A89C4360F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 217BB20811
	for <linux-trace-devel@archiver.kernel.org>; Thu, 14 Mar 2019 15:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfCNPKq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:10:46 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:37870 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfCNPKp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 11:10:45 -0400
Received: by mail-pf1-f169.google.com with SMTP id 8so621171pfr.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 14 Mar 2019 08:10:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hcirEjwUJgEEtaMfUBUC6GWeKcLAiAjHfhiUllCOh+s=;
        b=MB2H0q+geQMRgUAeV81vFeP4Gr8MLU1EHrd5o4EMmYPr+bcOROzN9Hv6sAk8ivm1xV
         jL68oOmgWJxmrH1RbMedfwFWwQKAUIS4+X6532uSccw0EImwbtNbV9AlcV5MG7dwF1YG
         Tu7IH/SiNO3VGamlvHoWiJuB8us8K6oqBd12Rz/mdf9lbAJKU7iEoJzrmWvxQ+G5EtiC
         QD2TC38AMpVnz80Ll7ByJ7fUOFswerCuKtB8lxPxRZkQ/W07LkPODXgd/9mJcnH+IVXd
         79olyskRgBFGdL5mJ6ML2/48frA75V/wbekGfeFHlxIGT2n5hC04IPNfC9ipLSkojERl
         HmNg==
X-Gm-Message-State: APjAAAXM8YnPXsB/RS70c9tMeSFniJXSfVspYRzOWn9GuVn9EeWY1jOx
        TF9ZSfn5e7i0TbBxHeRsL6rTg4jh
X-Google-Smtp-Source: APXvYqx4DFCE4SBtHJxQEJzAtC7iA9ubrAkiwY+7yqUYCLIWte3CSAsPS09cuMdzwffOISQoUHFS2A==
X-Received: by 2002:a63:4e4e:: with SMTP id o14mr4641314pgl.254.1552576245107;
        Thu, 14 Mar 2019 08:10:45 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id f65sm8165585pfg.98.2019.03.14.08.10.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Mar 2019 08:10:44 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 08/12] kernel-shark: Fix memory leak in KsPlotget::getTaskColorTable()
Date:   Thu, 14 Mar 2019 17:10:08 +0200
Message-Id: <20190314151012.905-9-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190314151012.905-1-ykaradzhov@vmware.com>
References: <20190314151012.905-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The std::vector constructor used here makes a copy of the data, so
the memory used by the original array has to be freed.

This is a major leak because getTaskColorTable() gets called every
time when we redraw the plots.

BTW calling getTaskColorTable() every time when we redraw makes
no sense. This will be fixed in the following patch.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsPlotTools.cpp | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel-shark/src/KsPlotTools.cpp b/kernel-shark/src/KsPlotTools.cpp
index d07f414..2b16a51 100644
--- a/kernel-shark/src/KsPlotTools.cpp
+++ b/kernel-shark/src/KsPlotTools.cpp
@@ -122,6 +122,8 @@ ColorTable getTaskColorTable()
 	std::vector<int> temp_pids(pids, pids + nTasks);
 	std::sort(temp_pids.begin(), temp_pids.end());
 
+	free(pids);
+
 	if (temp_pids[i] == 0) {
 		/* The "Idle" process (pid = 0) will be plotted in black. */
 		colors[i++] = {};
-- 
2.19.1

