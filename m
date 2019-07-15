Return-Path: <SRS0=+PQ5=VM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2C1C7618F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF822206B8
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Jul 2019 13:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HVPTOcMR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfGONVQ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 09:21:16 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:43763 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730111AbfGONVQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 09:21:16 -0400
Received: by mail-wr1-f52.google.com with SMTP id p13so17050311wru.10
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Jul 2019 06:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/SFIG3WhQRa08ZElW+0x0zoAVo5qA8gdh06oHJ4LEA=;
        b=HVPTOcMRvdi6/F3kr9MMZbexHjJCEUkf5i+i9Rj1IBCqKsXKDSV4+KxQwOcJYPET23
         uFKfe+ueDPWEiR0NIEtuCrauSmNvvq3JhkVps/NFhVLnLF8CNjASn6y0qZ8mjNl6M5BJ
         USss85etJy96NGihNgi8jecB3uey8cqzcQAOPFuvHtGixGSK+zB4VgJ3M/kXzZqDUE/2
         Cuhc9sBbCgV7aMrAq6hFzCB5UlbXo71nNtjkHvWXVmm/N0eWc+odRBlToAQjzLR8P6bd
         rZYpOfFzm9o6bgRLVZ3v60eCfX8hbhp/yK2qjkVUpmFdd7SM61lq51sRCq7Z1plZeMVw
         q3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y/SFIG3WhQRa08ZElW+0x0zoAVo5qA8gdh06oHJ4LEA=;
        b=VwYiMfWladf4BnMcHOAwHO3gVLcnHc0MVkS4v1bvIc4CYr529UEmWr52xTBb9arr0b
         rlRNoee5Zlqq4ZNG1Zs5la121UurS8Jpw8WCFTclx15SjqnjOxZfhRNS4QrOoXgvZ81Z
         vPZ6JYJqo6fN8diQdRQ0QTwowW2ntGTGqbLPtiZ2GJ8vrhXPSILywRnhcKT7YFdyO2UT
         alAkRi7b8+BcRTZS8t/z5nrA6Hc9c94eNoTToKkMmaUm2kuA887UHAnhzTP3p8/Hcq+m
         WCwHCPPnRC09Vy5+O1YsquJBCTO3pkFyw8qb9V2faoNtGZBfZpApnbeb3SObiQSv6yh5
         xqVg==
X-Gm-Message-State: APjAAAWCOYlDwVv/SD1ZCV74zgRksONsZBdLFdqGltCV/rO/xTG4hByU
        92nlqHnFMey6gDcKFpRgMjubJePOYLs=
X-Google-Smtp-Source: APXvYqzH9MHyzwuvDTlbD1Ltpo0RBZcQ9Bpqk4l1HfeuzNn8Xl3PRiyvGMGvC9/8cH+xvnMeMKfEJA==
X-Received: by 2002:a5d:4b50:: with SMTP id w16mr22220431wrs.132.1563196874307;
        Mon, 15 Jul 2019 06:21:14 -0700 (PDT)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c78sm23819426wmd.16.2019.07.15.06.21.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 06:21:13 -0700 (PDT)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 0/3] Fixes needed befor KS 1.0
Date:   Mon, 15 Jul 2019 16:20:39 +0300
Message-Id: <20190715132042.5154-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Yordan Karadzhov (VMware) (3):
  kernel-shark: The graph widget must follow the active marker
  kernel-shark: Always clear the marker after resizing the table.
  kernel-shark: Don't try to update the markers if no data is loaded

 kernel-shark/src/KsMainWindow.cpp  | 18 ++++++++++++------
 kernel-shark/src/KsMainWindow.hpp  |  2 ++
 kernel-shark/src/KsTraceViewer.cpp | 17 +++++++++++++----
 3 files changed, 27 insertions(+), 10 deletions(-)

-- 
2.20.1

